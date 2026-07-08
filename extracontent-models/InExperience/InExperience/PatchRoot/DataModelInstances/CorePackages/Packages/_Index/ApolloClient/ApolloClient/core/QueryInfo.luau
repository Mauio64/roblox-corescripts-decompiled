local t1 = {}
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local clearTimeout = LuauPolyfill.clearTimeout
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local setTimeout = LuauPolyfill.setTimeout
local WeakMap = LuauPolyfill.WeakMap

require(ParentParentParent.GraphQL)

local equal = require(ParentParent.jsutils.equal)

require(ParentParent.cache)
require(script.Parent.watchQueryOptions_types)
require(script.Parent.ObservableQuery_types)
require(script.Parent.Parent.link.core)

local utilities = require(script.Parent.Parent.utilities)
local isNonEmptyArray = utilities.isNonEmptyArray
local graphQLResultHasError = utilities.graphQLResultHasError
local canUseWeakMap = utilities.canUseWeakMap
local networkStatus = require(script.Parent.networkStatus)
local NetworkStatus = networkStatus.NetworkStatus
local isNetworkRequestInFlight = networkStatus.isNetworkRequestInFlight

require(script.Parent.Parent.errors)

local t2 = {
	FORBID = 0,
	OVERWRITE = 1,
	MERGE = 2
}

t1.CacheWriteBehavior = t2

local v21 = if not canUseWeakMap then Map.new(nil) else WeakMap.new()

local function wrapDestructiveCacheMethod(p1, s1: string) -- line: 98
	-- upvalues: v21 (copy)
	local v28 = p1[s1]

	if typeof(v28) == "function" then
		p1[s1] = function(...) -- line: 105
			-- upvalues: v21 (copy), p1 (copy), v28 (copy)
			v21:set(p1, (v21:get(p1) + 1) % 1000000000000000)

			return v28(...)
		end
	end
end
local function cancelNotifyTimeout(t3: {[any]: any}) -- line: 119
	-- upvalues: Boolean (copy), clearTimeout (copy)
	if Boolean.toJSBoolean(t3.notifyTimeout) then
		clearTimeout(t3.notifyTimeout)
		t3.notifyTimeout = nil
	end
end

local t4 = {}

t4.__index = t4

function t4.new(p2) -- line: 204
	-- upvalues: Set (copy), v21 (copy), t4 (copy)
	local t5 = {
		listeners = Set.new(),
		document = nil,
		lastRequestId = 1,
		subscriptions = Set.new(),
		stopped = false,
		cache = p2,
		dirty = false,
		observableQuery = nil
	}

	if not v21:has(p2) then
		v21:set(p2, 0)

		local evict = p2.evict

		if typeof(evict) == "function" then
			function p2.evict(...) -- line: 105
				-- upvalues: v21 (copy), p2 (copy), evict (copy)
				v21:set(p2, (v21:get(p2) + 1) % 1000000000000000)

				return evict(...)
			end
		end

		local modify = p2.modify

		if typeof(modify) == "function" then
			function p2.modify(...) -- line: 105
				-- upvalues: v21 (copy), p2 (copy), modify (copy)
				v21:set(p2, (v21:get(p2) + 1) % 1000000000000000)

				return modify(...)
			end
		end

		local reset = p2.reset

		if typeof(reset) == "function" then
			function p2.reset(...) -- line: 105
				-- upvalues: v21 (copy), p2 (copy), reset (copy)
				v21:set(p2, (v21:get(p2) + 1) % 1000000000000000)

				return reset(...)
			end
		end
	end

	return (setmetatable(t5, t4))
end
function t4.init(t6: {[any]: any}, t7: {[any]: any}) -- line: 230
	-- upvalues: Boolean (copy), NetworkStatus (copy), equal (copy), Object (copy)
	local v37 = Boolean.toJSBoolean(t7.networkStatus) and t7.networkStatus or NetworkStatus.loading

	if Boolean.toJSBoolean(t6.variables) and (t6.networkStatus ~= NetworkStatus.loading and not equal(t6.variables, t7.variables)) then
		v37 = NetworkStatus.setVariables
	end

	if not equal(t7.variables, t6.variables) then
		t6.lastDiff = nil
	end

	Object.assign(t6, {
		document = t7.document,
		variables = t7.variables,
		networkError = Object.None,
		graphQLErrors = Boolean.toJSBoolean(t6.graphQLErrors) and t6.graphQLErrors or {},
		networkStatus = v37
	})

	if Boolean.toJSBoolean(t7.observableQuery) then
		t6:setObservableQuery(t7.observableQuery)
	end

	if Boolean.toJSBoolean(t7.lastRequestId) then
		t6.lastRequestId = t7.lastRequestId
	end

	return t6
