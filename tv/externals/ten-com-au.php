<?php

//require the wordpress codex
require( '../wp-load.php' );
require( './meta-data.php' );
require('./featured-image.php');

$urls = array(
array("url"=>"http://tenplay.com.au/Handlers/GenericUserControlRenderer.ashx?path=~/UserControls/Content/C01/C01%20Listing.ascx&props=DataSourceID,{C8F9B9DC-7421-45C3-8543-E1725FD44059}|StartIndex,1|EndIndex,30","type"=>"tv") //TV
);

foreach ($urls as $url) {
	updatenews($url["url"],$url["type"]);
}

function updatenews($url,$type) {
	
	$idObj = get_category_by_slug('ten');
	
	// Get the json from the URL
	$html = file_get_contents($url);

	// Parse the json
	$doc = DOMDocument::loadHTML($html);
	$results = $doc->getElementsByTagName('li');

	// look for the results withint the html snip
	foreach ($results as $result) {

		$node = $result->getElementsByTagName('a')->item(0);
		
		if(!is_null($node)){

			$link = '<h2><a href="http://tenplay.com.au'.$node->getAttribute('href').'">view</a></h2>';
			$imgdata = $node->getElementsByTagName('img')->item(0);
			$src = $imgdata->getAttribute('data-src');
			if(!strlen(trim($src))){
				$src = $imgdata->getAttribute('src');
			}
			
			$show = $result->getElementsByTagName('h2')->item(0)->nodeValue;
			$show_id = get_meta_data($show,$idObj);
			
			$title = $imgdata->getAttribute('alt');
			$img = '<a href="http://tenplay.com.au"'.$node->getAttribute('href').'><img src="'.$src.'"/></a>';
			
			// Create post object from json
			$my_post = array(
			  'post_title'    => $title,
			  'post_content'  => $img.$link,
			  'post_name'     => sanitize_title($title),
			  'post_status'   => 'publish',
			  'post_author'   => 1,
			  'post_category' => array($idObj->term_id),
			  'tags_input'	  => array($type,$show)
			);
			
			// (amay0048) TODO: Currently this association is working, but the controls and 
			// interface are broken. I'll have a further look into types
			// to work out why this is, but currently it's good to test
			if($show_id){
				$my_post['post_parent'] = $show_id;
			}
			// Create lookup params to see if the post exists
			$args = array(
			  'name' => sanitize_title($title),
			  'post_type' => 'post',
			  'post_status' => 'any',
			  'numberposts' => 1
			);
			
			$my_posts = get_posts($args);
			
			// If we find a post with this slug, don't create it
			if( $my_posts ) {
				//log('ID on the first post found '.$my_posts[0]->ID);
			} else {
				// Else, insert the post into the database
				$postid = wp_insert_post($my_post);
				featured_image($postid,$src);
			}
		}//endif
	}

}

?>