local scriptParent = script.Parent
local LuauPolyfill = require(scriptParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local instanceof = LuauPolyfill.instanceof
local setTimeout = LuauPolyfill.setTimeout
local Error = LuauPolyfill.Error
local Error2 = LuauPolyfill.Error
local Promise = require(scriptParent.Promise)
local t1 = {}
local getCurrentBatch = nil
local getValidMaxBatchSize = nil
local dispatchBatch = nil
local failedDispatch = nil
local resolveCacheHits = nil
local getValidBatchScheduleFn = nil
local getValidCacheKeyFn = nil
local getValidCacheMap = nil
local getValidName = nil
local isArrayLike = nil
local t2 = {}

t2.__index = t2

function t2.new(p1: ((...any) -> ...any), t3: {[any]: any}?) -- line: 142
	-- upvalues: t2 (copy), Error (copy), getValidMaxBatchSize (ref), getValidBatchScheduleFn (ref), getValidCacheKeyFn (ref), getValidCacheMap (ref), getValidName (ref)
	local self = setmetatable({}, t2)

	if typeof(p1) ~= "function" then
		error(Error.new("DataLoader must be constructed with a function which accepts " .. ("Array<key> and returns Promise<Array<value>>, but got: %s."):format((tostring(p1)))))
	end

	self._batchLoadFn = p1
	self._maxBatchSize = getValidMaxBatchSize(t3)
	self._batchScheduleFn = getValidBatchScheduleFn(t3)
	self._cacheKeyFn = getValidCacheKeyFn(t3)
	self._cacheMap = getValidCacheMap(t3)
	self._batch = nil
	self.name = getValidName(t3)

	return self
end
function t2.load(p2, p3) -- line: 162
	-- upvalues: Error (copy), getCurrentBatch (ref), Boolean (copy), Promise (copy)
	local g34 = nil
	local cacheHits = nil

	if p3 == nil then
		error(Error.new("The loader.load() function must be called with a value, " .. ("but got: %s."):format((tostring(p3)))))
	end

	local v29 = getCurrentBatch(p2)
	local _cacheMap = p2._cacheMap
	local v31 = p2._cacheKeyFn(p3)

	if Boolean.toJSBoolean(_cacheMap) then
		local v32 = _cacheMap:get(v31)

		if Boolean.toJSBoolean(v32) then
			if Boolean.toJSBoolean(v29.cacheHits) then
				cacheHits = v29.cacheHits

				if cacheHits then
					g34 = true
				end
			end

			if not g34 then
				v29.cacheHits = {}
				cacheHits = v29.cacheHits
			end

			g34 = false

			local v35 = cacheHits

			return Promise.new(function(resolve) -- line: 182
				-- upvalues: v35 (copy), v32 (copy)
				table.insert(v35, function() -- line: 183
					-- upvalues: resolve (copy), v32 (copy)
					resolve(v32)
				end)
			end)
		end
	end

	table.insert(v29.keys, p3)

	local v36 = Promise.new(function(resolve, reject) -- line: 192
		-- upvalues: v29 (copy)
		table.insert(v29.callbacks, {
			resolve = resolve,
			reject = reject
		})
	end)

	if Boolean.toJSBoolean(_cacheMap) then
		_cacheMap:set(v31, v36)
	end

	return v36
end
function t2.loadMany(p4, p5) -- line: 202
	-- upvalues: Boolean (copy), isArrayLike (ref), Error (copy), Promise (copy)
	if not Boolean.toJSBoolean(isArrayLike(p5)) then
		error(Error.new("The loader.loadMany() function must be called with Array<key> " .. ("but got: %s."):format((tostring(p5)))))
	end

	local t4 = {}
	local n1 = 0

	while n1 < #p5 do
		table.insert(t4, p4:load(p5[n1 + 1]):catch(function(p6) -- line: 219
			return p6
		end))
		n1 += 1
	end

	return Promise.all(t4)
end
function t2.clear(p7, p8) -- line: 230
	-- upvalues: Boolean (copy)
	local _cacheMap = p7._cacheMap

	if Boolean.toJSBoolean(_cacheMap) then
		_cacheMap:delete((p7._cacheKeyFn(p8)))
	end

	return p7
end
function t2.clearAll(p9) -- line: 239
	-- upvalues: Boolean (copy)
	local _cacheMap = p9._cacheMap

	if Boolean.toJSBoolean(_cacheMap) then
		_cacheMap:clear()
	end

	return p9
end
function t2.prime(p10, p11, p12) -- line: 247
	-- upvalues: Boolean (copy), instanceof (copy), Error2 (copy), Promise (copy)
	local _cacheMap = p10._cacheMap

	if Boolean.toJSBoolean(_cacheMap) then
		local v50 = p10._cacheKeyFn(p11)

		if _cacheMap:get(v50) == nil then
			local v51

			if instanceof(p12, Error2) then
				v51 = Promise.reject(p12)
				v51:catch(function() -- line: 260
				end)
			else
				v51 = Promise.resolve(p12)
			end

			_cacheMap:set(v50, v51)
		end
	end

	return p10
end

local function v23(p13) -- line: 296
	-- upvalues: setTimeout (copy)
	setTimeout(p13)
end

function getCurrentBatch(t5: {[any]: any}) -- line: 316
	-- upvalues: Boolean (copy), dispatchBatch (ref)
	local _batch = t5._batch

	if _batch ~= nil and (not Boolean.toJSBoolean(_batch.hasDispatched) and #_batch.keys < t5._maxBatchSize) then
		return _batch
	end

	local t6 = {
		hasDispatched = false,
		keys = {},
		callbacks = {}
	}

	t5._batch = t6
	t5._batchScheduleFn(function() -- line: 332
		-- upvalues: dispatchBatch (ref), t5 (copy), t6 (copy)
		dispatchBatch(t5, t6)
	end)

	return t6
end
function dispatchBatch(t7: {[any]: any}, t8: {[any]: any}) -- line: 338
	-- upvalues: resolveCacheHits (ref), failedDispatch (ref), Error (copy), Boolean (copy), isArrayLike (ref), instanceof (copy), Error2 (copy)
	t8.hasDispatched = true

	if #t8.keys == 0 then
		resolveCacheHits(t8)

		return
	end

	local u58 = nil
	local _, result, v61 = xpcall(function() -- line: 350
		-- upvalues: u58 (ref), t7 (copy), t8 (copy)
		u58 = t7._batchLoadFn(t8.keys)
	end, function(err) -- line: 352
		-- upvalues: failedDispatch (ref), t7 (copy), t8 (copy), Error (copy)
		return failedDispatch(t7, t8, Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function " .. ("errored synchronously: %s."):format((tostring(err))))), true
	end)

	if v61 then
		return result
	end

	if not Boolean.toJSBoolean(u58) or typeof(u58.andThen) ~= "function" then
		return failedDispatch(t7, t8, Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function did " .. ("not return a Promise: %s."):format((tostring(u58)))))
	end

	u58:andThen(function(p14) -- line: 384
		-- upvalues: Boolean (copy), isArrayLike (ref), Error (copy), t8 (copy), resolveCacheHits (ref), instanceof (copy), Error2 (copy)
		if not Boolean.toJSBoolean(isArrayLike(p14)) then
			error(Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function did " .. ("not return a Promise of an Array: %s."):format(table.concat(p14, ","))))
		end

		if #p14 ~= #t8.keys then
			error(Error.new("DataLoader must be constructed with a function which accepts " .. "Array<key> and returns Promise<Array<value>>, but the function did " .. "not return a Promise of an Array of the same length as the Array " .. "of keys." .. ("\n\nKeys:\n%s"):format(table.concat(t8.keys, ",")) .. ("\n\nValues:\n%s"):format(table.concat(p14, ","))))
		end

		resolveCacheHits(t8)

		local n2 = 0

		while n2 < #t8.callbacks do
			local v88 = p14[n2 + 1]

			if instanceof(v88, Error2) then
				t8.callbacks[n2 + 1].reject(v88)
			else
				t8.callbacks[n2 + 1].resolve(v88)
			end

			n2 += 1
		end
	end):catch(function(p15) -- line: 425
		-- upvalues: failedDispatch (ref), t7 (copy), t8 (copy)
		failedDispatch(t7, t8, p15)
	end)

	return nil
end
function failedDispatch(t9: {[any]: any}, t10: {[any]: any}, p16) -- line: 433
	-- upvalues: resolveCacheHits (ref)
	resolveCacheHits(t10)

	local n3 = 0

	while n3 < #t10.keys do
		t9:clear(t10.keys[n3 + 1])
		t10.callbacks[n3 + 1].reject(p16)
		n3 += 1
	end
end
function resolveCacheHits(t11: {[any]: any}) -- line: 448
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(t11.cacheHits) then
		local n4 = 0

		while n4 < #t11.cacheHits do
			t11.cacheHits[n4 + 1]()
			n4 += 1
		end
	end
end
function getValidMaxBatchSize(t12: {[any]: any}?) -- line: 463
	-- upvalues: Boolean (copy), Error (copy)
	local v69 = not Boolean.toJSBoolean(t12) or t12.batch ~= false

	if not Boolean.toJSBoolean(v69) then
		return 1
	end

	local v70 = if not Boolean.toJSBoolean(t12) then t12 else t12.maxBatchSize

	if v70 == nil then
		return 1e999
	end

	if typeof(v70) ~= "number" or v70 < 1 then
		error(Error.new(("maxBatchSize must be a positive number: %s"):format((tostring(v70)))))
	end

	return v70
end
function getValidBatchScheduleFn(t13: {[any]: any}?) -- line: 481
	-- upvalues: Boolean (copy), v23 (copy), Error (copy)
	local v72 = if not Boolean.toJSBoolean(t13) then t13 else t13.batchScheduleFn

	if v72 == nil then
		return v23
	end

	if typeof(v72) ~= "function" then
		error(Error.new(("batchScheduleFn must be a function: %s"):format((tostring(v72)))))
	end

	return v72
end
function getValidCacheKeyFn(t14: {[any]: any}?) -- line: 495
	-- upvalues: Boolean (copy), Error (copy)
	local v74 = if not Boolean.toJSBoolean(t14) then t14 else t14.cacheKeyFn

	if v74 == nil then
		return function(p17) -- line: 498
			return p17
		end
	end

	if typeof(v74) ~= "function" then
		error(Error.new(("cacheKeyFn must be a function: %s"):format((tostring(v74)))))
	end

	return v74
end
function getValidCacheMap(t15: {[any]: any}?) -- line: 509
	-- upvalues: Boolean (copy), Map (copy), Array (copy), Error (copy)
	local v76 = not Boolean.toJSBoolean(t15) or t15.cache ~= false

	if not Boolean.toJSBoolean(v76) then
		return nil
	end

	local v77 = if not Boolean.toJSBoolean(t15) then t15 else t15.cacheMap

	if v77 == nil then
		return Map.new()
	end

	if v77 ~= nil then
		local v78 = Array.filter({
			"get",
			"set",
			"delete",
			"clear"
		}, function(p18) -- line: 520
			-- upvalues: Boolean (copy), v77 (copy)
			if Boolean.toJSBoolean(v77) then
				return typeof(v77[tostring(p18)]) ~= "function"
			end

			return v77
		end)

		if #v78 ~= 0 then
			error(Error.new("Custom cacheMap missing methods: " .. tostring(Array.join(v78, ", "))))
		end
	end

	return v77
end
function getValidName(t16: {[any]: any}?) -- line: 530
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(if not Boolean.toJSBoolean(t16) then t16 else t16.name) then
		return t16.name
	end

	return nil
end
function isArrayLike(p19) -- line: 538
	return typeof(p19) == "table" and (#p19 == 0 or #p19 > 0 and p19[#p19] ~= nil)
end

t1.DataLoader = t2

return t1
