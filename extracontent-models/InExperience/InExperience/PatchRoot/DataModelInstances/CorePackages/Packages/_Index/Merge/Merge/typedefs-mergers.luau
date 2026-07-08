local ParentParent = script.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local t1 = {}
local arguments = require(script.arguments)

Object.assign(t1, arguments)

local directives = require(script.directives)

Object.assign(t1, directives)

local lib = require(script["enum-values"])

Object.assign(t1, lib)

local enum = require(script.enum)

Object.assign(t1, enum)

local fields = require(script.fields)

Object.assign(t1, fields)

local lib2 = require(script["input-type"])

Object.assign(t1, lib2)

local interface = require(script.interface)

Object.assign(t1, interface)

local lib3 = require(script["merge-named-type-array"])

Object.assign(t1, lib3)

local lib4 = require(script["merge-nodes"])

Object.assign(t1, lib4)

local lib5 = require(script["merge-typedefs"])

Object.assign(t1, lib5)

local scalar = require(script.scalar)

Object.assign(t1, scalar)

local type = require(script.type)

Object.assign(t1, type)

local union = require(script.union)

Object.assign(t1, union)

local utils = require(script.utils)

Object.assign(t1, utils)

return t1
