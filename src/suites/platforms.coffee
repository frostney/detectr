do (detectr = @detectr) ->
  
  
  detectr.defineSuite 'platforms',
    desktop:
        run: -> not runTest('mobile')
        result: 'desktop'
    mobile:
      run: -> 
        # Most mobile browsers have a mobile in their user agent
        return true if contains detectr.Browser.get(), 'mobile'

        runTest('android') or runTest('ios') or runTest('bada') or runTest('webos') or runTest('wp7') or runTest('blackberry')
      result: 'mobile'
    macosx:
      run: -> (contains detectr.Browser.platform.name(), 'macosx') and not (contains detectr.Browser.platform.name(), 'likemacosx')
      result: 'macosx'
    linux:
      run: -> contains detectr.Browser.platform.name(), 'linux'
      result: 'linux'
    windows:
      run: -> contains detectr.Browser.platform.name(), 'windows'
      result: 'windows'
    android:
      run: -> contains detectr.Browser.get(), 'android'
      result: 'android'
    ios:
      run: -> contains detectr.Browser.platform.name(), 'likemacosx'
      result: 'ios'
    ipod:
      run: -> contains detectr.Browser.get(), 'ipod'
      result: 'ipod'
    iphone:
      run: -> (contains detectr.Browser.get(), 'iphone') and not runTest('ipod')
      result: 'iphone'
    ipad:
      run: -> contains detectr.Browser.get(), 'ipad'
      result: 'ipad'
    bada:
      run: -> contains detectr.Browser.get(), 'bada'
      result: 'bada'
    webos:
      run: -> contains detectr.Browser.get(), 'webos'
      result: 'webos'
    wp7:
      run: -> contains detectr.Browser.get(), 'windows phone os'
      result: 'wp7'
    blackberry:
      run: -> (contains detectr.Browser.get(), 'rim') or (contains detectr.Browser.get(), 'blackberry')
      result: 'blackberry'
    landscape:
      run: -> detectr.Display.pageWidth() >= detectr.Display.pageHeight()
      result: 'landscape'
    portrait:
      run: -> !runTest('landscape')
      result: 'portrait'