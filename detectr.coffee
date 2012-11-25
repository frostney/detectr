((window, document) ->
  "use strict"

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
        run: -> ~detectr.Browser.platform.name().indexOf('macosx')
        result: 'macosx'
      linux:
        run: -> ~detectr.Browser.platform.name().indexOf('linux')
        result: 'linux'
      windows:
        run: -> ~detectr.Browser.platform.name().indexOf('windows')
        result: 'windows'
      android:
        run: -> detectr.Browser.get().match(/Android/)
        result: 'android'
      ios:
        run: -> runTest('ipod') or runTest('iphone') or runTest('ipad')
        result: 'ios'
      ipod:
        run: -> detectr.Browser.get().match(/iPod/)
        result: 'ipod'
      iphone:
        run: -> detectr.Browser.get().match(/iPhone/)
        result: 'iphone'
      ipad:
        run: -> detectr.Browser.get().match(/iPad/)
        result: 'ipad'
      bada:
        run: -> detectr.Browser.get().match(/Bada/)
        result: 'bada'
      webos:
        run: -> detectr.Browser.get().match(/webOS/)
        result: 'webos'
      wp7:
        run: -> detectr.Browser.get().match(/Windows Phone OS/)
        result: 'wp7'
      blackberry:
        run: -> detectr.Browser.get().match(/RIM/) or detectr.Browser.get().match(/BlackBerry/)
        result: 'blackberry'
      landscape:
        run: -> detectr.Display.width() >= detectr.Display.height()
        result: 'landscape'
      portrait:
        run: -> !runTest('landscape')
        result: 'portrait'
      'browser-chrome':
        run: -> detectr.Browser.get().match(/Chrome/)
        result: 'browser-chrome'
      'browser-firefox':
        run: -> detectr.Browser.get().match(/Firefox/)
        result: 'browser-firefox'
      'browser-ie':
        run: -> detectr.Browser.get().match(/MSIE/)
        result: 'browser-ie'
      'browser-safari':
        run: -> detectr.Browser.get().match(/Safari/) and not detectr.Browser.get().match(/Chrome/)
        result: 'browser-safari'
      'browser-opera':
        run: -> detectr.Browser.get().match(/Opera/)
        result: 'browser-opera'
    
  
  detectCache = {}
  detectResultCache = {}
  globalOptions = {}

  ###
    Runs a defined test
  ###
  runTest = (testName, testObject) ->
    return undefined unless testName

    # Return cached result if available
    return detectCache[testName] if detectCache[testName]

    # Cached result not available, quit if there is no defined test
    return undefined unless testObject

    if testObject.run
      testResultBool = !!testObject.run() if testObject.run
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

  ###
    detectr constructor
  ###
  detectr = (config, options) ->
    # Make sure the config object exists and it has some tests in it
    return undefined unless (config and config.tests)

    globalOptions = options

    parsedPlatform = navigator.userAgent.match(/(.*?)\s(.*?)\((.*?);\s(.*?)\)/)

    detectr.Browser or= 
      get: -> navigator.userAgent
      name: -> navigator.appName
      version: -> navigator.appVersion
      platform: 
        name: -> parsedPlatform[4].replace(/\s/gi, '').toLowerCase()
        original: -> navigator.platform
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