detectr.js
==========

detectr is a small library written in CoffeeScript and usable in any JavaScript browser environment which detects the current platform, display size and orientation among other things.

By default, detectr.js checks for:
* Desktop or mobile environment
* Mac OS X, Linux or Windows on desktop platforms
* Android, iOS (iPod, iPad and iPhone), WebOS, Windows Phone 7 and Bada on mobile platforms
* Landscape or portrait display orientation
* Chrome, Firefox, Safari, IE or Opera browser

detectr does not depend on any third-party libaries, just plain old JavaScr...err...CoffeeScript :)

How to use
----------

Include __detectr.js__ in your application. Your root element (html) will now have additional like "mobile", "browser-chrome" etc.  
This is espacially useful if you need to reduce some CSS3 visual effects for mobile devices or in specific browsers.  

__Usage in JavaScript:__  
If you need to use detectr in your JavaScript code, you can do this:

	detectr.is('mobile')

This will either return true or false depending on the platform. If you want to return the string that has been written to the html element as a class, you can do the following:

	detectr.result('mobile')

If the platform is not mobile, it returns `undefined`.

Adding your own tests
---------------------

Let's add our own test to see the browser window is widescreen or not. Each test is described as an object:

```javascript
	var testDescription = {
		run: function() {
			return ((detectr.Display.width() / detectr.Display().height) > (4 / 3));
		},
		result: 'widescreen'
	}
```

The `run` property of an object will be executed once the test has been registered and it has to be a function. The return value should be a boolean, but if it's not it will be converted into one. The `result` property should be a string and will be added to the class attribute of the html element if the test has been successfully completed.

The equivalent CoffeeScript will do the same:

```coffeescript
	testDescription =
		run: -> ((detectr.Display.width() / detectr.Display().height) > (4 / 3))
		result: 'widescreen'
```

Either way, you can add the test like this:

```javascript
	detectr.add('widescreen', testDescription)
```

If you want to remove a test, use this line of code:

```javascript
	detectr.remove('widescreen')
```

If a test was removed and it has been successful previously, the class attribute of the `html` attribute will be altered as well.

All tests are cached upon first execution, they will only be executed again if the test is removed and added again.


If you need to write a test that depends on another one, you can use the `runTest` function which is only declared inside of the detectr function. It is very much recommended to use this function as it returns the cached output of a test if a test already ran.


The original test object is exposed as `detectr.defaultTests` if you feel the need to modify it at run-time.

License
-------

This software is licensed under the MIT license:

Copyright (c) 2012 Johannes Stein  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:  
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.