end
function t4.reset(p3) -- line: 271
	-- upvalues: Boolean (copy), clearTimeout (copy)
	if Boolean.toJSBoolean(p3.notifyTimeout) then
		clearTimeout(p3.notifyTimeout)
		p3.notifyTimeout = nil
	end

	p3.lastDiff = nil
	p3.dirty = false
end
function t4.getDiff(p4, p5) -- line: 277
	-- upvalues: Boolean (copy), equal (copy)
	if p5 == nil then
		p5 = p4.variables
	end

	local v41 = p4:getDiffOptions(p5)

	if Boolean.toJSBoolean(p4.lastDiff) and equal(v41, p4.lastDiff.options) then
		return p4.lastDiff.diff
	end

	p4.variables = p5
	p4:updateWatch(p4.variables)

	local observableQuery = p4.observableQuery

	if Boolean.toJSBoolean(observableQuery) and observableQuery.options.fetchPolicy == "no-cache" then
		return {
			complete = false
		}
	end

	local v43 = p4.cache:diff(v41)

	p4:updateLastDiff(v43, v41)

	return v43
end
function t4.updateLastDiff(p6, p7, p8) -- line: 302
	-- upvalues: Boolean (copy)
	p6.lastDiff = Boolean.toJSBoolean(p7) and {
		diff = p7,
		options = Boolean.toJSBoolean(p8) and p8 or p6:getDiffOptions()
	} or nil
end
function t4.getDiffOptions(p9, p10) -- line: 311
	-- upvalues: Boolean (copy)
	if p10 == nil then
		p10 = p9.variables
	end

	local observableQuery = p9.observableQuery

	return {
		returnPartialData = true,
		optimistic = true,
		query = p9.document,
		variables = p10,
		canonizeResults = not Boolean.toJSBoolean(observableQuery) or observableQuery.options.canonizeResults ~= false
	}
end
function t4.setDiff(p11, p12) -- line: 327
	-- upvalues: Boolean (copy), equal (copy), setTimeout (copy)
	local v52 = if not Boolean.toJSBoolean(p11.lastDiff) then p11.lastDiff else p11.lastDiff.diff

	p11:updateLastDiff(p12)

	local v53 = if not Boolean.toJSBoolean(v52) then v52 else v52.result
	local v54 = if not Boolean.toJSBoolean(p12) then p12 else p12.result

	if not p11.dirty and not equal(v53, v54) then
		p11.dirty = true

		if not Boolean.toJSBoolean(p11.notifyTimeout) then
			p11.notifyTimeout = setTimeout(function() -- line: 352
				-- upvalues: p11 (copy)
				return p11:notify()
			end, 0)
		end
	end
end
function t4.setObservableQuery(p13, p14) -- line: 359
	-- upvalues: Boolean (copy)
	if p14 == p13.observableQuery then
		return
	end

	if Boolean.toJSBoolean(p13.oqListener) then
		p13.listeners:delete(p13.oqListener)
	end

	p13.observableQuery = p14

	if Boolean.toJSBoolean(p14) and p14 ~= nil then
		p14.queryInfo = p13

		function p13.oqListener() -- line: 373
			-- upvalues: Boolean (copy), p13 (copy), p14 (copy)
			if Boolean.toJSBoolean(p13:getDiff().fromOptimisticTransaction) then
				p14.observe(p14)

				return
			end

			p14:reobserve()
		end

		p13.listeners:add(p13.oqListener)

		return
	end

	p13.oqListener = nil
end
function t4.notify(p15) -- line: 391
	-- upvalues: Boolean (copy), clearTimeout (copy)
	if Boolean.toJSBoolean(p15.notifyTimeout) then
		clearTimeout(p15.notifyTimeout)
		p15.notifyTimeout = nil
	end

	if p15:shouldNotify() then
		p15.listeners:forEach(function(p16) -- line: 395
			-- upvalues: p15 (copy)
			return p16(p15)
		end)
	end

	p15.dirty = false
end
function t4.shouldNotify(p17) -- line: 402
	-- upvalues: Boolean (copy), isNetworkRequestInFlight (copy)
	if not p17.dirty or not Boolean.toJSBoolean(p17.listeners.size) then
		return false
	end

	if isNetworkRequestInFlight(p17.networkStatus) and Boolean.toJSBoolean(p17.observableQuery) then
		local fetchPolicy = p17.observableQuery.options.fetchPolicy

		if fetchPolicy ~= "cache-only" and fetchPolicy ~= "cache-and-network" then
			return false
		end
	end

	return true
end
function t4.stop(p18) -- line: 416
	-- upvalues: t4 (copy), Boolean (copy)
	if not p18.stopped then
		p18.stopped = true
		p18:reset()
		p18:cancel()
		p18.cancel = t4.cancel
		p18.subscriptions:forEach(function(p19) -- line: 426
			return p19:unsubscribe()
		end)

		local observableQuery = p18.observableQuery

		if Boolean.toJSBoolean(observableQuery) then
			observableQuery:stopPolling()
		end
	end
