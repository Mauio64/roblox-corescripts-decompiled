local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signals = require(scriptParentParent.Signals)
local HttpSignals = require(scriptParentParent.HttpSignals)
local StatusCodes = require(scriptParentParent.Http).StatusCodes

require(scriptParent.HttpStoreTypes)

local createParsedResponse = require(scriptParent.createParsedResponse)
local t1 = {
	[StatusCodes.REQUEST_TIMEOUT] = true,
	[StatusCodes.SERVICE_UNAVAILABLE] = true,
	[StatusCodes.GATEWAY_TIMEOUT] = true
}

local function createHttpFetchWithRetry(p1) -- line: 31
	-- upvalues: Signals (copy), HttpSignals (copy), t1 (copy), StatusCodes (copy)
	local v11 = p1.MaxRetryCount or 4
	local v12 = p1.RetryJitterMinMs or 0
	local v13 = p1.RetryJitterMaxMs or 4000
	local u14 = nil
	local u15 = nil
	local v16, v17 = Signals.createSignal(0)
	local v18, v19 = Signals.createSignal(false)

	local function cleanupCurrentFetch() -- line: 42
		-- upvalues: u14 (ref), u15 (ref)
		if u14 ~= nil then
			task.cancel(u14)
			u14 = nil
		end

		if u15 ~= nil then
			u15()
			u15 = nil
		end
	end
	local function dispose() -- line: 53
		-- upvalues: v19 (copy), u14 (ref), u15 (ref)
		v19(true)

		if u14 ~= nil then
			task.cancel(u14)
			u14 = nil
		end

		if u15 ~= nil then
			u15()
			u15 = nil
		end
	end
	local function scheduleRetry(n1: number?) -- line: 58
		-- upvalues: u14 (ref), v16 (copy), v13 (copy), v12 (copy), v17 (copy)
		if u14 ~= nil then
			return
		end

		if n1 == nil or n1 > 16 then
			local v28 = math.pow(2, v16() + 1)
			local v29 = v13 - v12

			n1 = math.max(v28 + (v12 + math.random() * v29) / 1000, 0)
		end

		u14 = task.delay(n1, function() -- line: 72
			-- upvalues: u14 (ref), v17 (copy)
			u14 = nil
			v17(function(p2) -- line: 74
				return p2 + 1
			end)
		end)
	end

	local v23 = Signals.createComputed(function(p3) -- line: 80
		-- upvalues: v16 (copy), p1 (copy), u14 (ref), u15 (ref), HttpSignals (copy)
		local v31 = v16(p3)
		local v32 = p1

		if v31 > 0 then
			v32 = table.clone(p1)

			local v33 = if not p1.Headers then {} else table.clone(p1.Headers)

			v33["X-Retry-Attempt"] = tostring(v31)
			v32.Headers = v33
		end

		if u14 ~= nil then
			task.cancel(u14)
			u14 = nil
		end

		if u15 ~= nil then
			u15()
			u15 = nil
		end

		local v34, v35 = HttpSignals.fetch(v32)

		u15 = v35

		return v34
	end)

	return Signals.createComputed(function(p4) -- line: 98
		-- upvalues: v18 (copy), v23 (copy), v16 (copy), v11 (copy), t1 (copy), scheduleRetry (copy), StatusCodes (copy)
		if v18(p4) then
			return {
				status = "error",
				error = {
					HttpError = Enum.HttpError.Aborted
				}
			}
		end

		local v37 = v23(p4)(p4)

		if v37.status == "pending" then
			return v37
		end

		if v37.status == "success" then
			local data = v37.data
			local StatusCode = data.StatusCode

			if data.Stats and data.Stats.WasRequestRetried then
				return v37
			end

			if StatusCode >= 200 and StatusCode < 400 then
				return v37
			end

			if v16() < v11 then
				if t1[StatusCode] then
					scheduleRetry()

					return {
						status = "pending"
					}
				end

				if data.IsPrefetch and StatusCode == StatusCodes.UNAUTHORIZED then
					scheduleRetry()

					return {
						status = "pending"
					}
				end

				if StatusCode == StatusCodes.TOO_MANY_REQUESTS and data.Headers["Retry-After"] then
					local num = tonumber(data.Headers["Retry-After"])

					if num ~= nil and num <= 16 then
						scheduleRetry(num)

						return {
							status = "pending"
						}
					end
				end
			end

			return v37
		end

		if v37.status == "error" then
			if v16() < v11 then
				scheduleRetry()

				return {
					status = "pending"
				}
			end

			return v37
		end

		return v37
	end), dispose
end
local function createFetchHttpHandler(p5) -- line: 154
	-- upvalues: createHttpFetchWithRetry (copy), createParsedResponse (copy)
	if p5.MaxRetryCount ~= nil and p5.MaxRetryCount < 0 then
		error(`MaxRetryCount must be >= 0, was provided: { p5.MaxRetryCount }`)
	end

	if p5.RetryJitterMinMs ~= nil and p5.RetryJitterMaxMs ~= nil and p5.RetryJitterMinMs >= p5.RetryJitterMaxMs then
		error("RetryJitterMinMs must be smaller than RetryJitterMaxMs if both are provided")
	end

	local v25, v26 = createHttpFetchWithRetry(p5)

	return createParsedResponse(v25, p5), v26
end

return createFetchHttpHandler
