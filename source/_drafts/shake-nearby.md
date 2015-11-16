title: 摇周边申请流程
tags:
---

<!-- more -->

# 后端配置

## 功能开通

**都是采用https协议，POST请求，json格式数据。**

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

[官方文档](http://mp.weixin.qq.com/wiki/13/025f1d471dc999928340161c631c6635.html)

## 设备配置

### 申请设备id

https://api.weixin.qq.com/shakearound/device/applyid?access_token=ACCESS_TOKEN
{
   "quantity":2,  
   "apply_reason":"配合开展线下活动、推广"
}

### 查询设备ID申请审核状态

https://api.weixin.qq.com/shakearound/device/applystatus?access_token=ACCESS_TOKEN

[官方文档](http://mp.weixin.qq.com/wiki/15/b9e012f917e3484b7ed02771156411f3.html)

### 
[](http://kf.qq.com/faq/120911VrYVrA150410Y7NjiY.html)

## 页面配置（可选）

### 查询页面id
https://api.weixin.qq.com/shakearound/page/search?access_token=ACCESS_TOKEN

### 编辑页面信息
https://api.weixin.qq.com/shakearound/page/update?access_token=ACCESS_TOKEN
{
 "page_id":""
 "title":"页面标题，最多6个字",   
 "description":"页面副标题，最多7个字", 
 "page_url":"页面路径", 
 "icon_url":"页面图片路径"
}

[官方文档](http://mp.weixin.qq.com/wiki/5/6626199ea8757c752046d8e46cf13251.html)

# 后台配置

# 设备配置

# 页面开发

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
