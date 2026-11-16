local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local ApolloContext = require(script.ApolloContext)
local ApolloConsumer = require(script.ApolloConsumer)
local ApolloProvider = require(script.ApolloProvider)
return (Object.assign({}, ApolloContext, ApolloConsumer, ApolloProvider))
