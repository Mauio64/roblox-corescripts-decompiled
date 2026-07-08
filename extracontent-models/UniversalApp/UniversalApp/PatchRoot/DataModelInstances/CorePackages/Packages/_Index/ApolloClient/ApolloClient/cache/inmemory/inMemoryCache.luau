local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local instanceof = LuauPolyfill.instanceof
local NULL = require(ParentParent.utilities).NULL
local Promise = require(ParentParentParent.Promise)
local t1 = {}

require(ParentParentParent.GraphQL)

local wrap = require(ParentParent.optimism).wrap
local equal = require(ParentParent.jsutils.equal)
local ApolloCache = require(script.Parent.Parent.core.cache).ApolloCache

require(script.Parent.Parent.core.types.Cache)

local MissingFieldError = require(script.Parent.Parent.core.types.common).MissingFieldError
local utilities = require(script.Parent.Parent.Parent.utilities)
local addTypenameToDocument = utilities.addTypenameToDocument
local isReference = utilities.isReference

require(script.Parent.types)

local StoreReader = require(script.Parent.readFromStore).StoreReader
local StoreWriter = require(script.Parent.writeToStore).StoreWriter
local entityStore = require(script.Parent.entityStore)
local EntityStore_Root = entityStore.EntityStore_Root
local supportsResultCaching = entityStore.supportsResultCaching
local reactiveVars = require(script.Parent.reactiveVars)
local makeVar = reactiveVars.makeVar
local forgetCache = reactiveVars.forgetCache
local recallCache = reactiveVars.recallCache
local policies = require(script.Parent.policies)
local defaultDataIdFromObject = policies.defaultDataIdFromObject
local Policies = policies.Policies
local hasOwn = require(script.Parent.helpers).hasOwn
local canonicalStringify = require(script.Parent["object-canon"]).canonicalStringify
local t2 = {
	addTypename = true,
	resultCaching = true,
	dataIdFromObject = defaultDataIdFromObject,
	typePolicies = {}
}
local self = setmetatable({}, {
	__index = ApolloCache
})

self.__index = self

function self.new(p1) -- line: 199
	-- upvalues: ApolloCache (copy), self (copy), Set (copy), Map (copy), makeVar (copy), Object (copy), t2 (copy), Policies (copy)
	local v35 = setmetatable(ApolloCache.new(), self)

	if p1 == nil then
		p1 = {}
	end

	v35.watches = Set.new()
	v35.typenameDocumentCache = Map.new(nil)
	v35.makeVar = makeVar
	v35.txCount = 0
	v35.config = Object.assign({}, t2, p1)
	v35.addTypename = v35.config.addTypename
	v35.policies = Policies.new({
		cache = v35,
		dataIdFromObject = v35.config.dataIdFromObject,
		possibleTypes = v35.config.possibleTypes,
		typePolicies = v35.config.typePolicies
	})
	v35:init()

	return v35
end
function self.init(p2) -- line: 227
	-- upvalues: EntityStore_Root (copy)
	p2.data = EntityStore_Root.new({
		policies = p2.policies,
		resultCaching = p2.config.resultCaching
	})
	p2.optimisticData = p2.data.stump
	p2:resetResultCache()
end
function self.resetResultCache(t3: {[any]: any}, b1: boolean?) -- line: 247
	-- upvalues: StoreReader (copy), StoreWriter (copy), wrap (copy), supportsResultCaching (copy), canonicalStringify (copy), Set (copy)
	local storeReader = t3.storeReader

	t3.storeReader = StoreReader.new({
		cache = t3,
		addTypename = t3.addTypename,
		resultCacheMaxSize = t3.config.resultCacheMaxSize,
		canon = if not b1 then if not storeReader then nil else storeReader.canon else nil
	})
	t3.storeWriter = StoreWriter.new(t3, t3.storeReader)
	t3.maybeBroadcastWatch = wrap(function(_, p4, p5) -- line: 264
		-- upvalues: t3 (ref)
		return t3:broadcastWatch(p4, p5)
	end, {
		max = t3.config.resultCacheMaxSize,
		makeCacheKey = function(_, p7) -- line: 268
			-- upvalues: t3 (ref), supportsResultCaching (copy), canonicalStringify (copy)
			local v114 = if not p7.optimistic then t3.data else t3.optimisticData

			if supportsResultCaching(v114) then
				local optimistic = p7.optimistic
				local rootId = p7.rootId
				local variables = p7.variables

				return v114:makeCacheKey(p7.query, p7.callback, canonicalStringify({
					optimistic = optimistic,
					rootId = rootId,
					variables = variables
				}))
			end
		end
	}, t3)
	Set.new({
		t3.data.group,
		t3.optimisticData.group
	}):forEach(function(p8) -- line: 304
		return p8:resetCaching()
	end)
