<?php
require_once 'class.textfield.php';

/**
 * Description of class
 *
 * @author Srdjan
 */
class WPToolset_Field_File extends WPToolset_Field_Textfield
{

    protected $_validation = array('required');
    //protected $_defaults = array('filename' => '', 'button_style' => 'btn2');

    public function init() {
        self::_registerScripts();    
    }

    protected static function _registerScripts() {
        wp_register_script( 'wptoolset-field-file',
                WPTOOLSET_FORMS_RELPATH . '/js/file.js', array('jquery'),
                WPTOOLSET_FORMS_VERSION, true );
        wp_register_style( 'wptoolset-field-file',
                WPTOOLSET_FORMS_RELPATH . '/css/file.css', array(),
                WPTOOLSET_FORMS_VERSION );
    }

    public function enqueueScripts() {
        wp_enqueue_script( 'wptoolset-field-file' );
        add_thickbox();
        global $post;
        $for_post = (!empty( $post->ID ) ? 'post_id=' . $post->ID . '&' : '');
        $js_data = array('title' => __( 'Select file' ), 'for_post' => $for_post, 'adminurl' => admin_url());
        wp_localize_script( 'wptoolset-field-file', 'wptFileData', $js_data );
    }

    public function enqueueStyles() {
        wp_enqueue_style( 'wptoolset-field-file' );
    }

    public function metaform() {
        $value = $this->getValue();
        $form = array();
        $preview = '';
        
        // Get attachment by guid
        if ( !empty( $value ) ) {
            global $wpdb;
            $attachment_id = $wpdb->get_var( $wpdb->prepare( "SELECT ID FROM {$wpdb->posts} WHERE post_type = 'attachment' AND guid=%s", $value ) );
        }

        // Set preview
        if ( !empty( $attachment_id ) ) {
            $preview = wp_get_attachment_image( $attachment_id, 'thumbnail' );
        } else {
            // If external image set preview
            $file_path = parse_url( $value );
            if ( $file_path && isset( $file_path['path'] ) )
                    $file = pathinfo( $file_path['path'] );
            else $file = pathinfo( $value );
            if ( isset( $file['extension'] ) && in_array( strtolower( $file['extension'] ),
                            array('jpg', 'jpeg', 'gif', 'png') ) ) {
                $preview = '<img alt="" src="' . $value . '" />';
            }
        }

        // Set button
        $button = '<a href="#" class="js-wpt-file-upload button-secondary">'
                . sprintf( __( 'Select %s' ), $this->getType() ) . '</a>';

        // Set form
        $form[] = array(
            '#type' => 'textfield',
            '#name' => $this->getName(),
            '#title' => $this->getTitle(),
            '#value' => $value,
            '#suffix' => '&nbsp;' . $button,
            '#validate' => $this->getValidationData(),
        );

        $form[] = array(
            '#type' => 'markup',
            '#markup' => '<div class="js-wpt-file-preview wpt-file-preview">' . $preview . '</div>',
        );

        return $form;
    }

    public static function mediaPopup() {
        self::_registerScripts();
        wp_enqueue_script( 'wptoolset-field-file' );
        wp_enqueue_style( 'wptoolset-field-file' );
        // Add types button
        add_filter( 'attachment_fields_to_edit',
                array('WPToolset_Field_File', 'attachmentFieldsToEditFilter'),
                9999, 2 );
        // Filter media TABs
        add_filter( 'media_upload_tabs',
                array('WPToolset_Field_File', 'mediaUploadTabsFilter') );
        // Add head data
        add_filter( 'admin_head',
                array('WPToolset_Field_File', 'mediaPopupHead') );
    }

    /**
     * Adds column to media item table.
     * 
     * @param type $form_fields
     * @param type $post
     * @return type 
     */
    public static function attachmentFieldsToEditFilter( $form_fields, $post ) {
        // Reset form
        $form_fields = array();
        $type = (strpos( $post->post_mime_type, 'image/' ) !== false) ? 'image' : 'file';
        $url = wp_get_attachment_url( $post->ID );
        $form_fields['wpt_fields_file'] = array(
            'label' => __( 'Toolset' ),
            'input' => 'html',
            'html' => '<a href="#" title="' . $url
            . '" class="js-wpt-file-insert-button'
            . ' button-primary" onclick="wptFile.mediaInsertTrigger(\''
            . $url . '\', \'' . $type . '\')">'
            . __( 'Use as field value', 'wpcf' ) . '</a><br /><br />',
        );
        return $form_fields;
    }

    /**
     * Filters media TABs.
     * 
     * @param type $tabs
     * @return type 
     */
    public static function mediaUploadTabsFilter( $tabs ) {
        unset( $tabs['type_url'] );
        return $tabs;
    }

    /**
     * Media popup head.
     */
    function mediaPopupHead() {
        ?>
        <script type="text/javascript">
        <?php
        if ( isset( $_GET['wpt']['type'] ) && in_array( $_GET['wpt']['type'],
                        array('audio', 'video') ) ):

            ?>
                jQuery(document).ready(function($) {
                    $('#media-upload-header').after('<div class="message updated"><p><?php
            printf( esc_js( __( 'Please note that not all video and audio formats are supported by the WordPress media player. Before you upload media files, have a look at %ssupported media formats%s.' ) ),
                    '<a href="http://wp-types.com/documentation/user-guides/adding-audio-video-and-other-embedded-content-to-your-site/" target="_blank">',
                    '</a>' );

            ?></p></div>');
                });
        <?php endif; ?>
        </script>
        <style type="text/css">
            tr.submit, .ml-submit, #save, #media-items .A1B1 p:last-child  { display: none; }
        </style>
        <?php
    }
}