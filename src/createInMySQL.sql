/*
MySQL Data Transfer
Source Host: localhost
Source Database: shequn
Target Host: localhost
Target Database: shequn
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for advice
-- ----------------------------
CREATE TABLE `advice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category` smallint(6) NOT NULL,
  `userId` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `advice` varchar(254) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `addTime` datetime DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for article
-- ----------------------------
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',  
  `title` varchar(255) DEFAULT NULL COMMENT '标题',
  `postdate` datetime DEFAULT NULL COMMENT '发布时间',
  `author` varchar(50) DEFAULT NULL COMMENT '作者',
  `account` varchar(50) DEFAULT NULL ,
  `content` mediumtext COMMENT '内容',
  `thumbwrp` varchar(255) DEFAULT NULL,
  `copyrightlogo` varchar(50) DEFAULT NULL,
  `bgimg` varchar(255) DEFAULT NULL COMMENT '大图',
  `signature` varchar(255) DEFAULT NULL COMMENT '签名',
  `likenum` int(11) DEFAULT '0' COMMENT '点赞数',
  `readnum` int(11) DEFAULT '0' COMMENT '阅读数',  
  `comments` int(11) DEFAULT '0' COMMENT '评论数',
  `hatenum` int(11) DEFAULT '0' COMMENT '拍砖数',
  `tousu` int(11) DEFAULT '0',
  `userid` int(11) DEFAULT NULL COMMENT '用户ID',
  `state` smallint(1) DEFAULT '1' , 
  `bonusnum` int(11) DEFAULT '0' COMMENT 'how many times are u given bonus',
  `pub_date` timestamp NULL DEFAULT NULL COMMENT 'this is the time the admin approved',
  `refer_id` int(11) DEFAULT NULL COMMENT 'referID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for article_collect
-- ----------------------------
CREATE TABLE `article_collect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `articleId` int(11) DEFAULT NULL,
  `collect_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `readnum` int(11) DEFAULT NULL,
  `bgimg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `urlpath` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'html file path',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for article_commend
-- ----------------------------
CREATE TABLE `article_commend` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT NULL,
  `status` smallint(1) DEFAULT NULL COMMENT '0 未解析 1解析 2解析失败',
  `hashcode` int(11) DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `add_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for complaintinfo
-- ----------------------------
CREATE TABLE `complaintinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `articleid` int(11) DEFAULT NULL COMMENT '文章ID',
  `postdate` datetime DEFAULT NULL COMMENT '投诉时间',
  `content` text COMMENT '投诉内容',
  `replydate` datetime DEFAULT NULL COMMENT '回复时间',
  `reply` text COMMENT '回复内容',
  `userid` int(11) DEFAULT NULL COMMENT '投诉用户ID',
  `contact` varchar(500) DEFAULT NULL COMMENT '投诉人联系方式',
  `state` varchar(2) DEFAULT '1' COMMENT '状态：1-已回复，0未处理',
  `adminid` int(11) DEFAULT NULL COMMENT '处理管理员ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for follow
-- ----------------------------
CREATE TABLE `follow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fwid` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'follow id on infbox server',
  `tid` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `param` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'infbox push token',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for friend
-- ----------------------------
CREATE TABLE `friend` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `myId` bigint(20) DEFAULT NULL,
  `myName` varchar(24) DEFAULT NULL,
  `myPic` varchar(100) DEFAULT NULL,
  `frdId` bigint(20) DEFAULT NULL,
  `frdName` varchar(24) DEFAULT NULL,
  `frdPic` varchar(100) DEFAULT NULL,
  `addTime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for like_unlike
-- ----------------------------
CREATE TABLE `like_unlike` (
  `luk_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `luk_user_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '点赞拍砖用户id',
  `luk_ann_id` bigint(20) NOT NULL COMMENT '公告id',
  `luk_type` int(11) DEFAULT '2' COMMENT '类型，点赞2， 拍砖1',
  `luk_create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `luk_update_time` datetime DEFAULT NULL COMMENT '更新时间，待用',
  PRIMARY KEY (`luk_id`),
  KEY `luk_luk_user_id_index` (`luk_user_id`),
  KEY `luk_luk_ann_id_index` (`luk_ann_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='点赞拍砖表';

-- ----------------------------
-- Table structure for liuyan
-- ----------------------------
CREATE TABLE `liuyan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner` int(11) DEFAULT NULL,
  `friend` int(11) DEFAULT NULL,
  `sender` int(11) DEFAULT NULL,
  `receiver` int(11) DEFAULT NULL,
  `type` tinyint(4) DEFAULT NULL,
  `content` varchar(550) DEFAULT NULL,
  `send_time` timestamp NULL DEFAULT NULL,
  `read_time` timestamp NULL DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `owner_name` varchar(30) DEFAULT NULL,
  `friend_name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for msg_consult
-- ----------------------------
CREATE TABLE `msg_consult` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `consult_type` int(11) DEFAULT NULL,
  `token` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `optionAnswer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `btnAnswer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `replyTime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for pay_log
-- ----------------------------
CREATE TABLE `pay_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `out_trade_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `reamrk` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pay_trade_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '第三方交易订单',
  `to_acct` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '第三方账号',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付成功时间',
  `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '充值 1.未支付 2已支付',
  `pay_type` tinyint(2) NOT NULL COMMENT '1.支付宝 2.微信',
  `amount` float(10,2) NOT NULL COMMENT '交易金额',
  `articleid` int(11) NOT NULL,
  `recv_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for reply
-- ----------------------------
CREATE TABLE `reply` (
  `rp_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rp_comt_id` bigint(20) NOT NULL COMMENT '评论id',
  `rp_create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '回复创建时间',
  `rp_user_id` bigint(20) NOT NULL COMMENT '回复者id',
  `rp_rp_user_id` bigint(20) NOT NULL COMMENT '被回复者id',
  `rp_content` mediumtext NOT NULL COMMENT '回复内容',
  PRIMARY KEY (`rp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回复表';

-- ----------------------------
-- Table structure for task
-- ----------------------------
CREATE TABLE `task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `begin` timestamp NULL DEFAULT NULL,
  `deadline` timestamp NULL DEFAULT NULL,
  `level` smallint(1) DEFAULT NULL,
  `supervisor` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `executor` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `finish_time` timestamp NULL DEFAULT NULL,
  `score` float DEFAULT NULL,
  `comment` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=181 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
CREATE TABLE `tb_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nickname` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `headpic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `level` smallint(2) DEFAULT NULL,
  `regTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `infbox_id` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `memo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `fans_count` int(11) DEFAULT '0',
  `idol_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `share_pyq`;
CREATE TABLE `share_pyq` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` smallint(1) DEFAULT '0',
  `content` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `add_time` datetime DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `auhtor_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author_img` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `num` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `pyq_comment`;
CREATE TABLE `pyq_comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pyq_id` int(11) DEFAULT NULL COMMENT '朋友圈id',
  `user_id` int(11) DEFAULT NULL COMMENT '当前登录人id',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当前登录人名字',
  `com_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '评论内容',
  `create_time` datetime(0) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pyq_like
-- ----------------------------
DROP TABLE IF EXISTS `pyq_like`;
CREATE TABLE `pyq_like`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pyq_id` int(11) DEFAULT NULL COMMENT '朋友圈id',
  `user_id` int(11) DEFAULT NULL COMMENT '当前登录人id',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当前登录人名字',
  `state` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime(0) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;



