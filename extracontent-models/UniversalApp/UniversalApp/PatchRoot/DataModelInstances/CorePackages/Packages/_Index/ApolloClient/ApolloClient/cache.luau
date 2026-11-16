local parent = script.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local utilities = require(script.Parent.utilities)
local dev = utilities.DEV
invariant2(typeof(dev) == "boolean", dev)
local cache = require(script.core.cache)
local Cache = {}

Cache.ApolloCache = cache.ApolloCache

require(script.core.types.Cache)

require(script.core.types.DataProxy)

local common = require(script.core.types.common)
Cache.MissingFieldError = common.MissingFieldError

local storeUtils = require(script.Parent.utilities.graphql.storeUtils)

Cache.isReference = storeUtils.isReference
Cache.makeReference = storeUtils.makeReference

local entityStore = require(script.inmemory.entityStore)

Cache.EntityStore = entityStore.EntityStore
local helpers = require(script.inmemory.helpers)
Cache.fieldNameFromStoreName = helpers.fieldNameFromStoreName

local inMemoryCache = require(script.inmemory.inMemoryCache)

Cache.InMemoryCache = inMemoryCache.InMemoryCache

local reactiveVars = require(script.inmemory.reactiveVars)

Cache.makeVar = reactiveVars.makeVar
Cache.cacheSlot = reactiveVars.cacheSlot

local policies = require(script.inmemory.policies)
Cache.defaultDataIdFromObject = policies.defaultDataIdFromObject

Cache.Policies = policies.Policies

Cache.None = policies.None

local objectcanon = require(script.inmemory["object-canon"])
Cache.canonicalStringify = objectcanon.canonicalStringify

local types = require(script.inmemory.types)
Object.assign(Cache, types)

return Cache
