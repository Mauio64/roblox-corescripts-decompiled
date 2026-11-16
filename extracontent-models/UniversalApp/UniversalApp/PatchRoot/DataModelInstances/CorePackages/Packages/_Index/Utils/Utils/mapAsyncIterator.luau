local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local Promise = require(parent.Promise)

local asyncMapValue
local iteratorResult

local MapAsyncIterator = {
	mapAsyncIterator = function(object, callback, p)
		local v, fn

		if typeof(object["return"]) == "function" then
			v = object["return"]
			fn = function(p2)
				local function rethrow()
					return Promise.reject(p2)
				end

				return v(object):andThen(rethrow, rethrow)
			end
		else
			fn = nil
			v = nil
		end

		local function mapResult(p2)
			if Boolean.toJSBoolean(p2.done) then
				return p2
			end

			return (asyncMapValue(p2.value, callback):andThen(iteratorResult, fn))
		end

		local fn2 = p and function(p2)
			return asyncMapValue(p2, p):andThen(iteratorResult, fn)
		end or nil

		return {
			next = function(self)
				return object:next():andThen(mapResult, fn2)
			end,
			["return"] = function(_)
				if Boolean.toJSBoolean(v) then
					return (v(object):andThen(mapResult, fn2))
				end

				return (Promise.resolve({ value = nil, done = true }))
			end,
			throw = function(_, p2)
				if typeof(object.throw) == "function" then
					return object.throw(object, p2):andThen(mapResult, fn2)
				end

				return Promise.reject(p2):catch(fn)
			end
		}
	end
}

asyncMapValue = function(p, callback)
	return Promise.new(function(callback2)
		return callback2(callback(p))
	end)
end

iteratorResult = function(p)
	return { value = p, done = false }
end

return MapAsyncIterator
