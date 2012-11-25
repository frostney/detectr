((window, document) ->
  "use strict"

  ###
    String helper functions
  ###

  # Use ECMAScript 6 String.prototype.contains if available
  contains = (bigString, smallString) ->
    if String::contains then bigString.contains(smallString) else !!~bigString.indexOf(smallString)

  ###
    Default configuration for detectr
  ###
  defaultTests =
    tests:
      desktop:
        run: -> not runTest('mobile')
        result: 'desktop'
      mobile:
        run: -> runTest('android') or runTest('ios') or runTest('bada') or runTest('webos') or runTest('wp7') or runTest('blackberry')
        result: 'mobile'
      macosx:
        run: -> contains detectr.Browser.platform.name(), 'macosx'
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
        run: -> runTest('ipod') or runTest('iphone') or runTest('ipad')
        result: 'ios'
      ipod:
        run: -> contains detectr.Browser.get(), 'ipod'
        result: 'ipod'
      iphone:
        run: -> contains detectr.Browser.get(), 'iphone'
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
        run: -> detectr.Display.width() >= detectr.Display.height()
        result: 'landscape'
      portrait:
        run: -> !runTest('landscape')
        result: 'portrait'
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
        run: -> contains detectr.Browser.get(), 'safari' and not contains detectr.Browser.get(), 'chrome'
        result: 'browser-safari'
      'browser-opera':
        run: -> contains detectr.Browser.get(), 'opera'
        result: 'browser-opera'
    
  
  detectCache = {}
  detectResultCache = {}
  globalOptions = {}

  ###
    Runs a defined test
  ###
  runTest = (testName, testObject) ->
    return undefined unless testName

    if testObject
      if testObject.run
        testResultBool = !!testObject.run()
        testResultString = testObject.result

      console.log "Testing #{testName}: Result: #{testResultBool}" if globalOptions?.debug?

      detectCache[testName] = testResultBool

      if testResultBool
        htmlClassName = document.documentElement.className

        htmlClassName += " " + testResultString
        # Trim className just in case
        htmlClassName = htmlClassName.trim()
        document.documentElement.className = htmlClassName

        detectResultCache[testName] = testResultString 

    detectCache[testName]


  ###
    detectr constructor
  ###
  detectr = (config, options) ->
    # Make sure the config object exists and it has some tests in it
    return undefined unless (config and config.tests)

    globalOptions = options

    uaString = navigator.userAgent.toLowerCase()
    uaAppName = navigator.appName
    uaAppVersion = navigator.appVersion
    uaPlatform = navigator.platform

    parsedPlatform = uaString.match(/(.*?)\s(.*?)\((.*?);\s(.*?)\)/)

    detectr.Browser or= 
      get: -> uaString
      name: -> uaAppName
      version: -> uaAppVersion
      platform: 
        name: -> parsedPlatform[4].replace(/\s/gi, '').toLowerCase()
        original: -> uaPlatform
      language: ->
        language = navigator.language or navigator.systemLanguage
        language.split('-')[0] if language?

    # Sets language attribute to browser language by default
    document.documentElement.setAttribute('lang', detectr.Browser.language())

    detectr.Display or=
      width: -> window.innerWidth
      height: -> window.innerHeight

    detectr.clear()

    for key, value of config.tests
      detectr.add key, value

    detectr.Display.orientation = detectResultCache['landscape'] or detectResultCache['portrait']

    detectr

  ###
    Checks for a test and returns a boolean value
  ###
  detectr.is = (value) ->
    return undefined unless value

    value = value.replace(/\s/gi, '').toLowerCase()

    result = detectCache[value] if detectCache[value]

  ###
    Checks for a test and returns the result value of the test
  ###
  detectr.result = (value) ->
    return undefined unless value

    value = value.replace(/\s/gi, '').toLowerCase()

    result = detectResultCache[value] if detectResultCache[value]

  ###
    Clear cache
  ###
  detectr.clear = ->
    detectCache = {}
    for key, value of detectResultCache
      htmlClassName = document.documentElement.className

      htmlClassName = htmlClassName.replace(value, '').trim()
      document.documentElement.className = htmlClassName
    detectResultCache = {}

    detectr

  ###
    Remove a test
  ###
  detectr.remove = (testName) ->
    delete detectCache[testName] if detectCache[testName]
    if detectResultCache[testName]
      htmlClassName = document.documentElement.className

      htmlClassName = htmlClassName.replace(detectResultCache[testName], '').replace(/^\s+|\s+$/g,'').replace(/\s+/g,' ')
      document.documentElement.className = htmlClassName
      delete detectResultCache[testName]

    detectr

  ###
    Add a test
  ###
  detectr.add = (testName, testObject) ->
    # If it is a single test, run it directly, else iterate over it
    if testName.tests
      for key, value of testName
        detectr.add key, value
    else
      runTest testName, testObject

    detectr

  ###
    Expose defaultTests for those who need re-execute the detectr function
  ###
  detectr.defaultTests = defaultTests

  ###
    Call detectr constructor with default configuration
    and set the reference to the detectr object
  ###
  window.detectr = detectr defaultTests

)(@, document)