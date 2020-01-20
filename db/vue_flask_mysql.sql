/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50717
Source Host           : localhost:3306
Source Database       : vue_flask_mysql

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2020-01-20 14:26:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `customer`
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of customer
-- ----------------------------
INSERT INTO `customer` VALUES ('1', '牛', '广西贵港');
INSERT INTO `customer` VALUES ('2', '羊', '广东深圳');
INSERT INTO `customer` VALUES ('3', '马', '云南西双版纳');
INSERT INTO `customer` VALUES ('4', '狗', '北京朝阳区');
INSERT INTO `customer` VALUES ('5', '鼠', '广西北海');
INSERT INTO `customer` VALUES ('6', '鸡', '福建厦门');
INSERT INTO `customer` VALUES ('7', 'ydc', '广西桂平');
INSERT INTO `customer` VALUES ('8', '张三', '湖南长沙');
INSERT INTO `customer` VALUES ('9', '李四', '上海秦皇岛');
INSERT INTO `customer` VALUES ('10', '吴五', '海南海口');
INSERT INTO `customer` VALUES ('11', '杨达成', '广西贵港');
INSERT INTO `customer` VALUES ('12', '杨达成1', '广西贵港');
INSERT INTO `customer` VALUES ('14', '测试1', '测试1');
INSERT INTO `customer` VALUES ('15', '测试2', '测试2');
INSERT INTO `customer` VALUES ('16', '测试3', '测试3');

-- ----------------------------
-- Table structure for `order`
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(100) NOT NULL,
  `from_address` varchar(100) NOT NULL,
  `to_address` varchar(100) NOT NULL,
  `goods` varchar(100) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('1', '18376522253', '广州', '杭州', '鞋子', '1');
INSERT INTO `order` VALUES ('2', '18376522253', '烟台', '长沙', '台灯', '1');
INSERT INTO `order` VALUES ('3', '18376522251', '深圳', '钦州', '手机', '2');
INSERT INTO `order` VALUES ('4', '18376522254', '北京', '新疆', '麦片', '3');
INSERT INTO `order` VALUES ('5', '18376522255', '贵州', '福建', '茅台酒', '4');
INSERT INTO `order` VALUES ('6', '18376522256', '上海', '天津', '笔记本电脑', '5');

-- ----------------------------
-- Table structure for `tab`
-- ----------------------------
DROP TABLE IF EXISTS `tab`;
CREATE TABLE `tab` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tab
-- ----------------------------
INSERT INTO `tab` VALUES ('1', '用户管理');
INSERT INTO `tab` VALUES ('2', '订单管理');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(30) DEFAULT NULL,
  `mobile` varchar(11) DEFAULT NULL,
  `portrait` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `introduce` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'ydc', 'pbkdf2:sha256:50000$DAFdybkc$10d6a64f28cd6eed220b0a93005afc96766196fca96ed18f04b388759b2d8aab', 'ydc@qq.com', null, null, null, null);
INSERT INTO `user` VALUES ('2', 'ydc1', 'pbkdf2:sha256:50000$dlfVTnvC$56725df74f9f67bf164bdef33281377d2906a74ec692ec5fd609b0089d5f134c', 'ydc1@qq.com', null, null, null, null);
