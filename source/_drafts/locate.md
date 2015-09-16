title: 城市定位
tags:
---

考虑到浏览器兼容性和跨页面，使用cookie

    var cityId = '';
    var cityName = '';
    if (document.cookie.indexOf('cityId=') < 0) document.cookie = 'cityId=' + $('a[type="city"]:eq(0)').data('value') + ";path=/";
    if (document.cookie.indexOf('cityName=') < 0) document.cookie = 'cityName=' + encodeURIComponent($('a[type="city"]:eq(0)').text()) + ";path=/";
    var cookies = document.cookie.split(';');
    for (var i = 0; i < cookies.length; i++) {
      var key = cookies[i].split('=')[0];
      var value = cookies[i].split('=')[1];
      if ('cityId' === key.replace(/ /g, '')) cityId = value;
      if ('cityName' === key.replace(/ /g, '')) cityName = value;
    }


    //高亮选中城市
    function activate(cityId, cityName){
        $('.city-name').attr('data-value', cityId);
        $('.city-name>span').text(decodeURIComponent(cityName));
        $('a[type="city"]').each(function(){
          if(cityId===$(this).data('value')) this.className = 'active';
          else this.className = '';
        });
    }

自动定位

    if(sessionStorage && !sessionStorage.cityId){
        $(document).ready(function(){
          $.ajax({
            type: "GET",
            url: "http://api.map.baidu.com/location/ip?ak=6m2F7440LD28DpMBzQpBQFVs",
            dataType: "jsonp",
            success: function (resp) {
              var cName = resp.content.address_detail.city;
              var isLocated = false;
              $('a[type="city"]').each(function(){
                if(0===$(this).text().indexOf(cName)||0===cName.indexOf($(this).text())) {
                  isLocated = true;
                  sessionStorage.cityId = $(this).attr('data-value');
                }
              });
              sessionStorage.cityId = sessionStorage.cityId||cityId;
              controller.loadCity(sessionStorage.cityId);
            }, error: function (e) {
              if(console) console.error(e);
            }
          });
        });
      }

      //城市选择事件
    function initCitySelect(){
    $('a[type="city"]').off().on('click', function(){
      var cityId = $(this).data('value');
      var cityName = $(this).text();
      document.cookie = 'cityId='+cityId + ";path=/";
      document.cookie = 'cityName='+encodeURIComponent(cityName) + ";path=/";
      $('.city-name').attr('data-value', cityId);
      if(location.search.indexOf('?cityId=')<0){
        location.reload();
      } else {
        //如果url参数没有更新cityId，首页体检中心将不能正常加载
        var oldCityId = location.search.replace('?cityId=','');
        if(oldCityId!==$('.city-name').attr('data-value') && ''!==oldCityId){
          location.href = '?cityId='+$('.city-name').attr('data-value');
        } 
      }
    });
    }