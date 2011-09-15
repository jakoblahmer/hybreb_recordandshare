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
		self::addFilters();
		self::addActions();
		return true;
	}
	
	
	
	/**
	 * adds the rewrite rules, to access the plugin directly
	 */
	public static function doRewriteRules() {
		add_rewrite_rule('list-videos/(.*)/?$', 'wp-content/plugins/hybreb_hartenacht/fetchVideos.php?videos=$1', 'top');
		add_rewrite_rule('add-video/(.*)/?$', 'wp-content/plugins/hybreb_hartenacht/addVideo.php?userId=$1', 'top');
		flush_rewrite_rules(true);
	}

	public static function removeRewriteRules() {
		flush_rewrite_rules(true);
	}
	
	/**
	 * adds the filters
	 */
	private static function addFilters() {
		// no filters for this plugin
	}

	private static function addActions() {
		register_activation_hook(__FILE__, array('Hybreb_HarteNacht', 'doRewriteRules'));
		register_deactivation_hook(__FILE__, array('Hybreb_HarteNacht', 'removeRewriteRules'));
	}
}


// init plugin
if(!Hybreb_HarteNacht::init())	{
	echo 'Plugin Hybreb_HarteNacht was not initialized correctly!';
}

?>