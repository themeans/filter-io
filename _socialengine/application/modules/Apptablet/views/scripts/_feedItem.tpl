<?php
$action = $this->action;
$actionFormat = $this->actionFormat;
if (!$action || !$actionFormat) {
  return;
}


?>

<?php
$is_both = ((!empty($actionFormat['richContent']) && !empty($actionFormat['richContent']['photo'])) || !empty($actionFormat['attachments']));
?>

<li data-id="<?php echo $actionFormat['id'];?>" class="feedItem <?php if ($is_both): ?>both<?php endif;?>">

  <div class="content menu" style="display: none;">
    <?php if (!empty($actionFormat['canDelete'])): ?>
    <a href="javascript:void(0);" class="btn btn-danger wall-event we-remove"
       data-url="<?php echo $actionFormat['deleteUrl']?>"
       data-message="<?php echo $this->translate('Are you sure that you want to delete this activity item and all of its comments? This action cannot be undone.');?>"><?php echo $this->translate('Delete');?></a>
    <?php endif;?>
    <?php if (!empty($actionFormat['canReport'])): ?>
    <a href="<?php echo $actionFormat['reportUrl'];?>"
       class="btn"><?php echo $this->translate('WALL_MENU_Report Abuse');?></a>
    <?php endif;?>
    <?php if (!empty($actionFormat['canMute'])): ?>
    <a href="javascript:void(0);" class="btn wall-event we-mute"
       data-url="<?php echo $actionFormat['muteUrl'];?>"
       data-back="<?php echo $actionFormat['unmuteUrl'];?>"><?php echo $this->translate('WALL_MENU_Mute this post');?></a>
    <?php endif;?>
    <?php if (!empty($actionFormat['removeTagCan'])): ?>
    <a href="javascript:void(0);" class="btn wall-event we-removeTag"
       data-url="<?php echo $actionFormat['removeTagUrl'];?>"><?php echo $this->translate('WALL_MENU_Remove Tag');?></a>
    <?php endif;?>
    <a href="javascript:void(0);" class="btn btn-primary wall-event we-hideMenu"
       ><?php echo $this->translate('Cancel');?></a>
  </div>

  <div class="content action">

    <a href="javascript:void(0);" class="feedItemMenu icon-cog  wall-event we-showMenu""></a>

    <div class="thumbnail">
      <a href="<?php echo $actionFormat['subject']['href'];?>">
        <img src="<?php echo $actionFormat['photo']?>" alt=""/>
      </a>
    </div>

    <div class="poster">
      <span class="date">
        <?php echo $actionFormat['creation_date'];?>
        <?php if (!empty($actionFormat['checkin'])): ?>
        <?php echo $actionFormat['checkin']['prefix']; ?>
        <a href="<?php echo $actionFormat['checkin']['href']; ?>"><?php echo $actionFormat['checkin']['title']; ?></a>
        <?php endif;?>
      </span>
    </div>
    <div class="body">
      <?php echo $actionFormat['title'];?>
    </div>


    <?php if (!empty($actionFormat['richContent'])): ?>

    <div class="richContent <?php echo $actionFormat['richContent']['platform']; ?>">
      <?php if (isset($actionFormat['richContent']['flashObject'])): ?>
      <?php echo $actionFormat['richContent']['flashObject']; ?>
      <?php else : ?>
      <?php if (!empty($actionFormat['richContent']['photo'])): ?>

        <div class="thumb <?php echo @$actionFormat['richContent']['isVideo'] ? 'video' : '' ?>">
          <a>
            <?php if (!empty($actionFormat['richContent']['isVideo'])): ?>
            <iframe src="<?php echo $actionFormat['richContent']['iframeUrl'];?>" frameborder="0" allowfullscreen
                    width="420" height="315"></iframe>
            <?php endif;?>
            <img src="<?php echo $actionFormat['richContent']['photo']['full'];?>" alt=""/>
          </a>

          <?php if (!empty($actionFormat['richContent']['isVideo'])): ?>
          <a class="play_button icon-play-circle"></a>
          <?php endif;?>
        </div>
        <?php endif; ?>
      <?php endif; ?>
      <div class="details">
        <?php if (!empty($actionFormat['richContent']['title'])): ?>
        <div class="title"><a
          href="<?php echo $actionFormat['richContent']['href'];?>"><?php echo $actionFormat['richContent']['title'];?></a>
        </div>
        <?php endif;?>
        <?php if (!empty($actionFormat['richContent']['short_desc'])): ?>
        <div class="description"><?php echo $actionFormat['richContent']['short_desc'];?></div>
        <?php endif;?>
      </div>

    </div>
    <div style="clear: both;"></div>
    <?php endif;?>

    <?php if (!empty($actionFormat['attachments'])): ?>
    <?php if (count($actionFormat['attachments']) == 1): ?>
      <?php
      $attachment = $actionFormat['attachments'][0];
      ?>
      <div class="not-inited attachment_item <?php if ($attachment['is_album']):?>big<?php endif;?>">
        <?php if (!empty($attachment['photo'])): ?>
        <div class="thumb">
          <a data-subject="<?php echo @$attachment['href']; ?>" data-id="<?php echo @$attachment['id']; ?>" data-itemtype="<?php echo @$attachment['type']; ?>" href="<?php echo $attachment['photo']['full'];?>" class="<?php if ($attachment['is_album']):?>photoviewer<?php endif;?>">
            <img src="<?php echo $attachment['photo']['full'];?>" alt=""/>
          </a>
        </div>
        <?php endif;?>
        <div class="details">
          <?php if (!empty($attachment['title'])): ?>
          <div class="title"><a href="<?php echo $attachment['href'];?>"><?php echo $attachment['title'];?></a></div>
          <?php endif;?>
          <?php if (!empty($attachment['description'])): ?>
          <div class="description"><?php echo $attachment['description'];?></div>
          <?php endif;?>
        </div>
      </div>
      <?php else : ?>
      <?php $imgCount = count($actionFormat['attachments']) ?>
        <div class="<?php if($imgCount < 6){ ?>thumbs_container<?php }?>">
          <ul class="attachment_thumbs not-inited">
            <?php if($imgCount > 5) {?>
            <?php foreach ($actionFormat['attachments'] as $attachment): ?>
            <li>
              <?php if (!$attachment['is_album'] && !empty($attachment['title'])): ?>
                <div class="title"><a href="<?php echo $attachment['href'];?>"><?php echo $attachment['title'];?></a></div>
              <?php endif;?>
              <a data-subject="<?php echo @$attachment['href']; ?>" data-id="<?php echo @$attachment['id']; ?>" data-itemtype="<?php echo @$attachment['type']; ?>" title="<?php echo @$attachment['title']; ?>" href="<?php echo $attachment['photo']['full'];?>" class="<?php if ($attachment['is_album']):?>photoviewer<?php endif;?>"><img profile-src="<?php echo $attachment['photo']['profile'];?>"  normal-src="<?php echo $attachment['photo']['normal'];?>" src="<?php echo $attachment['photo']['normal'];?>" alt="" /></a>
            </li>
            <?php endforeach;?>
            <?php } else {?>
            <?php foreach ($actionFormat['attachments'] as $attachment): ?>
            <li>
              <?php if (!$attachment['is_album'] && !empty($attachment['title'])): ?>
                <div class="title"><a href="<?php echo $attachment['href'];?>"><?php echo $attachment['title'];?></a></div>
              <?php endif;?>
              <a data-subject="<?php echo @$attachment['href']; ?>" data-id="<?php echo @$attachment['id']; ?>" data-itemtype="<?php echo @$attachment['type']; ?>" title="<?php echo @$attachment['title']; ?>" href="<?php echo $attachment['photo']['full'];?>" class="<?php if ($attachment['is_album']):?>photoviewer<?php endif;?>"><img profile-src="<?php echo $attachment['photo']['full'];?>"  normal-src="<?php echo $attachment['photo']['profile'];?>" src="<?php echo $attachment['photo']['profile'];?>" alt="" /></a>
            </li>
            <?php endforeach;?>
            <?php }?>
          </ul>
        </div>
      <?php endif; ?>
    <div style="clear: both;"></div>
    <?php endif;?>


    <div style="clear: both;"></div>


    <div class="options">
      <?php if (!empty($actionFormat['commentable']) && (!empty($actionFormat['like_count']) || !empty($actionFormat['comment_count']))) { ?>
      <div class="left">
        <a href="<?php echo $actionFormat['href'];?>">
          <?php if (!empty($actionFormat['like_count'])): ?>
          <span class="icon icon-thumbs-up"></span> <span class="text"><?php echo $actionFormat['like_count'];?></span>
          <?php endif;?>
          <?php if (!empty($actionFormat['comment_count'])): ?>
          <span class="icon icon-comments"></span> <span class="text"><?php echo $actionFormat['comment_count'];?></span>
          <?php endif;?>
        </a>
      </div>
      <?php }?>
      <div class="right">
        <?php if (!empty($actionFormat['canComment'])): ?>
        <a item-id="<?php echo $actionFormat['id'];?>" item-type="activity_action" href="javascript:void(0)" class="btn wall-event we-showCommentModal "><i class="icon-comment-alt"></i><?php echo $this->translate('Comment');?></a>
        <?php endif;?>
        <?php if (!empty($actionFormat['canLike'])): ?>

        <a href="javascript:void(0)"
           class="btn like wall-event we-like"
           data-url="<?php echo $actionFormat['actionLikeUrl'];?>" <?php if (!empty($actionFormat['liked'])): ?>style="display: none;"<?php endif;?>>
          <i class="icon-thumbs-up"></i><span class="title"><?php echo $this->translate('Like');?></span>
        </a>

        <a href="javascript:void(0)"
           class="btn unlike wall-event we-unlike"
           data-url="<?php echo $actionFormat['actionUnlikeUrl'];?>" <?php if (empty($actionFormat['liked'])): ?>style="display: none;"<?php endif;?>>
          <i class="icon-thumbs-down"></i><span class="title"><?php echo $this->translate('Unlike');?></span>

        </a>
        <?php endif;?>

        <?php if (!empty($actionFormat['canShare'])): ?>
        <a post-url="<?php echo $actionFormat['shareUrl'];?>" class="wall-event we-showShareModal btn"><i
                  class="icon-share-alt"></i><?php echo $this->translate('Share');?></a>
        <?php endif;?>
      </div>
    </div>

  </div>
</li>