end
function self.restore(p9, p10) -- line: 309
	p9:init()

	if p10 then
		p9.data:replace(p10)
	end

	return p9
end
function self.extract(t4: {[any]: any}, b2: boolean?) -- line: 322
	if b2 == nil then
		b2 = false
	end

	if b2 then
		return t4.optimisticData:extract()
	end

	return t4.data:extract()
end
function self.read(p11, p12) -- line: 334
	-- upvalues: Object (copy), NULL (copy), instanceof (copy), MissingFieldError (copy)
	local u47 = p12.returnPartialData ~= nil and p12.returnPartialData
	local ok, result = pcall(function() -- line: 349
		-- upvalues: p11 (copy), Object (copy), p12 (copy), u47 (ref), NULL (copy)
		return p11.storeReader:diffQueryAgainstStore(Object.assign({}, p12, {
			store = p12.optimistic and p11.optimisticData or p11.data,
			config = p11.config,
			returnPartialData = u47
		})).result or NULL
	end)

	if not ok then
		if instanceof(result, MissingFieldError) then
			return NULL
		end

		error(result)
	end

	return result
end
function self.write(p13, p14) -- line: 374
	local ok, result = pcall(function() -- line: 376
		-- upvalues: p13 (ref), p14 (copy)
		local v119 = p13

		v119.txCount = v119.txCount + 1

		return p13.storeWriter:writeToStore(p13.data, p14)
	end)

	p13.txCount = p13.txCount - 1

	if p13.txCount == 0 and p14.broadcast ~= false then
		p13:broadcastWatches()
	end

	if not ok then
		error(result)
	end

	return result
end
function self.modify(p15, p16) -- line: 394
	-- upvalues: hasOwn (copy)
	if hasOwn(p16, "id") and not p16.id then
		return false
	end

	local u58 = if not p16.optimistic then p15.data else p15.optimisticData
	local ok, result = pcall(function() -- line: 419
		-- upvalues: p15 (ref), u58 (ref), p16 (copy)
		local v120 = p15

		v120.txCount = v120.txCount + 1

		return u58:modify(p16.id or "ROOT_QUERY", p16.fields)
	end)

	p15.txCount = p15.txCount - 1

	if p15.txCount == 0 and p16.broadcast ~= false then
		p15:broadcastWatches()
	end

	if not ok then
		error(result)
	end

	return result
end
function self.diff(p17, p18) -- line: 439
	-- upvalues: Object (copy)
	return p17.storeReader:diffQueryAgainstStore(Object.assign({}, p18, {
		store = p18.optimistic and p17.optimisticData or p17.data,
		rootId = p18.id or "ROOT_QUERY",
		config = p17.config
	}))
end
function self.watch(p19, p20) -- line: 449
	-- upvalues: recallCache (copy), forgetCache (copy)
	if p19.watches.size == 0 then
		recallCache(p19)
	end

	p19.watches:add(p20)

	if p20.immediate then
		p19:maybeBroadcastWatch(p20)
	end

	return function() -- line: 470
		-- upvalues: p19 (ref), p20 (copy), forgetCache (copy)
		if p19.watches:delete(p20) and p19.watches.size == 0 then
			forgetCache(p19)
		end

		p19.maybeBroadcastWatch:forget(p20)
	end
end
function self.gc(t5: {[any]: any}, t6: {[any]: any}?) -- line: 486
	-- upvalues: canonicalStringify (copy)
	canonicalStringify:reset()

	local v68 = t5.optimisticData:gc()

	if t6 and t5.txCount == 0 then
		if t6.resetResultCache then
			t5:resetResultCache(t6.resetResultIdentities)

			return v68
		end

		if t6.resetResultIdentities then
			t5.storeReader:resetCanon()
		end
	end

	return v68
end
function self.retain(t7: {[any]: any}, s1: string, b3: boolean?) -- line: 518
	if b3 then
		return t7.optimisticData:retain(s1)
	end

	return t7.data:retain(s1)
end
function self.release(t8: {[any]: any}, s2: string, b4: boolean?) -- line: 533
	if b4 then
		return t8.optimisticData:release(s2)
	end

	return t8.data:release(s2)
end
function self.identify(p21, p22) -- line: 549
	-- upvalues: isReference (copy)
	if isReference(p22) then
		return p22.__ref
	end

	return p21.policies:identify(p22)[1]
end
function self.evict(p23, p24) -- line: 557
	-- upvalues: hasOwn (copy), Object (copy)
	if not p24.id then
		if hasOwn(p24, "id") then
			return false
		end

		p24 = Object.assign(table.clone(p24), {
			id = "ROOT_QUERY"
		})
	end

	local ok, result = pcall(function() -- line: 572
		-- upvalues: p23 (ref), p24 (ref)
		local v121 = p23

		v121.txCount = v121.txCount + 1

		return p23.optimisticData:evict(p24)
	end)

	p23.txCount = p23.txCount - 1

	if p23.txCount == 0 and p24.broadcast ~= false then
		p23:broadcastWatches()
	end

	if not ok then
		error(result)
	end

	return result
