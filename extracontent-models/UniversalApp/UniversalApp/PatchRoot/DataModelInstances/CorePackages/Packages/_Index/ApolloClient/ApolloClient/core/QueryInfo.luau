local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)

local Boolean = LuauPolyfill.Boolean
local clearTimeout = LuauPolyfill.clearTimeout
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local setTimeout = LuauPolyfill.setTimeout
local WeakMap = LuauPolyfill.WeakMap

require(parent2.GraphQL)

local equal = require(parent.jsutils.equal)

require(parent.cache)

require(script.Parent.watchQueryOptions_types)

require(script.Parent.ObservableQuery_types)

require(script.Parent.Parent.link.core)

local utilities = require(script.Parent.Parent.utilities)

local isNonEmptyArray = utilities.isNonEmptyArray
local graphQLResultHasError = utilities.graphQLResultHasError
local canUseWeakMap = utilities.canUseWeakMap
local networkStatus = require(script.Parent.networkStatus)
local networkStatus2 = networkStatus.NetworkStatus

local isNetworkRequestInFlight = networkStatus.isNetworkRequestInFlight

require(script.Parent.Parent.errors)

local cacheWriteBehavior = { FORBID = 0, OVERWRITE = 1, MERGE = 2 }
local QueryInfo = {}
QueryInfo.CacheWriteBehavior = cacheWriteBehavior
local v

if canUseWeakMap then
	v = WeakMap.new()
else
	v = Map.new(nil)
end

local function wrapDestructiveCacheMethod(p, p2: string) -- 3 equivalent calls inferred from this helper
	local v2 = p[p2]

	if typeof(v2) == "function" then
		p[p2] = function(...)
			v:set(p, (v:get(p) + 1) % 1000000000000000)

			return v2(...)
		end
	end
end

local function cancelNotifyTimeout(p) -- 2 equivalent calls inferred from this helper
	if Boolean.toJSBoolean(p.notifyTimeout) then
		clearTimeout(p.notifyTimeout)
		p.notifyTimeout = nil
	end
end

local class = {}
class.__index = class

function class.new(cache)
	local v2 = {
		["listeners"] = Set.new(),
		document = nil,
		lastRequestId = 1,
		subscriptions = Set.new(),
		stopped = false,
		cache = cache,
		dirty = false,
		observableQuery = nil
	}

	if not v:has(cache) then
		v:set(cache, 0)
		wrapDestructiveCacheMethod(cache, "evict") -- inferred equivalent call
		wrapDestructiveCacheMethod(cache, "modify") -- inferred equivalent call
		wrapDestructiveCacheMethod(cache, "reset") -- inferred equivalent call
	end

	return (setmetatable(v2, class))
end

function class:init(data)
	local networkStatus3 = Boolean.toJSBoolean(data.networkStatus) and data.networkStatus or networkStatus2.loading

	if
		Boolean.toJSBoolean(self.variables)
		and self.networkStatus ~= networkStatus2.loading
		and not equal(self.variables, data.variables)
	then
		networkStatus3 = networkStatus2.setVariables
	end

	if not equal(data.variables, self.variables) then
		self.lastDiff = nil
	end

	Object.assign(self, {
		document = data.document,
		variables = data.variables,
		networkError = Object.None,
		graphQLErrors = Boolean.toJSBoolean(self.graphQLErrors) and self.graphQLErrors or {},
		networkStatus = networkStatus3
	})

	if Boolean.toJSBoolean(data.observableQuery) then
		self:setObservableQuery(data.observableQuery)
	end

	if Boolean.toJSBoolean(data.lastRequestId) then
		self.lastRequestId = data.lastRequestId
	end

	return self
end

function class:reset()
	cancelNotifyTimeout(self) -- inferred equivalent call
	self.lastDiff = nil
	self.dirty = false
end

function class:getDiff(variables)
	if variables == nil then
		variables = self.variables
	end

	local diffOptions = self:getDiffOptions(variables)

	if Boolean.toJSBoolean(self.lastDiff) and equal(diffOptions, self.lastDiff.options) then
		return self.lastDiff.diff
	end

	self.variables = variables
	self:updateWatch(self.variables)

	local observableQuery = self.observableQuery

	if Boolean.toJSBoolean(observableQuery) and observableQuery.options.fetchPolicy == "no-cache" then
		return { complete = false }
	end

	local diff = self.cache:diff(diffOptions)
	self:updateLastDiff(diff, diffOptions)
	return diff
end

function class:updateLastDiff(diff, p)
	self.lastDiff = Boolean.toJSBoolean(diff) and ({
		diff = diff,
		options = Boolean.toJSBoolean(p) and p or self:getDiffOptions()
	} or nil) or nil
end

function class:getDiffOptions(variables)
	if variables == nil then
		variables = self.variables
	end

	local observableQuery = self.observableQuery

	return {
		query = self.document,
		variables = variables,
		returnPartialData = true,
		optimistic = true,
		canonizeResults = not Boolean.toJSBoolean(observableQuery) or observableQuery.options.canonizeResults ~= false
	}
end

function class:setDiff(p)
	local v2

	if Boolean.toJSBoolean(self.lastDiff) then
		v2 = self.lastDiff.diff
	else
		v2 = self.lastDiff
	end

	self:updateLastDiff(p)

	if Boolean.toJSBoolean(v2) then
		v2 = v2.result
	end

	if Boolean.toJSBoolean(p) then
		p = p.result
	end

	if not (self.dirty or equal(v2, p)) then
		self.dirty = true

		if not Boolean.toJSBoolean(self.notifyTimeout) then
			self.notifyTimeout = setTimeout(function()
				return self:notify()
			end, 0)
		end
	end
