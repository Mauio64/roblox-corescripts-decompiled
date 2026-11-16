local LuauPolyfill = require((nil).LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

return {
	observableToAsyncIterable = function(object)
		local callbacks = {}
		local v = {}
		local v2 = true
		local function pushValue(p)
			if callbacks.length == 0 then
				table.insert(v, { value = p, done = false })
			else
				table.remove(callbacks, 1)({ value = p, done = false })
			end
		end
		local function pushError(p)
			if callbacks.length == 0 then
				table.insert(v, {
					value = {
						errors = { p }
					},
					done = false
				})
			else
				table.remove(callbacks, 1)({
					value = {
						errors = { p }
					},
					done = false
				})
			end
		end
		local function pushDone()
			if callbacks.length == 0 then
				table.insert(v, { done = true })
			else
				table.remove(callbacks, 1)({ done = true })
			end
		end
		local function pullValue() -- 1 equivalent call inferred from this helper
			return Promise.new(function(callback)
				if v.length == 0 then
					table.insert(callbacks, callback)
				else
					callback((table.remove(v, 1)))
				end
			end)
		end

		local v3 = object:subscribe({
			next = function(_, p)
				pushValue(p)
			end,
			error = function(_, p)
				pushError(p)
			end,
			complete = function(_)
				pushDone()
			end
		})

		local function emptyQueue()
			if Boolean.toJSBoolean(v2) then
				v2 = false
				v3:unsubscribe()

				for _, v4 in callbacks do
					v4({ value = nil, done = true })
				end

				callbacks.length = 0
				v.length = 0
			end
		end
		return {
			next = function(p)
				if Boolean.toJSBoolean(v2) then
					return (pullValue()) -- inferred equivalent call
				end

				return (p["return"]())
			end,
			["return"] = function(_)
				emptyQueue()
				return Promise.resolve({ value = nil, done = true })
			end,
			throw = function(_, p)
				emptyQueue()
				return Promise.reject(p)
			end,
			[tostring(Symbol.asyncIterator)] = function(p)
				return p
			end
		}
	end
}
