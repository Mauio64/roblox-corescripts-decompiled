local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hdC")
require("@luauforge/deferred/hdt")

local v5 = {}

local function usePollUntilTerminal()
	local ref = module.useRef(false)
	module.useEffect(function()
		return function()
			ref.current = true
		end
	end, {})

	return (module.useCallback(function(callback, callback2, data)
		return module2.new(function(callback3, callback4)
			local v6 = os.time() + data.timeoutSeconds

			local fn
			local function failInternal(p2)
				if not ref.current then
					callback4({ kind = "internal", error = p2 })
				end
			end

			local function reschedule(p2)
				module2.delay(data.intervalSeconds):andThen(function()
					fn(p2)
				end):catch(failInternal)
			end

			fn = function(p2)
				if ref.current then
					return
				end

				local success, result = pcall(function()
					local v7 = math.max(0, v6 - os.time())
					local v8 = module2.delay(v7):andThen(function()
						return module2.reject(v5)
					end)

					return module2.race({ callback(), v8 })
				end)

				if success then
					result:andThen(function(p3)
						if ref.current then
							return
						end

						if callback2(p3) then
							callback3(p3)
							return
						end

						if v6 <= os.time() then
							callback4({ kind = "timeout" })
							return
						end

						local v7 = 0
						module2.delay(data.intervalSeconds):andThen(function()
							fn(v7)
						end):catch(failInternal)
					end):catch(function(p3)
						if ref.current then
							return
						end

						if p3 == v5 then
							callback4({ kind = "timeout" })
							return
						end

						local v7 = p2 + 1

						if data.maxConsecutiveFailures <= v7 then
							callback4({ kind = "error", error = p3 })
						elseif v6 <= os.time() then
							callback4({ kind = "timeout" })
						else
							module2.delay(data.intervalSeconds):andThen(function()
								fn(v7)
							end):catch(failInternal)
						end
					end)
				elseif not ref.current then
					callback4({ kind = "internal", error = result })
				end
			end

			fn(0)
		end)
	end, {}))
end

return usePollUntilTerminal
