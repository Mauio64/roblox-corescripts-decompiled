local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local instanceof = LuauPolyfill.instanceof
local utilities = require(parent.utilities)
local null = utilities.NULL

local Promise = require(parent2.Promise)

require(parent2.GraphQL)

local optimism = require(parent.optimism)

local wrap = optimism.wrap
local equal = require(parent.jsutils.equal)

local cache = require(script.Parent.Parent.core.cache)
local apolloCache = cache.ApolloCache

require(script.Parent.Parent.core.types.Cache)

local common = require(script.Parent.Parent.core.types.common)
local missingFieldError = common.MissingFieldError

local utilities2 = require(script.Parent.Parent.Parent.utilities)
local addTypenameToDocument = utilities2.addTypenameToDocument

local isReference = utilities2.isReference
require(script.Parent.types)

local readFromStore = require(script.Parent.readFromStore)
local storeReader = readFromStore.StoreReader

local writeToStore = require(script.Parent.writeToStore)
local storeWriter = writeToStore.StoreWriter

local entityStore = require(script.Parent.entityStore)

local entityStore_Root = entityStore.EntityStore_Root
local supportsResultCaching = entityStore.supportsResultCaching
local reactiveVars = require(script.Parent.reactiveVars)
local makeVar = reactiveVars.makeVar
local forgetCache = reactiveVars.forgetCache
local recallCache = reactiveVars.recallCache
local policies = require(script.Parent.policies)
local defaultDataIdFromObject = policies.defaultDataIdFromObject

local policies2 = policies.Policies

local helpers = require(script.Parent.helpers)
local hasOwn = helpers.hasOwn
local objectcanon = require(script.Parent["object-canon"])
local canonicalStringify = objectcanon.canonicalStringify

local v = {
	dataIdFromObject = defaultDataIdFromObject,
	addTypename = true,
	resultCaching = true,
	typePolicies = {}
}

local object = setmetatable({}, { __index = apolloCache })
object.__index = object
function object.new(p)
	local self = setmetatable(apolloCache.new(), object)
	local v2 = p == nil and {} or p

	self.watches = Set.new()

	self.typenameDocumentCache = Map.new(nil)
	self.makeVar = makeVar
	self.txCount = 0

	self.config = Object.assign({}, v, v2)

	self.addTypename = self.config.addTypename

	self.policies = policies2.new({
		cache = self,
		dataIdFromObject = self.config.dataIdFromObject,
		possibleTypes = self.config.possibleTypes,
		typePolicies = self.config.typePolicies
	})

	self:init()

	return self
end

function object:init()
	self.data = entityStore_Root.new({
		policies = self.policies,
		resultCaching = self.config.resultCaching
	})

	self.optimisticData = self.data.stump

	self:resetResultCache()
end

function object:resetResultCache(flag: boolean?)
	local storeReader2 = self.storeReader

	local new = storeReader.new
	local v2 = {
		cache = self,
		addTypename = self.addTypename,
		resultCacheMaxSize = self.config.resultCacheMaxSize,
		canon = 0
	}
	local canon

	if not (flag or not storeReader2) then
		canon = storeReader2.canon
	end

	v2.canon = canon
	self.storeReader = new(v2)

	self.storeWriter = storeWriter.new(self, self.storeReader)

	self.maybeBroadcastWatch = wrap(function(_, p, p2)
		return self:broadcastWatch(p, p2)
	end, {
		max = self.config.resultCacheMaxSize,
		makeCacheKey = function(_, data)
			local v3

			if data.optimistic then
				v3 = self.optimisticData
			else
				v3 = self.data
			end

			if not supportsResultCaching(v3) then
				return
			end

			local optimistic = data.optimistic
			local rootId = data.rootId
			local variables = data.variables
			return v3:makeCacheKey(
				data.query,
				data.callback,
				canonicalStringify({
					optimistic = optimistic,
					rootId = rootId,
					variables = variables
				})
			)
		end
	}, self)

	Set.new({ self.data.group, self.optimisticData.group }):forEach(function(object2)
		return object2:resetCaching()
	end)
end

function object:restore(p)
	self:init()

	if p then
		self.data:replace(p)
	end

	return self
end

function object:extract(flag: boolean?)
	if flag == nil then
		flag = false
	end

	if flag then
		return self.optimisticData:extract()
	end

	return self.data:extract()
end

function object.read(data, p)
	local returnPartialData

	if p.returnPartialData == nil then
		returnPartialData = false
	else
		returnPartialData = p.returnPartialData
	end

	local success, result = pcall(function()
		return data.storeReader:diffQueryAgainstStore(Object.assign({}, p, {
			store = p.optimistic and data.optimisticData or data.data,
			config = data.config,
			returnPartialData = returnPartialData
		})).result or null
	end)

	if success then
		return result
	end

	if instanceof(result, missingFieldError) then
		return null
	end

	error(result)

	return result
end

function object:write(p)
	local success, result = pcall(function()
		self.txCount += 1
		return self.storeWriter:writeToStore(self.data, p)
	end)

	self.txCount -= 1

	if self.txCount == 0 and p.broadcast ~= false then
		self:broadcastWatches()
	end

	if not success then
		error(result)
	end

	return result
end

function object:modify(data)
	if hasOwn(data, "id") and not data.id then
		return false
	end

	local v2

	if data.optimistic then
		v2 = self.optimisticData
	else
		v2 = self.data
	end

	local success, result = pcall(function()
		self.txCount += 1

		return v2:modify(data.id or "ROOT_QUERY", data.fields)
	end)

	self.txCount -= 1

	if self.txCount == 0 and data.broadcast ~= false then
		self:broadcastWatches()
	end

	if not success then
		error(result)
	end

	return result
