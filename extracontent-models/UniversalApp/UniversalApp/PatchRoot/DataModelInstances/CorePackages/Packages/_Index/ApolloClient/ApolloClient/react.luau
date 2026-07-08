local t1 = {}
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Object = require(scriptParentParent.LuauPolyfill).Object
local invariant = require(scriptParent.jsutils.invariant).invariant
local DEV = require(scriptParent.utilities).DEV

invariant(typeof(DEV) == "boolean", (tostring(DEV)))

local context = require(script.context)

t1.ApolloProvider = context.ApolloProvider
t1.ApolloConsumer = context.ApolloConsumer
t1.getApolloContext = context.getApolloContext
t1.resetApolloContext = context.resetApolloContext

local hooks = require(script.hooks)

Object.assign(t1, hooks)

local parser = require(script.parser)

t1.DocumentType = parser.DocumentType
t1.operationName = parser.operationName
t1.parser = parser.parser

local types = require(script.types.types)

Object.assign(t1, types)

return t1
