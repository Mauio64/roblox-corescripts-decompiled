local LuauPolyfill = require((nil).LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local Promise = require((nil).Promise)

local JestGlobals = require((nil).Dev.JestGlobals)
local expect = JestGlobals.expect
local memoizejs = require(script.Parent["memoize.js"])
local function defaultAsyncIteratorReturn(p)
	return Promise.resolve():andThen(function()
		return { value = p, done = true }
	end)
end

local memoize2 = memoizejs.memoize2(function(p, p2)
	return function(...)
		return Reflect:apply(p2, p, { ... })
	end
end)

local function getAsyncIteratorWithCancel(p, callback)
	return Proxy.new(p, {
		has = function(self, p2, p3)
			if p3 == "return" then
				return true
			end

			return Reflect:has(p2, p3)
		end,
		get = function(self, p2, p3, p4)
			local v = Reflect:get(p2, p3, p4)

			if p3 == "return" then
				local v2 = Boolean.toJSBoolean(v) and v or defaultAsyncIteratorReturn

				return function(p5)
					return Promise.resolve():andThen(function()
						local v3 = { (callback(p5):expect()) }
						return Reflect:apply(v2, p2, v3)
					end)
				end
			end

			if typeof(v) == "function" then
				return memoize2(p2, v)
			end

			return v
		end
	})
end

local WithCancel = {}
WithCancel.getAsyncIteratorWithCancel = getAsyncIteratorWithCancel

local function getAsyncIterableWithCancel(p, callback)
	return Proxy.new(p, {
		get = function(self, p2, p3, p4)
			local v = Reflect:get(p2, p3, p4)

			if Symbol.asyncIterator == p3 then
				return function()
					return getAsyncIteratorWithCancel(Reflect:apply(v, p2, {}), callback)
				end
			end

			if typeof(v) == "function" then
				return memoize2(p2, v)
			end

			return v
		end
	})
end

WithCancel.getAsyncIterableWithCancel = getAsyncIterableWithCancel
WithCancel.withCancel = getAsyncIterableWithCancel
return WithCancel
