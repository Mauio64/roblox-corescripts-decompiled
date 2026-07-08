local Parent = script:FindFirstAncestor("HttpClient").Parent
local mutedError = require(Parent.Loggers).mutedError

require(script.Parent.types)

local t1 = {
	maxRetryCount = 4,
	retryJitterMinMs = 0,
	retryJitterMaxMs = 4000
}
local t2 = {
	[408] = true,
	[503] = true,
	[504] = true
}

local function backoffSeconds(n1: number, n2: number, n3: number) -- line: 16
	return (n2 + math.random() * (n3 - n2)) * math.pow(2, n1 - 1) / 1000
end
local function shouldRetry(p1, t3: {[any]: any}) -- line: 20
	if t3[p1.statusCode] then
		return true, nil
	end

	if p1.statusCode == 429 and p1.headers ~= nil then
		local num = tonumber(p1.headers["retry-after"])

		if num ~= nil and num <= 16 then
			return true, num
		end
	end

	return false, nil
end
local function withRetry(p2, p3) -- line: 33
	-- upvalues: t1 (copy), t2 (copy), mutedError (copy)
	local v16 = p3 or {}
	local u17 = v16.maxRetryCount or t1.maxRetryCount
	local u18 = v16.retryJitterMinMs or t1.retryJitterMinMs
	local u19 = v16.retryJitterMaxMs or t1.retryJitterMaxMs
	local v20 = v16.retryOnStatuses or t2

	if u17 < 0 then
		mutedError(`withRetry: maxRetryCount must be >= 0, got { u17 }; falling back to default`)
		u17 = t1.maxRetryCount
	end

	if u19 <= u18 then
		mutedError(`withRetry: retryJitterMinMs ({ u18 }) must be < retryJitterMaxMs ({ u19 }); falling back to default`)
		u18 = t1.retryJitterMinMs
		u19 = t1.retryJitterMaxMs
	end

	return {
		request = function(p4, p5: ((...any) -> ...any)) -- line: 53
			-- upvalues: p2 (copy), v20 (copy), u17 (ref), u18 (ref), u19 (ref)
			local n4 = 0
			local u24 = false
			local u25 = nil
			local u26 = nil

			local function u27() -- line: 63
				-- upvalues: u24 (ref), p4 (copy), n4 (ref), u25 (ref), p2 (copy), v20 (copy), u17 (ref), p5 (copy), u26 (ref), u18 (ref), u19 (ref), u27 (ref)
				if u24 then
					return
				end

				local v28 = p4

				if n4 > 0 then
					local v29 = if not p4.headers then {} else table.clone(p4.headers)

					v29["X-Retry-Attempt"] = tostring(n4)
					v28 = {
						url = p4.url,
						method = p4.method,
						body = p4.body,
						headers = v29
					}
				end

				u25 = p2.request(v28, function(p6, p7) -- line: 74
					-- upvalues: u25 (ref), u24 (ref), v20 (copy), n4 (ref), u17 (ref), p5 (copy), u26 (ref), u18 (ref), u19 (ref), u27 (ref)
					u25 = nil

					if u24 then
						return
					end

					local v32 = nil
					local g33 = nil
					local g35 = nil
					local v34 = nil

					if not p6 then
						if n4 >= u17 then
							p5(false, p7)

							return
						end

						g33 = true
					end

					if not g33 then
						if v20[p7.statusCode] then
							v34 = true
							v32 = nil
							g35 = true
						end
					end

					repeat
						if g33 or (g35 or (g35 or p7.statusCode == 429 and p7.headers ~= nil)) then
							if not g33 then
								if not g35 then
									if not g35 then
										v32 = tonumber(p7.headers["retry-after"])
									end
								end
							end

							if g33 or (g35 or (g35 or v32 ~= nil and v32 <= 16)) then
								if not g33 then
									if not g35 then
										if not g35 then
											v34 = true
										end
									end

									g35 = false

									if not v34 or not (n4 < u17) then
										p5(true, p7)

										return
									end
								end

								g33 = false
								n4 += 1

								local delay = task.delay

								if not v32 then
									local v37 = n4
									local v38 = u18
									local v39 = u19

									v32 = (v38 + math.random() * (v39 - v38)) * math.pow(2, v37 - 1) / 1000
								end

								u26 = delay(v32, function() -- line: 95
									-- upvalues: u26 (ref), u27 (ref)
									u26 = nil
									u27()
								end)

								return
							end
						end

						v34 = false
						v32 = nil
						g35 = true
					until not g35
				end)
			end

			u27()

			return function() -- line: 104
				-- upvalues: u24 (ref), u26 (ref), u25 (ref)
				if u24 then
					return
				end

				u24 = true

				if u26 ~= nil then
					task.cancel(u26)
					u26 = nil
				end

				if u25 ~= nil then
					u25()
					u25 = nil
				end
			end
		end
	}
end

return withRetry
