<?php

/** Loads the WordPress Environment and Template */
ob_start();

define('WP_USE_THEMES', false);
require_once('../../../wp-load.php');
wp();
get_header();

ob_end_clean();

error_reporting(E_ALL);
ini_set('display_errors', true);

/** video config **/
if(!defined('DS')) {
	define('DS', DIRECTORY_SEPARATOR);
}
define('PHPVIDEOTOOLKIT_FFMPEG_BINARY', '/usr/bin/ffmpeg');
require_once 'phpvideotoolkit/phpvideotoolkit.php5.php';
$toolkit = new PHPVideoToolkit('/tmp');
/** END video config **/



$number = (int)$_GET['videos'];
if ($number <= 0) $number = 10;


$args = array(
	'post_type' => 'post'
,	'post_status' => null
,	'numberposts' => $number
);
$attachArgs = array(
	'post_type' => 'attachment'
,	'numberposts' => 1
,	'post_status' => null
,	'post_parent' => null
);

$json = array();
$uploads = wp_upload_dir();

$posts = get_posts($args);
if ($posts) {
	//echo 'we got '.count($posts).' posts<br />';
	foreach ($posts as $post) {
		$oPost = $post;
		$attachArgs['post_parent'] = $post->ID;
		
		$attachments = get_posts($attachArgs);
		
		if (!$attachments || count($attachments) <= 0) continue;
		
		setup_postdata($attachments[0]);
		
		$url = wp_get_attachment_url($attachments[0]->ID, false);
		
		$filePath = $uploads['basedir'].substr($url, strlen($uploads['baseurl']));
		
		$ok = $toolkit->setInputFile($filePath);
		if(!$ok)
		{
// 			if there was an error then get it 
			echo $toolkit->getLastError()."<br /><br />\r\n";
			$toolkit->reset();
			continue;
		}
		
		$info = $toolkit->getFileInfo();
		
		$json[] = array(
			'name' => apply_filters( 'the_title', $attachments[0]->post_title )
		,	'author' => get_the_author()
		,	'length' => $info['duration']['timecode']['rounded']
		,	'url' => $url
		);
	}
}

header('Content-Type: application/json');
echo json_encode($json);
