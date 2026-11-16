local ApolloClient = {}
local parent = script.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local core = require(script.core)
Object.assign(ApolloClient, core)
ApolloClient.None = core.None

local react = require(script.react)
Object.assign(ApolloClient, react)

return ApolloClient
