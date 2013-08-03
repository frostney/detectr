do (detectr = @detectr) ->
  
  detectr.suite.add 'platforms', ->
    # Use ECMAScript 6 String.prototype.contains if available
    contains = (bigString, smallString) ->
      if String::contains
        bigString.contains(smallString)
      else 
        !!~bigString.indexOf(smallString)
    
    runTest = @run
    
    @run 'desktop',
        run: -> not runTest('mobile')
        result: 'desktop'
    @run 'mobile',
      run: -> 
        # Most mobile browsers have a mobile in their user agent
        return true if contains detectr.Browser.get(), 'mobile'

        runTest('android') or runTest('ios') or runTest('bada') or runTest('webos') or runTest('wp7') or runTest('blackberry')
      result: 'mobile'
    @run 'macosx',
      run: -> (contains detectr.Browser.platform.name(), 'macosx') and not (contains detectr.Browser.platform.name(), 'likemacosx')
      result: 'macosx'
    @run 'linux',
      run: -> contains detectr.Browser.platform.name(), 'linux'
      result: 'linux'
    @run 'windows',
      run: -> contains detectr.Browser.platform.name(), 'windows'
      result: 'windows'
    @run 'android',
      run: -> contains detectr.Browser.get(), 'android'
      result: 'android'
    @run 'ios',
      run: -> contains detectr.Browser.platform.name(), 'likemacosx'
      result: 'ios'
    @run 'ipod',
      run: -> contains detectr.Browser.get(), 'ipod'
      result: 'ipod'
    @run 'iphone',
      run: -> (contains detectr.Browser.get(), 'iphone') and not runTest('ipod')
      result: 'iphone'
    @run 'ipad',
      run: -> contains detectr.Browser.get(), 'ipad'
      result: 'ipad'
    @run 'bada',
      run: -> contains detectr.Browser.get(), 'bada'
      result: 'bada'
    @run 'webos',
      run: -> contains detectr.Browser.get(), 'webos'
      result: 'webos'
    @run 'wp7',
      run: -> contains detectr.Browser.get(), 'windows phone os'
      result: 'wp7'
    @run 'blackberry',
      run: -> (contains detectr.Browser.get(), 'rim') or (contains detectr.Browser.get(), 'blackberry')
      result: 'blackberry'
      
  detectr.suite.run 'platforms'
