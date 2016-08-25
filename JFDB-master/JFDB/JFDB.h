//
//  JFDB.h
//  JFAppKit-master
//
//  Created by Jeffrey on 16/8/21.
//  Copyright (c) 2016 Jeffrey. All rights reserved.
//
/**
 * 目的:旨在简化数据库操作,基于FMDB二次封装
 * JFTable类:把sql里的表形象话为对象进行操作,直接用OC进行对话操作,减少了sql语句的输入
 * JFDBModel:协议,遵守后可以使用存储方法,直接对对象存储在数据库中,也支持增删改查,基于JFTable类和runtime做的封装
 * 注意:在建模型的时候,主键需要为第一个属性,如果属性为数组,且数组里放的是次级模型,则次级模型需要有一个属性和主模型主键属性一致
 * 例如:Person类主键属性为userID,且有一个数组,里面包含了Product类模型,那么Product需要有一个属性也叫userID,表示这个Product是属于哪个唯一的Person的
 * 这样才能在关联查询的时候能正确的赋值
 */



#ifndef JFDB_h
#define JFDB_h

#import "JFTable.h"
#import "NSObject+dataBase.h"

#endif /* JFDB_h */
