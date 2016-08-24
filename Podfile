# 以下是注释说明举例
# pod 'AFNetworking', '~> 1.0' // 版本号可以是1.0，可以是1.1，1.9，但必须小于2
# pod ‘AFNetworking’, ‘>=1.0’ //大于等于1.0版本的都可以
# pod 'AFNetworking', '1.0' // 版本号指定为1.0
# pod 'AFNetworking',  // 不指定版本号，任何版本都可以
# 在最初输入 link_with ‘targetName’,’otherTargetName’   将会将两个target都使用相同的依赖库
# 在’target’ do    和   end   之间书写,则会制定哪个target对应哪些依赖库


# podfile.lock主要用于多人开发,锁定版本
# pod install常规使用即可,根据Podfile文件指定的内容，安装依赖库，如果有Podfile.lock文件而且对应的Podfile文件未被修改，则会根据Podfile.lock文件指定的版本安装。
# pod update 若果Podfile中指定的依赖库版本不是写死的，当对应的依赖库有了更新，无论有没有Podfile.lock文件都会去获取Podfile文件描述的允许获取到的最新依赖库版本
# 以下两个方法可以加快install速度
# pod install --verbose --no-repo-update
# pod update --verbose --no-repo-update
platform :ios, ‘8.0’
pod 'FMDB/SQLCipher'   # FMDB with SQLCipher