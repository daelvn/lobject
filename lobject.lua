-- lobject | 11.05.2018
-- By daelvn
-- Lua library for creating classes
--- Last revision: 16.07.2018

-- Namespace
local lobject = {}
-- Typecheck (Class:class)
-- Typecheck (Mixin:mixin)
-- Typecheck (Instance:object)
-- Typecheck (Any:any)
--  Typechecks a class, mixin or object
function lobject.typecheck (any)
  if     any.__type                   then return any.__type                -- Class/Mixin
  elseif type (any) ~= "table"        then return any.__call and any "type" -- Object
  else                                     return type(any)                 -- Other
  end
end

-- Merge (table:a, table:b) | b -> a
--  Merges two tables
function lobject.merge (a, b)
  for k, v in pairs (b) do a[k] = v end
  return a
end

-- Include (Class:to, Class:from)
-- Include (Class:to, Mixin:from)
-- Include (Mixin:to, Class:from)
-- Include (Mixin:to, Mixin:from)
--  Includes a class or mixin
function lobject.include (to, from)
  -- Local deepcopy
  local function copy (t, d)
    t       = t or {}
    local r = d or {}
    for k, v in pairs (t) do
      if  k ~= "__type"
      and k ~= "__kind"
      and k ~= "__mixin_init"
      and k ~= "__call"
      and k ~= "__included" then
        if   lobject.typecheck (k) == "table"
        then r[k] = copy (v)
        else r[k] = v
        end
      end
    end
    r.__included [from.__type] = from
    return r
  end
  -- Perform the copy
  if from.__included and to.__included then
    to._included = lobject.merge (to._included, from._included)
  end
  to = copy (from, to)
  return to
end

-- Class string:name (function:construct)
-- Class (string:name, [Class:inherit]) (function:construct)
-- Class (string:name, [Mixin:mixin]) (function:construct)
--  Creates a new class
function lobject.class (name, ...) return function (construct)
  -- Class internals
  local this = {}
  -- Reference self
  this.__index = this
  -- Inheriting and mixins
  this.__toInherit = {...}
  this.__included  = {}
  this.__construct = construct
  -- Set this for typechecking
  this.__kind     = "lobject_class"
  this.__type     = name
  this.__call     = function (t,v)
    if     v == "type"      then return t.__type
    elseif v == "kind"      then return t.__kind
    elseif v == "included"  then return t.__included
    end
  end
  -- Inherit classes and include mixins
  for _, any in pairs (this.__toInherit) do
    if type (any) == "table" then
      if (any.__kind == "lobject_class") or (any.__kind == "lobject_mixin") then
        if any.__mixin_init then any.__mixin_init () end
        this.__included[any.__type] = any
        this = lobject.include (this, any)
      end
    end
  end
  -- Class constructor
  function this:new (argl, obj)
    local cargl
    if not obj then
      -- Construct object using inherited classes
      cargl = construct (argl)
      if type (cargl) == "string" then error (cargl) end
      -- Iterate inherited classes, run their constructors and merge
      -- the constructed argument lists into the main one.
      for k,v in pairs (this.__included) do
        if v.__construct then
          lobject.merge (cargl, v.__construct (argl))
        end
      end
    end
    return setmetatable (obj or cargl, self)
  end
  return this
end end

-- Mixin string:name (function:functions)
--  Creates a new mixin
function lobject.mixin (name) return function (functions)
  -- Mixin internals
  local this = functions
  -- Mixin inheriting
  this.__included = {}
  -- Kinds and types
  this.__kind = "lobject_mixin"
  this.__type = name
  this.__call = function (t,v)
    if     v == "type"     then return t.__type
    elseif v == "kind"     then return t.__kind
    elseif v == "included" then return t.__included
    end
  end
  return this
end end

--# Return #--
return lobject
