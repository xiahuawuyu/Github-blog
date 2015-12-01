title: angular-stop-back
tags:
---

    $scope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
      //继续答题or返回？
      if ('qAnswer' === fromState.name && 'qAnswer' !== toState.name && 'qSuspend' !== toState.name && 'qResult' !== toState.name && 'topicResult' !== toState.name) {
        event.preventDefault();
        $state.go('qSuspend', {
          topicId: $scope.topicId
        });
      }
    });


    //记录跳转前的state name
    $rootScope.$on('$stateChangeSuccess',
      function (event, toState, toParams, fromState, fromParams) {
        if (toState.name !== 'qAnswer')
          window.setTimeout(function () {
            window.scrollTo(0, 0);
          }, 20);
        $wechatService.initJSSDKS(window.location.href.split('#')[0], $rootScope.$SID);
        if (fromState && fromState.name) {
          $state.fromState = fromState;
          $state.fromParams = fromParams;
        }
      });