do (detectr = @detectr) ->
  
  detectr.suite.add 'browser', ->
    # Use ECMAScript 6 String.prototype.contains if available
    contains = (bigString, smallString) ->
      if String::contains
        bigString.contains(smallString)
      else 
        !!~bigString.indexOf(smallString)
    
    @run 'browser-chrome',
      run: -> contains detectr.Browser.get(), 'chrome'
      result: 'browser-chrome'
    @run 'browser-firefox',
      run: -> contains detectr.Browser.get(), 'firefox'
      result: 'browser-firefox'
    @run 'browser-ie',
      run: -> contains detectr.Browser.get(), 'msie'
      result: 'browser-ie'
    @run 'browser-safari',
      run: -> (contains detectr.Browser.get(), 'safari') and not (contains detectr.Browser.get(), 'chrome')
      result: 'browser-safari'
    @run 'browser-opera',
      run: -> contains detectr.Browser.get(), 'opera'
      result: 'browser-opera'
      
  detectr.suite.run 'browser'
