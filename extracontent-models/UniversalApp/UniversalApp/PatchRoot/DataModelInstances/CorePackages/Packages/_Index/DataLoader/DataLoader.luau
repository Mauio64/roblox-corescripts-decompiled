local parent = script.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local instanceof = LuauPolyfill.instanceof
local setTimeout = LuauPolyfill.setTimeout

local Error = LuauPolyfill.Error
local err = LuauPolyfill.Error
local Promise = require(parent.Promise)

local getCurrentBatch
local getValidMaxBatchSize
local dispatchBatch
local failedDispatch
local resolveCacheHits
local getValidBatchScheduleFn
local getValidCacheKeyFn
local getValidCacheMap
local getValidName
local isArrayLike

local class = {}

class.__index = class

function class.new(batchLoadFn, p)
	local self = setmetatable({}, class)

	if typeof(batchLoadFn) ~= "function" then
		error(Error.new("DataLoader must be constructed with a function which accepts " .. ("Array<key> and returns Promise<Array<value>>, but got: %s."):format((tostring(batchLoadFn)))))
	end

	self._batchLoadFn = batchLoadFn
	self._maxBatchSize = getValidMaxBatchSize(p)
	self._batchScheduleFn = getValidBatchScheduleFn(p)
	self._cacheKeyFn = getValidCacheKeyFn(p)
	self._cacheMap = getValidCacheMap(p)
	self._batch = nil
	self.name = getValidName(p)
	return self
end

function class:load(p)
	if p == nil then
		error(Error.new("The loader.load() function must be called with a value, " .. ("but got: %s."):format((tostring(nil)))))
	end

	local v = getCurrentBatch(self)
	local cacheMap = self._cacheMap
	local cacheKeyFn = self._cacheKeyFn(p)

	if Boolean.toJSBoolean(cacheMap) then
		local v2 = cacheMap:get(cacheKeyFn)

		if Boolean.toJSBoolean(v2) then
			local cacheHits = Boolean.toJSBoolean(v.cacheHits) and v.cacheHits

			if not cacheHits then
				v.cacheHits = {}
				cacheHits = v.cacheHits
			end

			return Promise.new(function(callback)
				table.insert(cacheHits, function()
					callback(v2)
				end)
			end)
		end
	end

	table.insert(v.keys, p)
	local v2 = Promise.new(function(resolve, reject)
		table.insert(v.callbacks, { resolve = resolve, reject = reject })
	end)

	if Boolean.toJSBoolean(cacheMap) then
		cacheMap:set(cacheKeyFn, v2)
	end

	return v2
end

function class:loadMany(list)
	if not Boolean.toJSBoolean(isArrayLike(list)) then
		error(Error.new("The loader.loadMany() function must be called with Array<key> " .. ("but got: %s."):format((tostring(list)))))
	end

	local count = 0
	local v = {}

	while count < #list do
		table.insert(v, self:load(list[count + 1]):catch(function(p)
			return p
		end))

		count += 1
	end

	return Promise.all(v)
end

function class:clear(p)
	local cacheMap = self._cacheMap

	if Boolean.toJSBoolean(cacheMap) then
		cacheMap:delete((self._cacheKeyFn(p)))
	end

	return self
end

function class:clearAll()
	local cacheMap = self._cacheMap

	if Boolean.toJSBoolean(cacheMap) then
		cacheMap:clear()
	end

	return self
end

function class:prime(p, p2)
	local cacheMap = self._cacheMap

	if not Boolean.toJSBoolean(cacheMap) then
		return self
	end

	local cacheKeyFn = self._cacheKeyFn(p)

	if cacheMap:get(cacheKeyFn) ~= nil then
		return self
	end

	local v

	if instanceof(p2, err) then
		v = Promise.reject(p2)

		v:catch(function() end)
	else
		v = Promise.resolve(p2)
	end

	cacheMap:set(cacheKeyFn, v)

	return self
end

local function fn(p)
	setTimeout(p)
end

getCurrentBatch = function(state)
	local batch = state._batch

	if batch ~= nil and not Boolean.toJSBoolean(batch.hasDispatched) and #batch.keys < state._maxBatchSize then
		return batch
	end

	local batch2 = { hasDispatched = false, keys = {}, callbacks = {} }

	state._batch = batch2

	state._batchScheduleFn(function()
		dispatchBatch(state, batch2)
	end)
	return batch2
end

