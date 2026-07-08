local Boolean = require((nil).LuauPolyfill).Boolean

return {
	observableToAsyncIterable = function(t1: {[any]: any}) -- line: 15
		-- upvalues: Boolean (copy)
		local t2 = {}
		local t3 = {}
		local u5 = true

		local function pushValue(p1) -- line: 19
			-- upvalues: t2 (copy), t3 (copy)
			if t2.length ~= 0 then
				table.remove(t2, 1)({
					done = false,
					value = p1
				})

				return
			end

			table.insert(t3, {
				done = false,
				value = p1
			})
		end
		local function pushError(p2) -- line: 30
			-- upvalues: t2 (copy), t3 (copy)
			if t2.length ~= 0 then
				table.remove(t2, 1)({
					done = false,
					value = {
						errors = { p2 }
					}
				})

				return
			end

			table.insert(t3, {
				done = false,
				value = {
					errors = { p2 }
				}
			})
		end
		local function pushDone() -- line: 41
			-- upvalues: t2 (copy), t3 (copy)
			if t2.length ~= 0 then
				table.remove(t2, 1)({
					done = true
				})

				return
			end

			table.insert(t3, {
				done = true
			})
		end
		local function pullValue() -- line: 49
			-- upvalues: t3 (copy), t2 (copy)
			return Promise.new(function(resolve) -- line: 50
				-- upvalues: t3 (copy), t2 (copy)
				if t3.length ~= 0 then
					resolve((table.remove(t3, 1)))

					return
				end

				table.insert(t2, resolve)
			end)
		end

		local v10 = t1:subscribe({
			next = function(_, p4) -- line: 60
				-- upvalues: pushValue (copy)
				pushValue(p4)
			end,
			error = function(_, p6) -- line: 63
				-- upvalues: pushError (copy)
				pushError(p6)
			end,
			complete = function(_) -- line: 66
				-- upvalues: pushDone (copy)
				pushDone()
			end
		})

		local function emptyQueue() -- line: 70
			-- upvalues: Boolean (copy), u5 (ref), v10 (copy), t2 (copy), t3 (copy)
			if Boolean.toJSBoolean(u5) then
				u5 = false
				v10:unsubscribe()

				for _, v20 in t2 do
					v20({
						value = nil,
						done = true
					})
				end

				t2.length = 0
				t3.length = 0
			end
		end

		return {
			next = function(p8) -- line: 82
				-- upvalues: Boolean (copy), u5 (ref), t3 (copy), t2 (copy)
				if Boolean.toJSBoolean(u5) then
					return (Promise.new(function(resolve) -- line: 50
						-- upvalues: t3 (copy), t2 (copy)
						if t3.length ~= 0 then
							resolve((table.remove(t3, 1)))

							return
						end

						table.insert(t2, resolve)
					end))
				end

				return (p8["return"]())
			end,
			["return"] = function(_) -- line: 86
				-- upvalues: emptyQueue (copy)
				emptyQueue()

				return Promise.resolve({
					value = nil,
					done = true
				})
			end,
			throw = function(_, p11) -- line: 90
				-- upvalues: emptyQueue (copy)
				emptyQueue()

				return Promise.reject(p11)
			end,
			[tostring(Symbol.asyncIterator)] = function(p12) -- line: 94
				return p12
			end
		}
	end
}