end

function class:setObservableQuery(observableQuery)
	if observableQuery == self.observableQuery then
		return
	end

	if Boolean.toJSBoolean(self.oqListener) then
		self.listeners:delete(self.oqListener)
	end

	self.observableQuery = observableQuery

	if not Boolean.toJSBoolean(observableQuery) or observableQuery == nil then
		self.oqListener = nil

		return
	end

	observableQuery.queryInfo = self
	function self.oqListener()
		if Boolean.toJSBoolean(self:getDiff().fromOptimisticTransaction) then
			observableQuery.observe(observableQuery)
		else
			observableQuery:reobserve()
		end
	end
	self.listeners:add(self.oqListener)
end

function class:notify()
	cancelNotifyTimeout(self) -- inferred equivalent call

	if self:shouldNotify() then
		self.listeners:forEach(function(callback)
			return callback(self)
		end)
	end

	self.dirty = false
end

function class:shouldNotify(): boolean
	if not (self.dirty and Boolean.toJSBoolean(self.listeners.size)) then
		return false
	end

	if isNetworkRequestInFlight(self.networkStatus) and Boolean.toJSBoolean(self.observableQuery) then
		local fetchPolicy = self.observableQuery.options.fetchPolicy

		if fetchPolicy ~= "cache-only" and fetchPolicy ~= "cache-and-network" then
			return false
		end
	end

	return true
end

function class:stop()
	if not self.stopped then
		self.stopped = true

		self:reset()
		self:cancel()

		self.cancel = class.cancel

		self.subscriptions:forEach(function(object)
			return object:unsubscribe()
		end)

		local observableQuery = self.observableQuery

		if Boolean.toJSBoolean(observableQuery) then
			observableQuery:stopPolling()
		end
	end
end

function class:cancel() end

function class:updateWatch(p)
	if p == nil then
		p = self.variables
	end

	local observableQuery = self.observableQuery

	if Boolean.toJSBoolean(observableQuery) and observableQuery.options.fetchPolicy == "no-cache" then
		return
	end

	local lastWatch = Object.assign({}, self:getDiffOptions(p), {
		watcher = self,
		callback = function(_, p2)
			return self:setDiff(p2)
		end
	})

	local v2 = Object.assign({}, lastWatch, { callback = Object.None })
	local v3 = Object.assign({}, self.lastWatch, { callback = Object.None })

	if not (Boolean.toJSBoolean(self.lastWatch) and equal(v2, v3)) then
		self:cancel()
		self.lastWatch = lastWatch
		self.cancel = self.cache:watch(self.lastWatch)
	end
end

function class:resetLastWrite()
	self.lastWrite = nil
end

function class:shouldWrite(p, p2): boolean
	local lastWrite = self.lastWrite

	local v2 = Boolean.toJSBoolean(lastWrite)

	if v2 then
		if lastWrite.dmCount == v:get(self.cache) then
			v2 = equal(p2, lastWrite.variables) and equal(p.data, lastWrite.result.data)
		else
			v2 = false
		end
	end

	return not v2
end

local shouldWriteResult

function class:markResult(state, data, p: number)
	if isNonEmptyArray(state.errors) then
		self.graphQLErrors = state.errors
	else
		self.graphQLErrors = {}
	end

	self:reset()

	if data.fetchPolicy == "no-cache" then
		self:updateLastDiff({ result = state.data, complete = true }, self:getDiffOptions(data.variables))
	elseif p ~= cacheWriteBehavior.FORBID then
		if shouldWriteResult(state, data.errorPolicy) then
			self.cache:performTransaction(function(object)
				if self:shouldWrite(state, data.variables) then
					object:writeQuery({
						query = self.document,
						data = state.data,
						variables = data.variables,
						overwrite = p == cacheWriteBehavior.OVERWRITE
					})

					self.lastWrite = {
						result = state,
						variables = data.variables,
						dmCount = v:get(self.cache)
					}
				elseif Boolean.toJSBoolean(self.lastDiff) and Boolean.toJSBoolean(self.lastDiff.diff.complete) then
					state.data = self.lastDiff.diff.result
					return
				end

				local diffOptions = self:getDiffOptions(data.variables)
				local diff = object:diff(diffOptions)

				if not self.stopped then
					self:updateWatch(data.variables)
				end

				self:updateLastDiff(diff, diffOptions)

				if Boolean.toJSBoolean(diff.complete) then
					state.data = diff.result
				end
			end)
		else
			self.lastWrite = nil
		end
	end
end

function class:markReady()
	self.networkError = nil
	self.networkStatus = networkStatus2.ready
	return self.networkStatus
end

function class:markError(p)
	self.networkStatus = networkStatus2.error
	self.lastWrite = nil

	self:reset()

	if Boolean.toJSBoolean(p.graphQLErrors) then
		self.graphQLErrors = p.graphQLErrors
	end

	if Boolean.toJSBoolean(p.networkError) then
		self.networkError = p.networkError
	end

	return p
end

QueryInfo.QueryInfo = class

shouldWriteResult = function(state, errorPolicy)
	local v2 = errorPolicy == nil and "none" or errorPolicy

	local v3 = v2 == "ignore" or v2 == "all"
	local v4 = not graphQLResultHasError(state)

	return not v4 and v3 and Boolean.toJSBoolean(state.data) and true or v4
end

QueryInfo.shouldWriteResult = shouldWriteResult

return QueryInfo