end

function object:diff(p)
	return self.storeReader:diffQueryAgainstStore(Object.assign({}, p, {
		store = p.optimistic and self.optimisticData or self.data,
		rootId = p.id or "ROOT_QUERY",
		config = self.config
	}))
end

function object.watch(object2, p)
	if object2.watches.size == 0 then
		recallCache(object2)
	end

	object2.watches:add(p)

	if p.immediate then
		object2:maybeBroadcastWatch(p)
	end

	return function()
		if object2.watches:delete(p) and object2.watches.size == 0 then
			forgetCache(object2)
		end

		object2.maybeBroadcastWatch:forget(p)
	end
end

function object:gc(p)
	canonicalStringify:reset()
	local v2 = self.optimisticData:gc()

	if not p or self.txCount ~= 0 then
		return v2
	end

	if p.resetResultCache then
		self:resetResultCache(p.resetResultIdentities)
		return v2
	end

	if p.resetResultIdentities then
		self.storeReader:resetCanon()
	end

	return v2
end

function object:retain(p: string, flag: boolean?)
	if flag then
		return self.optimisticData:retain(p)
	end

	return self.data:retain(p)
end

function object:release(p: string, flag: boolean?)
	if flag then
		return self.optimisticData:release(p)
	end

	return self.data:release(p)
end

function object:identify(p)
	if isReference(p) then
		return p.__ref
	end

	return self.policies:identify(p)[1]
end

function object:evict(p)
	if not p.id then
		if hasOwn(p, "id") then
			return false
		end

		p = Object.assign(table.clone(p), { id = "ROOT_QUERY" })
	end

	local success, result = pcall(function()
		self.txCount += 1
		return self.optimisticData:evict(p)
	end)

	self.txCount -= 1

	if self.txCount == 0 and p.broadcast ~= false then
		self:broadcastWatches()
	end

	if not success then
		error(result)
	end

	return result
end

function object:reset()
	self:init()
	self:broadcastWatches()
	canonicalStringify:reset()
	return Promise.delay(0)
end

function object:removeOptimistic(p: string)
	local optimisticData = self.optimisticData:removeLayer(p)

	if optimisticData ~= self.optimisticData then
		self.optimisticData = optimisticData
		self:broadcastWatches()
	end
end

function object:batch(data)
	local v2 = data.optimistic == nil or data.optimistic
	local removeOptimistic = data.removeOptimistic
	local onWatchUpdated = data.onWatchUpdated

	local function perform(optimisticData)
		local data2 = self.data
		local optimisticData2 = self.optimisticData
		self.txCount += 1

		if optimisticData then
			self.optimisticData = optimisticData
			self.data = self.optimisticData
		end

		local success, result = pcall(data.update, data, self)

		self.txCount -= 1
		self.data = data2
		self.optimisticData = optimisticData2

		if not success then
			error(result)
		end
	end

	local v3 = Set.new()

	if onWatchUpdated and self.txCount == 0 then
		self:broadcastWatches(Object.assign(table.clone(data), {
			onWatchUpdated = function(_, p): boolean
				v3:add(p)
				return false
			end
		}))
	end

	if typeof(v2) == "string" then
		self.optimisticData = self.optimisticData:addLayer(v2, perform)
	elseif v2 == false then
		perform(self.data)
	else
		perform()
	end

	if typeof(removeOptimistic) == "string" then
		self.optimisticData = self.optimisticData:removeLayer(removeOptimistic)
	end

	if onWatchUpdated and v3.size > 0 then
		self:broadcastWatches(Object.assign(table.clone(data), {
			onWatchUpdated = function(p, p2, p3)
				local v4 = onWatchUpdated(p, p2, p3)

				if v4 ~= false then
					v3:delete(p2)
				end

				return v4
			end
		}))

		if v3.size > 0 then
			v3:forEach(function(p)
				return self.maybeBroadcastWatch:dirty(p)
			end)
		end
	else
		self:broadcastWatches(data)
	end
end

function object:performTransaction(callback, p)
	return self:batch({
		update = function(_, ...)
			return callback(...)
		end,
		optimistic = p or p ~= null
	})
end

function object.transformDocument(p, p2)
	if not p.addTypename then
		return p2
	end

	local v2 = p.typenameDocumentCache:get(p2)

	if not v2 then
		v2 = addTypenameToDocument(p2)
		p.typenameDocumentCache:set(p2, v2)

		p.typenameDocumentCache:set(v2, v2)
	end

	return v2
end

function object:broadcastWatches(p)
	if self.txCount == 0 then
		self.watches:forEach(function(p2)
			return self:maybeBroadcastWatch(p2, p)
		end)
	end
end

function object:broadcastWatch(object2, p)
	local lastDiff = object2.lastDiff
	local diff = self:diff({
		query = object2.query,
		variables = object2.variables,
		optimistic = object2.optimistic
	})

	if p then
		if object2.optimistic and typeof(p.optimistic) == "string" then
			diff.fromOptimisticTransaction = true
		end

		local onWatchUpdated = p.onWatchUpdated

		if onWatchUpdated and onWatchUpdated(self, object2, diff, lastDiff) == false then
			return
		end
	end

	if not (lastDiff and equal(lastDiff.result, diff.result)) then
		object2.lastDiff = diff
		object2:callback(object2.lastDiff, lastDiff)
	end
end

return { InMemoryCache = object }
