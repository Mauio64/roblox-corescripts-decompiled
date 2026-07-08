local t1 = {}
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Object = require(scriptParentParent.LuauPolyfill).Object
local invariant = require(scriptParent.jsutils.invariant).invariant
local DEV = require(script.Parent.utilities).DEV

invariant(typeof(DEV) == "boolean", DEV)
t1.ApolloCache = require(script.core.cache).ApolloCache
require(script.core.types.Cache)
require(script.core.types.DataProxy)
t1.MissingFieldError = require(script.core.types.common).MissingFieldError

local storeUtils = require(script.Parent.utilities.graphql.storeUtils)

t1.isReference = storeUtils.isReference
t1.makeReference = storeUtils.makeReference
t1.EntityStore = require(script.inmemory.entityStore).EntityStore
t1.fieldNameFromStoreName = require(script.inmemory.helpers).fieldNameFromStoreName
t1.InMemoryCache = require(script.inmemory.inMemoryCache).InMemoryCache

local reactiveVars = require(script.inmemory.reactiveVars)

t1.makeVar = reactiveVars.makeVar
t1.cacheSlot = reactiveVars.cacheSlot

local policies = require(script.inmemory.policies)

t1.defaultDataIdFromObject = policies.defaultDataIdFromObject
t1.Policies = policies.Policies
t1.None = policies.None
t1.canonicalStringify = require(script.inmemory["object-canon"]).canonicalStringify

local types = require(script.inmemory.types)

Object.assign(t1, types)

return t1
