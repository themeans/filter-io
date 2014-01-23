<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Ravshanbek
 * Date: 04.05.12
 * Time: 17:31
 * To change this template use File | Settings | File Templates.
 */
class Like_Widget_MostLikedPhotosController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $this->view->item_type = $item_type = 'album_photo';
    $api = Engine_Api::_()->getApi('core','like');

    $settings = Engine_Api::_()->getApi('settings','core');
    $ipp = $settings->getSetting('like.photo.count',9);
    $this->view->period = $period = $settings->getSetting('like.photo.period',1);

    $likes = $api->getMostLikedData($item_type,$ipp);
    if(!count($likes))
    {
      return $this->setNoRender();
    }

    if($period)
    {
      $this->view->week_likes = $week_likes = $api->getMostLikedData($item_type,$ipp,'week');
      $this->view->month_likes = $month_likes = $api->getMostLikedData($item_type,$ipp,'month');
    }
    $this->view->all_likes = $all_likes = $likes;

    $path = Zend_Controller_Front::getInstance()->getControllerDirectory('like');
    $path = dirname($path) . '/views/scripts';
    $this->view->addScriptPath($path);

    $this->getElement()->setAttrib('class', 'like_widget_theme_' . $this->view->activeTheme());
  }
}
