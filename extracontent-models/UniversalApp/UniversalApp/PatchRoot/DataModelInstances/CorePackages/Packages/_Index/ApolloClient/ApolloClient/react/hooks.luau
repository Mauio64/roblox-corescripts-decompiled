local Hooks = {}
local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local useApolloClient = require(script.useApolloClient)
local useQuery = require(script.useQuery)
local useLazyQuery = require(script.useLazyQuery)
local useMutation = require(script.useMutation)

local useReactiveVar = require(script.useReactiveVar)

Object.assign(Hooks, useApolloClient, useQuery, useLazyQuery, useMutation, useReactiveVar)

return Hooks
