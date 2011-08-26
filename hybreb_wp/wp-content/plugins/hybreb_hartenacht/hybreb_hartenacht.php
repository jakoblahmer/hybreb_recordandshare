<?php
/*
Plugin Name: Hybreb Harte Nacht
Plugin URI: http://www.hybreb.at
Description: Hybreb Plugin
Version: 0.1
Author: Jakob Lahmer
Author URI: 
License: 
*/


class Hybreb_HarteNacht	{
	
	public static function init() {
		
		
		// embed the javascript file that makes the AJAX request
		//wp_enqueue_script( 'a1social', plugin_dir_url( __FILE__ ) . 'js/a1socialmedia.js', array( 'jquery' ) );
 
		// declare the URL to the file that handles the AJAX request (wp-admin/admin-ajax.php)
		//wp_localize_script( 'a1social', 'A1SocialMedia', array( 'ajaxurl' => admin_url( 'admin-ajax.php' ) ) );
		
		
		self::addFilters();
		self::addActions();
		// multilang
//		load_plugin_textdomain('A1_Author_SocialMedia', false, dirname(plugin_basename(__FILE__ )));
		return true;
	}
	
	
	
	/**
	 * adds the rewrite rules, to access the plugin directly
	 */
	public static function doRewriteRules() {
		//global $wp_rewrite;

		//add_rewrite_rule('login/?$', 'wp-login.php', 'top');
		add_rewrite_rule('list-videos/?$', 'wp-content/plugins/hybreb_hartenacht/fetchVideos.php', 'top');
		//$wp_rewrite->flush_rules(true);
		flush_rewrite_rules();
		//wp_register_style('a1socialmediacss', plugin_dir_url( __FILE__ ) . 'css/a1socialmedia.css');
		//wp_enqueue_style('a1socialmediacss');
	}
	
	/**
	 * adds the filters
	 */
	private static function addFilters() {
		// add input fields
		//add_filter('user_contactmethods', array('A1_Author_SocialMedia', 'addSocialMediaContact'));
	}

	private static function addActions() {
		//add_action('edit_user_profile', array('A1_Author_SocialMedia', 'addSpecialSocialMedia'));
		//add_action('show_user_profile', array('A1_Author_SocialMedia', 'addSpecialSocialMedia'));
		//add_action('profile_update', array('A1_Author_SocialMedia', 'saveSpecialSocialMedia'), 10, 1);
		
		//add_action('admin_print_styles', array('A1_Author_SocialMedia', 'my_admin_styles'));
		//add_action('a1_socialmedia_print', array('A1_Author_SocialMedia', 'print_socialMedia'));
		add_action('init', array('Hybreb_HarteNacht', 'doRewriteRules'));
	}
}


// init plugin
if(!Hybreb_HarteNacht::init())	{
	echo 'Plugin Hybreb_HarteNacht was not initialized correctly!';
}


?>