end
function self.reset(p25) -- line: 594
	-- upvalues: canonicalStringify (copy), Promise (copy)
	p25:init()
	p25:broadcastWatches()
	canonicalStringify:reset()

	return Promise.delay(0)
end
function self.removeOptimistic(t9: {[any]: any}, s3: string) -- line: 601
	local v86 = t9.optimisticData:removeLayer(s3)

	if v86 ~= t9.optimisticData then
		t9.optimisticData = v86
		t9:broadcastWatches()
	end
end
function self.batch(p26, p27) -- line: 609
	-- upvalues: Set (copy), Object (copy)
	local v90 = p27.optimistic == nil or p27.optimistic
	local removeOptimistic = p27.removeOptimistic
	local onWatchUpdated = p27.onWatchUpdated

	local function perform(p28) -- line: 614
		-- upvalues: p26 (ref), p27 (copy)
		local data = p26.data
		local optimisticData = p26.optimisticData
		local v125 = p26

		v125.txCount = v125.txCount + 1

		if p28 then
			p26.optimisticData = p28
			p26.data = p26.optimisticData
		end

		local ok, result = pcall(p27.update, p27, p26)
		local v128 = p26

		v128.txCount = v128.txCount - 1
		p26.data = data
		p26.optimisticData = optimisticData

		if not ok then
			error(result)
		end
	end

	local v94 = Set.new()

	if onWatchUpdated and p26.txCount == 0 then
		p26:broadcastWatches(Object.assign(table.clone(p27), {
			onWatchUpdated = function(_, p30) -- line: 651
				-- upvalues: v94 (copy)
				v94:add(p30)

				return false
			end
		}))
	end

	if typeof(v90) == "string" then
		p26.optimisticData = p26.optimisticData:addLayer(v90, perform)
	elseif v90 == false then
		perform(p26.data)
	else
		perform()
	end

	if typeof(removeOptimistic) == "string" then
		p26.optimisticData = p26.optimisticData:removeLayer(removeOptimistic)
	end

	if onWatchUpdated and v94.size > 0 then
		p26:broadcastWatches(Object.assign(table.clone(p27), {
			onWatchUpdated = function(p31, p32, p33) -- line: 687
				-- upvalues: onWatchUpdated (copy), v94 (copy)
				local v134 = onWatchUpdated(p31, p32, p33)

				if v134 ~= false then
					v94:delete(p32)
				end

				return v134
			end
		}))

		if v94.size > 0 then
			v94:forEach(function(p34) -- line: 703
				-- upvalues: p26 (ref)
				return p26.maybeBroadcastWatch:dirty(p34)
			end)
		end
	else
		p26:broadcastWatches(p27)
	end
end
function self.performTransaction(t10: {[any]: any}, p35: ((...any) -> ...any), p36) -- line: 724
	-- upvalues: NULL (copy)
	return t10:batch({
		update = function(_, ...) -- line: 727
			-- upvalues: p35 (copy)
			return p35(...)
		end,
		optimistic = p36 or p36 ~= NULL
	})
end
function self.transformDocument(p38, p39) -- line: 736
	-- upvalues: addTypenameToDocument (copy)
	if p38.addTypename then
		local v100 = p38.typenameDocumentCache:get(p39)

		if not v100 then
			v100 = addTypenameToDocument(p39)
			p38.typenameDocumentCache:set(p39, v100)
			p38.typenameDocumentCache:set(v100, v100)
		end

		return v100
	end

	return p39
end
function self.broadcastWatches(p40, p41) -- line: 752
	if p40.txCount == 0 then
		p40.watches:forEach(function(p42) -- line: 755
			-- upvalues: p40 (copy), p41 (copy)
			return p40:maybeBroadcastWatch(p42, p41)
		end)
	end
end
function self.broadcastWatch(p43, p44, p45) -- line: 767
	-- upvalues: equal (copy)
	local lastDiff = p44.lastDiff
	local v107 = p43:diff({
		query = p44.query,
		variables = p44.variables,
		optimistic = p44.optimistic
	})

	if p45 then
		if p44.optimistic and typeof(p45.optimistic) == "string" then
			v107.fromOptimisticTransaction = true
		end

		local onWatchUpdated = p45.onWatchUpdated

		if onWatchUpdated and onWatchUpdated(p43, p44, v107, lastDiff) == false then
			return
		end
	end

	if not lastDiff or not equal(lastDiff.result, v107.result) then
		p44.lastDiff = v107
		p44:callback(p44.lastDiff, lastDiff)
	end
end

t1.InMemoryCache = self

return t1
