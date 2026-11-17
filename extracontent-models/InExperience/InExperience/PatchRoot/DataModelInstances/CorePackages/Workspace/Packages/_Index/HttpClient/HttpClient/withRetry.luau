local parent = script:FindFirstAncestor("HttpClient").Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

require(script.Parent.types)

local _ = { maxRetryCount = 4, retryJitterMinMs = 0, retryJitterMaxMs = 4000 }

local v = { [408] = true, [503] = true, [504] = true }

local function backoffSeconds(count: number, p: number, p2: number) -- 1 equivalent call inferred from this helper
	return (p + math.random() * (p2 - p)) * math.pow(2, count - 1) / 1000
end

local function shouldRetry(data, retryOnStatuses, retryOnHttpErrors)
	if
		data.wasTransportFailure and retryOnHttpErrors == nil
		or retryOnHttpErrors ~= nil
		and data.httpError ~= nil
		and data.httpError ~= Enum.HttpError.OK
		and retryOnHttpErrors[data.httpError]
		or retryOnStatuses[data.statusCode]
	then
		return true, nil
	end

	if data.statusCode == 429 and data.headers ~= nil then
		local retryafter = tonumber(data.headers["retry-after"])

		if retryafter ~= nil and retryafter <= 16 then
			return true, retryafter
		end
	end

	return false, nil
end

local function withRetry(p, options)
	local v2 = options or {}
	local v3 = v2.maxRetryCount or 4
	local v4 = v2.retryJitterMinMs or 0
	local v5 = v2.retryJitterMaxMs or 4000
	local retryOnStatuses = v2.retryOnStatuses or v
	local retryOnHttpErrors = v2.retryOnHttpErrors
	local retryBudgetSec = v2.retryBudgetSec

	if v3 < 0 then
		mutedError(`withRetry: maxRetryCount must be >= 0, got {v3}; falling back to default`)
		v3 = 4
	end

	if v5 <= v4 then
		mutedError(`withRetry: retryJitterMinMs ({v4}) must be < retryJitterMaxMs ({v5}); falling back to default`)
		v4 = 0
		v5 = 4000
	end

	if retryBudgetSec ~= nil and retryBudgetSec <= 0 then
		mutedError(`withRetry: retryBudgetSec must be > 0, got {retryBudgetSec}; ignoring the budget`)
		retryBudgetSec = nil
	end

	return {
		request = function(p2, callback)
			local count = 0
			local lastTime = os.clock()
			local flag = false
			local flag2 = false
			local v6 = nil
			local thread = nil

			local onMessage = p2.onMessage

			local function handleMessage(p3: string)
				flag2 = true

				onMessage(p3)
			end

			local function fn()
				if flag then
					return
				end

				local v7 = p2

				if onMessage ~= nil then
					v7 = table.clone(p2)
					v7.onMessage = handleMessage
				end

				if count > 0 then
					local headers = not p2.headers and {} or table.clone(p2.headers)
					headers["X-Retry-Attempt"] = tostring(count)

					if v7 == p2 then
						v7 = table.clone(p2)
					end

					v7.headers = headers

					if v2.onRetry ~= nil then
						v2.onRetry(count)
					end
				end

				v6 = p.request(v7, function(p3, p4)
					v6 = nil

					if flag then
						return
					end

					if flag2 then
						callback(p3, p4)
						return
					end

					local v8 = nil

					if p3 then
						local v9
						v9, v8 = shouldRetry(p4, retryOnStatuses, retryOnHttpErrors)

						if not (v9 and count < v3) then
							callback(true, p4)
							return
						end
					elseif retryOnHttpErrors ~= nil or v3 <= count then
						callback(false, p4)
						return
					end

					count += 1

					if not v8 then
						v8 = backoffSeconds(count, v4, v5) -- inferred equivalent call
					end

					if retryBudgetSec ~= nil and lastTime ~= nil and retryBudgetSec <= os.clock() - lastTime + v8 then
						callback(p3, p4)
						return
					end

					thread = task.delay(v8, function()
						thread = nil
						fn()
					end)
				end)
			end

			fn()

			return function()
				if flag then
					return
				end

				flag = true

				if thread ~= nil then
					task.cancel(thread)
					thread = nil
				end

				if v6 ~= nil then
					v6()
					v6 = nil
				end
			end
		end
	}
end

return withRetry
