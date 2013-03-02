do (detectr = @detectr) ->
  
  
  detectr.defineSuite 'browser',
    'browser-chrome':
      run: -> contains detectr.Browser.get(), 'chrome'
      result: 'browser-chrome'
    'browser-firefox':
      run: -> contains detectr.Browser.get(), 'firefox'
      result: 'browser-firefox'
    'browser-ie':
      run: -> contains detectr.Browser.get(), 'msie'
      result: 'browser-ie'
    'browser-safari':
      run: -> (contains detectr.Browser.get(), 'safari') and not (contains detectr.Browser.get(), 'chrome')
      result: 'browser-safari'
    'browser-opera':
      run: -> contains detectr.Browser.get(), 'opera'
      result: 'browser-opera'