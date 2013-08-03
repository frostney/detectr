do (detectr = @detectr) ->
  
  detectr.suite.add 'display', ->
    runTest = @run
    
    @run 'landscape',
      run: -> detectr.Display.pageWidth() >= detectr.Display.pageHeight()
      result: 'landscape'
    @run 'portrait',
      run: -> !runTest('landscape')
      result: 'portrait'
