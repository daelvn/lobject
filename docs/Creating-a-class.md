# Creating a class
This page covers the creation of classes using `lobject`.
Let's start by creating an example class:
```lua
local lobject = require "lobject"
local House   = lobject.class "House" (function (argl) return {} end)
```
We can see that several things are happening first. We have a string that marks the class name, in this case it will be `House`, then we have a function that returns an empty table. That is the constructor function.
The constructor function must always take an `argl` argument (or any other name, just that it is used as an argument list) and it must return a table, which will be the object. If you plan on writing many empty classes, you can make a shorthand like this:
```lua
local lobject = require "lobject"
local Empty   = function (argl) return {} end -- {} is the object here
local House   = lobject.class "House" (Empty)
```
Now we have a Class which can inherit other classes and implement mixins, though we won't see that for now.
We can see several properties of this class using some underscored values.
>`__type`  
This is equivalent to the name of the class, and is used with `lobject.typecheck`

>`__kind`  
This is the kind of object that lobject is creating, in this case, it's `lobject_class`. This is used for some library argument tests.

>`__construct`  
This is the function used to construct the object using `argl`. This underscored property is used by the class constructor itself, as it can inherit other classes, and it uses its constructor to do that.

>`__included`  
Hash of the classes and mixins inherited. This is just a record.


We are going to create an instance of the class now:
```lua
local instance = House:new () -- () is argl here
```
As we are not requesting any value in our House class, we don't have to pass anything. We can do several things with the instance, such as getting the type, kind and included classes/mixins. You can do this by calling the instance as a function:
```lua
instance "type"     --> "House"
instance "kind"     --> "lobject_class"
instance "included" --> {...}
```

We can now see how we can request arguments from inside a class.
```lua
local lobject = require "lobject"
local House   = lobject.class "House" (function (argl)
  -- Typechecking
  if   lobject.typecheck (argl.windows) ~= "number"
  or   lobject.typecheck (argl.rooms)   ~= "number"
  then return "Number expected, got another type." end
  local object   = {}
  object.windows = argl.windows or 4
  object.rooms   = argl.rooms or 6
  return object
end)
```
We have used `lobject`'s own typechecker to check that we are getting the types we want, then saving them as properties of the object. `lobject` will nicely error if you return a string instead of an object, so you can just return the error message and let `lobject` handle it. We have two properties, `windows` and `rooms` which have defaults of 4 or 6 respectively. We can now make an instance of the class as such:
```lua
local instance = House:new { windows = 14, rooms = 8 }
```
And we can get and set the values like this:
```lua
instance.windows --> 14
instance.windows = 12
instance.windows --> 12
```
`lobject` also allows you to pass an already created object to the `:new` method. The whole constructor function will be skipped if `obj` is specified, so only the metatable will be set.

[lobject](http://me.daelvn.ga/lobject) is a simple OOP library for Lua.  
Made by [daelvn](http://me.daelvn.ga).  
Using MIT/X11 license.  
