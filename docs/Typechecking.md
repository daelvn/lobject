`lobject` provides a `.typechecker` function that can check the usual Lua types, plus the types of Classes, Mixins and Instances. It is used exactly as you would use Lua's builtin `type`.
```lua
local lobject = require "lobject"
local str     = ""
local t       = lobject.typechecker (str)
```