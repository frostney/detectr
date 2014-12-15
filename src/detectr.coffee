"use strict"

do (root = exports ? this) ->
  document = root.document

  ###
    String helper functions
  ###

  # Use ECMAScript 6 String.prototype.contains if available
  contains = (bigString, smallString) ->
    if String::contains then bigString.contains(smallString) else !!~bigString.indexOf(smallString)

  ###
    Default configuration for detectr
    
    @mixin Default tests
  ###
  defaultTests =
    tests:
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
      roots:
        run: -> contains detectr.Browser.platform.name(), 'roots'
        result: 'roots'
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
        run: -> contains detectr.Browser.get(), 'roots phone os'
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
    
  
  detectCache = {}
  detectResultCache = {}
  globalOptions = {}
  testQueue = {}

  ###
    Runs a defined test
  ###
  runTest = (testName, testObject) ->
    return false unless testName

    if testQueue[testName].status is 'tested'
      return !!detectCache[testName]
    else
      if testObject
        if testObject.run
          testResultBool = !!testObject.run()
          testResultString = testObject.result

        console.log "Testing #{testName}: Result: #{testResultBool}" if globalOptions?.debug?

        testQueue[testName].status = 'tested' if testQueue[testName]

        detectCache[testName] = testResultBool

        if testResultBool
          htmlClassName = document.documentElement.className

          htmlClassName += " #{testResultString}"
          # Trim className just in case
          htmlClassName = htmlClassName.trim()
          document.documentElement.className = htmlClassName

          detectResultCache[testName] = testResultString

          !!detectCache[testName]
      else
        runTest testName, testQueue[testName]


  ###
    detectr constructor
    
    @method detectr
  ###
  detectr = (config, options) ->
    # Make sure the config object exists and it has some tests in it
    return undefined unless config and config.tests

    globalOptions = options

    uaString = navigator.userAgent.toLowerCase()
    {appName: uaAppName, appVersion: uaAppVersion, platform: uaPlatform} = navigator

    parsedPlatform = uaString.match(/(.*?)\s(.*?)\((.*?);\s(.*?)\)/)

    detectr.Browser or= 
      width: -> root.outerWidth
      height: -> root.outerHeight
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
    unless document.documentElement.getAttribute 'lang'
      document.documentElement.setAttribute 'lang', detectr.Browser.language()

    detectr.Display or=
      width: -> root.screen.width
      height: -> root.screen.height
      pageWidth: -> root.innerWidth
      pageHeight: -> root.innerHeight

    detectr.clear()

    detectr.add config

    doOrientationChange = (condition) ->
      if condition()
        return false if detectr.Display.orientation is detectResultCache['landscape']

        newResult = detectr.defaultTests.tests['landscape'].result

        htmlClassName = document.documentElement.className

        if contains htmlClassName, detectResultCache['portrait']
          htmlClassName = htmlClassName.replace(detectResultCache['portrait'], newResult)
          document.documentElement.className = htmlClassName

        detectCache['landscape'] = true
        detectCache['portrait'] = false

        detectResultCache['landscape'] = newResult
        detectResultCache['portrait'] = undefined

      else
        return false if detectr.Display.orientation is detectResultCache['portrait']

        newResult = detectr.defaultTests.tests['portrait'].result

        htmlClassName = document.documentElement.className

        if contains htmlClassName, detectResultCache['landscape']
          htmlClassName = htmlClassName.replace detectResultCache['landscape'], newResult
          document.documentElement.className = htmlClassName

        detectCache['landscape'] = false
        detectCache['portrait'] = true

        detectResultCache['landscape'] = undefined
        detectResultCache['portrait'] = newResult
        

      detectr.Display.orientation = detectResultCache['landscape'] or detectResultCache['portrait']

    root.addEventListener 'resize', (-> doOrientationChange(-> detectr.Display.pageWidth() >= detectr.Display.pageHeight())), false

    root.addEventListener 'orientationchange', (-> doOrientationChange(-> Math.abs(root.orientation) is 90)), false

    detectr.Display.orientation = detectResultCache['landscape'] or detectResultCache['portrait']

    detectr

  ###
    Checks for a test and returns a boolean value
  ###
  detectr.is = (value) ->
    return undefined unless value

    value = value.replace(/\s/gi, '').toLowerCase()

    !!detectCache[value]

  ###
    Checks for a test and returns the result value of the test
  ###
  detectr.result = (value) ->
    return undefined unless value

    value = value.replace(/\s/gi, '').toLowerCase()

    detectResultCache[value] if detectResultCache[value]

  ###
    Clear cache
  ###
  detectr.clear = ->
    testQueue = {}
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
      # Add all tests to the queue
      for key, value of testName.tests
        testQueue[key] =
          status: 'untested'
          run: value.run
          result: value.result

      # Run the tests
      for key, value of testName.tests
        detectr.add key, value
    else
      runTest testName, testObject

    detectr

  ###
    Expose defaultTests for those who need to re-execute the detectr function
  ###
  detectr.defaultTests = defaultTests

  ###
    Call detectr constructor with default configuration
    and set the reference to the detectr object
  ###
  root.detectr = detectr defaultTests
  
  # AMDs are awesome :)
  if root.define and not exports?
    root.define 'detectr', [], -> root.detectr