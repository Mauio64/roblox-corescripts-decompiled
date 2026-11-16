local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local utilities = require(parent.utilities)
local dev = utilities.DEV
invariant2(typeof(dev) == "boolean", (tostring(dev)))

local empty = require(script.empty)
local Core = {}

Core.empty = empty.empty
local from = require(script.from)
Core.from = from.from
local split = require(script.split)
Core.split = split.split
local concat = require(script.concat)
Core.concat = concat.concat
local execute = require(script.execute)
Core.execute = execute.execute

local ApolloLink = require(script.ApolloLink)
Core.ApolloLink = ApolloLink.ApolloLink

local types = require(script.types)
Object.assign(Core, types)

return Core
