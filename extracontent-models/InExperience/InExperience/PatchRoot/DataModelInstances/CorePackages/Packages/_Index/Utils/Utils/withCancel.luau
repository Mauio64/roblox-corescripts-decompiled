local Boolean = require((nil).LuauPolyfill).Boolean
local Promise = require((nil).Promise)
local t1 = {}
local _ = require((nil).Dev.JestGlobals).expect

local function defaultAsyncIteratorReturn(p1) -- line: 14
	-- upvalues: Promise (copy)
	return Promise.resolve():andThen(function() -- line: 15
		-- upvalues: p1 (copy)
		return {
			done = true,
			value = p1
		}
	end)
end

local v6 = require(script.Parent["memoize.js"]).memoize2(function(p2, p3) -- line: 19
	return function(...) -- line: 20
		-- upvalues: p3 (copy), p2 (copy)
		return Reflect:apply(p3, p2, { ... })
	end
end)

local function getAsyncIteratorWithCancel(p4, p5: ((...any) -> ...any)) -- line: 29
	-- upvalues: Boolean (copy), defaultAsyncIteratorReturn (copy), Promise (copy), v6 (copy)
	return Proxy.new(p4, {
		has = function(_, p7, p8) -- line: 35
			if p8 == "return" then
				return true
			end

			return Reflect:has(p7, p8)
		end,
		get = function(_, p10, p11, p12) -- line: 41
			-- upvalues: Boolean (copy), defaultAsyncIteratorReturn (copy), Promise (copy), p5 (copy), v6 (copy)
			local v23 = Reflect:get(p10, p11, p12)

			if p11 == "return" then
				local v24 = Boolean.toJSBoolean(v23) and v23 or defaultAsyncIteratorReturn

				return function(p13) -- line: 46
					-- upvalues: Promise (copy), p5 (copy), v24 (copy), p10 (copy)
					return Promise.resolve():andThen(function() -- line: 47
						-- upvalues: p5 (copy), p13 (copy), v24 (copy), p10 (copy)
						local v32 = p5(p13):expect()

						return Reflect:apply(v24, p10, { v32 })
					end)
				end
			end

			if typeof(v23) == "function" then
				return v6(p10, v23)
			end

			return v23
		end
	})
end

t1.getAsyncIteratorWithCancel = getAsyncIteratorWithCancel

local function getAsyncIterableWithCancel(p14, p15: ((...any) -> ...any)) -- line: 62
	-- upvalues: getAsyncIteratorWithCancel (copy), v6 (copy)
	return Proxy.new(p14, {
		get = function(_, p17, p18, p19) -- line: 68
			-- upvalues: getAsyncIteratorWithCancel (copy), p15 (copy), v6 (copy)
			local v29 = Reflect:get(p17, p18, p19)

			if p18 == Symbol.asyncIterator then
				return function() -- line: 71
					-- upvalues: v29 (copy), p17 (copy), getAsyncIteratorWithCancel (copy), p15 (copy)
					local v31 = Reflect:apply(v29, p17, {})

					return getAsyncIteratorWithCancel(v31, p15)
				end
			end

			if typeof(v29) == "function" then
				return v6(p17, v29)
			end

			return v29
		end
	})
end

t1.getAsyncIterableWithCancel = getAsyncIterableWithCancel
t1.withCancel = getAsyncIterableWithCancel

return t1