end
function t4.cancel(_) -- line: 440
end
function t4.updateWatch(p21, p22) -- line: 442
	-- upvalues: Boolean (copy), Object (copy), equal (copy)
	if p22 == nil then
		p22 = p21.variables
	end

	local observableQuery = p21.observableQuery

	if Boolean.toJSBoolean(observableQuery) and observableQuery.options.fetchPolicy == "no-cache" then
		return
	end

	local v66 = Object.assign({}, p21:getDiffOptions(p22), {
		watcher = p21,
		callback = function(_, p24) -- line: 461
			-- upvalues: p21 (copy)
			return p21:setDiff(p24)
		end
	})
	local v67 = Object.assign({}, v66, {
		callback = Object.None
	})
	local v68 = Object.assign({}, p21.lastWatch, {
		callback = Object.None
	})

	if not Boolean.toJSBoolean(p21.lastWatch) or not equal(v67, v68) then
		p21:cancel()
		p21.lastWatch = v66
		p21.cancel = p21.cache:watch(p21.lastWatch)
	end
end
function t4.resetLastWrite(p25) -- line: 477
	p25.lastWrite = nil
end
function t4.shouldWrite(t8: {[any]: any}, p26, t9: {[any]: any}) -- line: 481
	-- upvalues: Boolean (copy), v21 (copy), equal (copy)
	local lastWrite = t8.lastWrite

	return not (Boolean.toJSBoolean(lastWrite) and (lastWrite.dmCount == v21:get(t8.cache) and (equal(t9, lastWrite.variables) and equal(p26.data, lastWrite.result.data))))
end

local shouldWriteResult = nil

function t4.markResult(t10: {[any]: any}, p27, t11: {[any]: any}, n1: number) -- line: 507
	-- upvalues: isNonEmptyArray (copy), t2 (copy), shouldWriteResult (ref), v21 (copy), Boolean (copy)
	if isNonEmptyArray(p27.errors) then
		t10.graphQLErrors = p27.errors
	else
		t10.graphQLErrors = {}
	end

	t10:reset()

	if t11.fetchPolicy == "no-cache" then
		t10:updateLastDiff({
			complete = true,
			result = p27.data
		}, t10:getDiffOptions(t11.variables))

		return
	end

	if n1 ~= t2.FORBID then
		if shouldWriteResult(p27, t11.errorPolicy) then
			t10.cache:performTransaction(function(p28) -- line: 529
				-- upvalues: t10 (copy), p27 (copy), t11 (copy), n1 (copy), t2 (copy), v21 (copy), Boolean (copy)
				if t10:shouldWrite(p27, t11.variables) then
					p28:writeQuery({
						query = t10.document,
						data = p27.data,
						variables = t11.variables,
						overwrite = n1 == t2.OVERWRITE
					})
					t10.lastWrite = {
						result = p27,
						variables = t11.variables,
						dmCount = v21:get(t10.cache)
					}
				elseif Boolean.toJSBoolean(t10.lastDiff) and Boolean.toJSBoolean(t10.lastDiff.diff.complete) then
					p27.data = t10.lastDiff.diff.result

					return
				end

				local v89 = t10:getDiffOptions(t11.variables)
				local v90 = p28:diff(v89)

				if not t10.stopped then
					t10:updateWatch(t11.variables)
				end

				t10:updateLastDiff(v90, v89)

				if Boolean.toJSBoolean(v90.complete) then
					p27.data = v90.result
				end
			end)

			return
		end

		t10.lastWrite = nil
	end
end
function t4.markReady(p29) -- line: 613
	-- upvalues: NetworkStatus (copy)
	p29.networkError = nil
	p29.networkStatus = NetworkStatus.ready

	return p29.networkStatus
end
function t4.markError(p30, p31) -- line: 619
	-- upvalues: NetworkStatus (copy), Boolean (copy)
	p30.networkStatus = NetworkStatus.error
	p30.lastWrite = nil
	p30:reset()

	if Boolean.toJSBoolean(p31.graphQLErrors) then
		p30.graphQLErrors = p31.graphQLErrors
	end

	if Boolean.toJSBoolean(p31.networkError) then
		p30.networkError = p31.networkError
	end

	return p31
end

t1.QueryInfo = t4

function shouldWriteResult(p32, p33) -- line: 637
	-- upvalues: graphQLResultHasError (copy), Boolean (copy)
	if p33 == nil then
		p33 = "none"
	end

	local v83 = p33 == "ignore" or p33 == "all"

	return not graphQLResultHasError(p32) or (not v83 or not not Boolean.toJSBoolean(p32.data))
end

t1.shouldWriteResult = shouldWriteResult

return t1
