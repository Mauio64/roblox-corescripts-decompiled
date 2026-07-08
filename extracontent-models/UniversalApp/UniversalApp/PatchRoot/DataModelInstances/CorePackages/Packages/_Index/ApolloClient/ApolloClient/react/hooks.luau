local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local useApolloClient = require(script.useApolloClient)
local useQuery = require(script.useQuery)
local useLazyQuery = require(script.useLazyQuery)
local useMutation = require(script.useMutation)
local useReactiveVar = require(script.useReactiveVar)

Object.assign(t1, useApolloClient, useQuery, useLazyQuery, useMutation, useReactiveVar)

return t1