dispatchBatch = function(state, state2)
	state2.hasDispatched = true

	if #state2.keys == 0 then
		resolveCacheHits(state2)
		return
	end

	local v = nil

	local _, result, v2 = xpcall(function()
		v = state._batchLoadFn(state2.keys)
	end, function(p)
		return
			failedDispatch(
				state,
				state2,
				Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function " .. ("errored synchronously: %s."):format((tostring(p))))
			),
			true
	end)

	if v2 then
		return result
	end

	if not Boolean.toJSBoolean(v) or typeof(v.andThen) ~= "function" then
		return failedDispatch(
			state,
			state2,
			Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function did " .. ("not return a Promise: %s."):format((tostring(v))))
		)
	end

	v:andThen(function(list)
		if not Boolean.toJSBoolean(isArrayLike(list)) then
			error(Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function did " .. ("not return a Promise of an Array: %s."):format(table.concat(list, ","))))
		end

		if #list ~= #state2.keys then
			error(Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function did " .. "not return a Promise of an Array of the same length as the Array " .. "of keys." .. ("\n\nKeys:\n%s"):format(table.concat(state2.keys, ",")) .. ("\n\nValues:\n%s"):format(table.concat(list, ","))))
		end

		resolveCacheHits(state2)
		local count = 0

		while count < #state2.callbacks do
			local item = list[count + 1]

			if instanceof(item, err) then
				state2.callbacks[count + 1].reject(item)
			else
				state2.callbacks[count + 1].resolve(item)
			end

			count += 1
		end
	end):catch(function(p)
		failedDispatch(state, state2, p)
	end)
	return nil
end

failedDispatch = function(object, state, p)
	resolveCacheHits(state)
	local count = 0

	while count < #state.keys do
		object:clear(state.keys[count + 1])
		state.callbacks[count + 1].reject(p)

		count += 1
	end
end

resolveCacheHits = function(p)
	if Boolean.toJSBoolean(p.cacheHits) then
		local count = 0

		while count < #p.cacheHits do
			p.cacheHits[count + 1]()

			count += 1
		end
	end
end

getValidMaxBatchSize = function(value)
	local v = not Boolean.toJSBoolean(value) or value.batch ~= false

	if not Boolean.toJSBoolean(v) then
		return 1
	end

	if Boolean.toJSBoolean(value) then
		value = value.maxBatchSize
	end

	if value == nil then
		return 1e999
	end

	if typeof(value) ~= "number" or value < 1 then
		error(Error.new(("maxBatchSize must be a positive number: %s"):format((tostring(value)))))
	end

	return value
end

getValidBatchScheduleFn = function(callback)
	if Boolean.toJSBoolean(callback) then
		callback = callback.batchScheduleFn
	end

	if callback == nil then
		return fn
	end

	if typeof(callback) ~= "function" then
		error(Error.new(("batchScheduleFn must be a function: %s"):format((tostring(callback)))))
	end

	return callback
end

getValidCacheKeyFn = function(callback)
	if Boolean.toJSBoolean(callback) then
		callback = callback.cacheKeyFn
	end

	if callback == nil then
		return function(p)
			return p
		end
	end

	if typeof(callback) ~= "function" then
		error(Error.new(("cacheKeyFn must be a function: %s"):format((tostring(callback)))))
	end

	return callback
end

getValidCacheMap = function(p)
	local v = not Boolean.toJSBoolean(p) or p.cache ~= false

	if not Boolean.toJSBoolean(v) then
		return nil
	end

	if Boolean.toJSBoolean(p) then
		p = p.cacheMap
	end

	if p == nil then
		return Map.new()
	end

	if p ~= nil then
		local filtered = Array.filter({ "get", "set", "delete", "clear" }, function(p2)
			if Boolean.toJSBoolean(p) then
				return typeof(p[tostring(p2)]) ~= "function"
			end

			return p
		end)

		if #filtered ~= 0 then
			error(Error.new("Custom cacheMap missing methods: " .. tostring(Array.join(filtered, ", "))))
		end
	end

	return p
end

getValidName = function(p)
	local toJSBoolean = Boolean.toJSBoolean
	local v = if Boolean.toJSBoolean(p) then p.name else p
	return if toJSBoolean(v) then p.name else nil
end

isArrayLike = function(list): boolean
	if typeof(list) == "table" then
		if #list == 0 then
			return true
		elseif #list > 0 then
			return list[#list] ~= nil
		else
			return false
		end
	else
		return false
	end
end

return { DataLoader = class }
