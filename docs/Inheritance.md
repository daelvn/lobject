This wiki page covers class inheritance.
We can start by creating our base class:
```lua
local lobject = require "lobject"
local Being   = Class "Being" (function (argl)
  local object = {}
  object.age = argl.age or 0
  return object
end)
```
We start by thinking that all living beings have an age, which if it is not provided, it must be 0.
Now we will create a `Human` class that will inherit from `Being`, we will do it like this:
```lua
local Human = Class ("Human", Being) (function (argl)
  -- I haven't been able to implement multiple inheritance in the arguments
  -- Help is appreciated!
  local object = {}
  object.name = argl.name or "Unknown"
  return object
end)
```
There we go, now we have our Human class that inherits from Being. Now if we create the Human class we need to provide an age and a name, and we will be able to get those properties as well.
```lua
local daelvn = Human:new { name = "Dael", age = 14 }
print ( daelvn.name ) --> "Dael"
print ( daelvn.age  ) --> 14
```
We can also implement inheritance using the `.include` method in `lobject`. Let's declare our Human class without the direct inheritance:
```lua
local Human = Class "Human" (function (argl)
  -- I haven't been able to implement multiple inheritance in the arguments
  -- Help is appreciated!
  local object = {}
  name = argl.name or "Unknown"
  return object
end)
```
Now all we have to do is:
```lua
Human = lobject.include (Human, Being)
```
And that's all on inheritance!

[lobject](http://me.daelvn.ga/lobject) is a simple OOP library for Lua.  
Made by [daelvn](http://me.daelvn.ga).  
Using MIT/X11 license.  
