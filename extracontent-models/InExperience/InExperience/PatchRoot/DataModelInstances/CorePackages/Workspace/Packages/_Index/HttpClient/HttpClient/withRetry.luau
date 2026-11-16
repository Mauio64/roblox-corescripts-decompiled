local parent = script:FindFirstAncestor("HttpClient").Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

require(script.Parent.types)
local FFlagHttpClientRetryExtensions = require(script.Parent.Flags.FFlagHttpClientRetryExtensions)

local _ = { maxRetryCount = 4, retryJitterMinMs = 0, retryJitterMaxMs = 4000 }

local v = { [408] = true, [503] = true, [504] = true }

local function backoffSeconds(count: number, p: number, p2: number) -- 1 equivalent call inferred from this helper
	return (p + math.random() * (p2 - p)) * math.pow(2, count - 1) / 1000
end

local function shouldRetry(data, retryOnStatuses, retryOnHttpErrors)
	if FFlagHttpClientRetryExtensions then
		if
			data.wasTransportFailure and retryOnHttpErrors == nil
			or retryOnHttpErrors ~= nil
			and data.httpError ~= nil
			and data.httpError ~= Enum.HttpError.OK
			and retryOnHttpErrors[data.httpError]
		then
			return true, nil
		end
	end

	if retryOnStatuses[data.statusCode] then
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
	local retryOnHttpErrors

	if FFlagHttpClientRetryExtensions then
		retryOnHttpErrors = v2.retryOnHttpErrors
	else
		retryOnHttpErrors = nil
	end

	local retryBudgetSec

	if FFlagHttpClientRetryExtensions then
		retryBudgetSec = v2.retryBudgetSec
	else
		retryBudgetSec = nil
	end

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
		request = function(data, callback)
			local count = 0
			local lastTime

			if FFlagHttpClientRetryExtensions then
				lastTime = os.clock()
			else
				lastTime = nil
			end

			local flag = false
			local v6 = false
			local v7 = nil
			local thread = nil

			local onMessage = data.onMessage

			local function handleMessage(p2: string)
				v6 = true
				onMessage(p2)
			end

			local function fn()
				if flag then
					return
				end

				local v8 = data

				if FFlagHttpClientRetryExtensions and onMessage ~= nil then
					v8 = table.clone(data)
					v8.onMessage = handleMessage
				end

				if count > 0 then
					local headers = not data.headers and {} or table.clone(data.headers)
					headers["X-Retry-Attempt"] = tostring(count)

					if FFlagHttpClientRetryExtensions then
						if v8 == data then
							v8 = table.clone(data)
						end

						v8.headers = headers
					else
						v8 = {
							url = data.url,
							method = data.method,
							body = data.body,
							headers = headers
						}
					end

					if FFlagHttpClientRetryExtensions and v2.onRetry ~= nil then
						v2.onRetry(count)
					end
				end

				v7 = p.request(v8, function(p2, p3)
					v7 = nil

					if flag then
						return
					end

					if FFlagHttpClientRetryExtensions and v6 then
						callback(p2, p3)
						return
					end

					local v9 = nil

					if p2 then
						local v10
						v10, v9 = shouldRetry(p3, retryOnStatuses, retryOnHttpErrors)

						if not (v10 and count < v3) then
							callback(true, p3)
							return
						end
					elseif retryOnHttpErrors ~= nil or v3 <= count then
						callback(false, p3)
						return
					end

					count += 1

					if not v9 then
						v9 = backoffSeconds(count, v4, v5) -- inferred equivalent call
					end

					if
						FFlagHttpClientRetryExtensions
						and retryBudgetSec ~= nil
						and lastTime ~= nil
						and retryBudgetSec <= os.clock() - lastTime + v9
					then
						callback(p2, p3)
						return
					end

					thread = task.delay(v9, function()
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

				if v7 ~= nil then
					v7()
					v7 = nil
				end
			end
		end
	}
end

return withRetry
