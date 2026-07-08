local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local ApolloContext = require(script.ApolloContext)
local ApolloConsumer = require(script.ApolloConsumer)
local ApolloProvider = require(script.ApolloProvider)

return (Object.assign({}, ApolloContext, ApolloConsumer, ApolloProvider))
