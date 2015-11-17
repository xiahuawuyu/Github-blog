title: 摇周边申请流程
tags:
---

<!-- more -->

# 准备条件
* 微信公众号
* iBeacon设备。http://kf.qq.com/faq/120911VrYVrA150410Y7NjiY.html，这里提供了可选设备列表，设备名称和厂商正确，不过网址已经过时，直接去网上购买就行，价格也就几十一个~
* 开着蓝牙装着微信的智能手机

# 后端配置

申请功能和设备开通“摇一摇周边”功能，和 **后台配置**同时进行。 **都是采用https协议，POST请求，json格式数据。**

## 功能开通

### 申请开通摇周边功能

#### 请求地址
https://api.weixin.qq.com/shakearound/account/register?access_token=ACCESS_TOKEN

#### 参数
    {
      "name": "联系人姓名，不超过20汉字或40个英文字母",
      "phone_number": "联系人电话",
      "email": "联系人邮箱",
      "industry_id": "平台定义的行业代号，具体请查看链接[行业代号](http://3gimg.qq.com/shake_nearby/Qualificationdocuments.html)",
      "qualification_cert_urls": [
      "相关资质文件的图片url，图片需先上传至微信侧服务器，用“素材管理-上传图片素材”接口上传图片，返回的图片URL再配置在此处"
      ]
    }

#### 返回值
    {
       "data": {},
       "errcode": 0,
       "errmsg": "success."
    }

### 查询审核状态

#### 请求地址
https://api.weixin.qq.com/shakearound/account/auditstatus?access_token=ACCESS_TOKEN

#### 返回值
    {
        "data": {
            "apply_time": 提交申请的时间戳,
            "audit_comment": "审核备注，包括审核不通过的原因",
            "audit_status": 审核状态。0：审核未通过、1：审核中、2：审核已通过；审核会在三个工作日内完成,
            "audit_time": 确定审核结果的时间戳；若状态为审核中，则该时间值为0
        },
        "errcode": 0,
        "errmsg": "success."
    }

>[官方文档](http://mp.weixin.qq.com/wiki/13/025f1d471dc999928340161c631c6635.html)

## 设备配置

### 申请设备id

#### 请求地址
https://api.weixin.qq.com/shakearound/device/applyid?access_token=ACCESS_TOKEN

#### 参数
    {
       "quantity":申请的设备ID的数量，单次新增设备超过500个，需走人工审核流程,
       "apply_reason":"申请理由，不超过100个汉字或200个英文字母"
    }

#### 返回值
    {
    "data": {
                   "apply_id": 123,
        "audit_status": 1,  
        "audit_comment": "审核中"  
       },
       "errcode": 0,
       "errmsg": "success."
    }

### 查询设备ID申请审核状态

#### 请求地址
https://api.weixin.qq.com/shakearound/device/applystatus?access_token=ACCESS_TOKEN

#### 请求参数
    {
       "apply_id": 批次ID，申请设备ID时所返回的批次ID  
    }

#### 返回值
    {
        "data": {
            "apply_time": 1432026025,
            "audit_comment": "test",
            "audit_status": 1,
            "audit_time": 0
        },
        "errcode": 0,
        "errmsg": "success."
    }

>[官方文档](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html)

## 页面配置（可选）

### 查询页面id

#### 请求地址
https://api.weixin.qq.com/shakearound/page/search?access_token=ACCESS_TOKEN

#### 返回值
    {
        "type": 1,
        "page_ids":[12345, 23456, 34567]
    }

### 编辑页面信息

#### 请求地址
https://api.weixin.qq.com/shakearound/page/update?access_token=ACCESS_TOKEN

#### 参数
    {
     "page_id":""
     "title":"页面标题，最多6个字",   
     "description":"页面副标题，最多7个字", 
     "page_url":"页面路径", 
     "icon_url":"页面图片路径"
    }

#### 返回值
    {
        "data": {
            
        },
        "errcode": 0,
        "errmsg": "success."
    }

>[官方文档](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html)

# 后台配置

点击左边的 **页面配置** 进行编辑并配置到对应的设备上，一个页面可以配置到多个设备，但是一个设备只能关联到一个页面。同时下载设备列表（一个xls文件）

{% asset_img page-config-1.png %}

{% asset_img page-config-2.png %}

# 设备配置

微信给出的教程是使用手机软件通过蓝牙连接进行配置，个人偏好用电脑数据线连接配置。从官网上下载一个配置软件，连接设备之后，启动设备读取信息。
根据上一步得到的设备列表文件，找到之前申请的设备id，将UUID、majorId、minorId写入设备。
{% asset_img device-config.png %}

# 页面开发

页面和设备关联之后，先启动设备，打开手机蓝牙，切换到微信摇一摇，如果手机在设备周边就会出现一个 **“周边”** ，这里会出现配置的页面，点击之后微信内置浏览器会打开页面，如下形式：
http://abc.com/xx.html?ticket=9255cca12ad1bfc8fcafd0994e7ecdf4&activityid=918158
url中传入两个参数：ticket和activityid，activityid暂时未用到，ticket可以和access_token查询用户的openId，从而调用jsapi。
这里的例子是先判断是否关注微信公众号，如果未关注则需要先关注，然后通过ticket获取openId跳转到另一个页面。

    <script type="text/javascript"
    src="http://zb.weixin.qq.com/nearbycgi/addcontact/BeaconAddContactJsBridge.js">
    </script>
    <script type="text/javascript">
        var domain = '网站域名';
        var url1 ='获取openId接口';
        var url2 = '跳转页面';
        function getQueryString(key){
            //获取querystring
        }
        BeaconAddContactJsBridge.ready(function(){
            //判断是否关注
            BeaconAddContactJsBridge.invoke('checkAddContactStatus',{} ,function(apiResult){
                if(apiResult.err_code == 0){
                    var status = apiResult.data;
                    if(status == 1){
                        //调用本地页面，通过ticket获取openId
                        $.get(domain+url1+getQueryString('ticket'),function(resp){
                            if(resp.data) openId = resp.data.openid;
                            url2 += openId;
                            location.href = url;
                        });
                    }else{
                        //跳转到关注页
                        BeaconAddContactJsBridge.invoke('jumpAddContact');
                    }
                }else{
                    alert(apiResult.err_msg)
                }
            });
        });
    </script>

[官方文档](http://mp.weixin.qq.com/wiki/3/9fe34e4bfdc162ff173d85d98dc06db3.html)

# FAQ

[微信摇一摇周边常见问题解答](http://kf.qq.com/faq/120911VrYVrA150412Izm2qi.html)



http://demo.tijianzhuanjia.com/wx/poster/shake.html?ticket=9255cca12ad1bfc8fcafd0994e7ecdf4&activityid=918458

---
