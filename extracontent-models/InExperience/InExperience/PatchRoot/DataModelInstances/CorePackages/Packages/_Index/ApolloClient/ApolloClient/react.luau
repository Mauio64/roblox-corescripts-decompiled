local parent = script.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local utilities = require(parent.utilities)
local dev = utilities.DEV
invariant2(typeof(dev) == "boolean", (tostring(dev)))

local context = require(script.context)
local React = {}

React.ApolloProvider = context.ApolloProvider
React.ApolloConsumer = context.ApolloConsumer
React.getApolloContext = context.getApolloContext
React.resetApolloContext = context.resetApolloContext

local hooks = require(script.hooks)
Object.assign(React, hooks)

local parser = require(script.parser)

React.DocumentType = parser.DocumentType
React.operationName = parser.operationName
React.parser = parser.parser

local types = require(script.types.types)
Object.assign(React, types)

return React
