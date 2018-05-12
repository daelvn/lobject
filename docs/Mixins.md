This page covers mixins.
You can easily create a mixin using `lobject.mixin`
```lua
local lobject = require "lobject"
local MTalk   = lobject.mixin "MTalk" {
  talk = function (s) print (s) end
}
```
There's not much more, the last argument to mixin is in fact a table of functions, nothing more.
Now you can include this either with the class definition or the `.include` function.
## Using `lobject.class`
```lua
local Human = Class ("Human", MTalk) (function (argl)
  -- I haven't been able to implement multiple mixins in the arguments
  -- Help is appreciated!
  local object = {}
  object.name = argl.name or "Unknown"
  return object
end)
```
## Using `lobject.include`
```lua
local Human = Class ("Human", Being) (function (argl)
  -- I haven't been able to implement multiple mixins in the arguments
  -- Help is appreciated!
  local object = {}
  object      = lobjects.include (object, MTalk)
  object.name = argl.name or "Unknown"
  return object
end)
```
Pretty simple, huh?
You can also have a special "metamethod" on Mixin tables, they will be executed as soon as the Mixin is processed in the construction process. This key is `__mixin_init` and it must be set to a function.
```lua
local lobject = require "lobject"
local MTalk   = lobject.mixin "MTalk" {
  __mixin_init = function () print "I have been initialized!" end,
  talk = function (s) print (s) end
}
```

[lobject](http://me.daelvn.ga/lobject) is a simple OOP library for Lua.  
Made by [daelvn](http://me.daelvn.ga).  
Using MIT/X11 license.  
