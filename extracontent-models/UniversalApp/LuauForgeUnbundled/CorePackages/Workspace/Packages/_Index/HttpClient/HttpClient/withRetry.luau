local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/Loggers").mutedError

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local FFlagHttpClientRetryExtensions = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/Flags/FFlagHttpClientRetryExtensions")

local v5 = { maxRetryCount = 4, retryJitterMinMs = 0, retryJitterMaxMs = 4000 }

local v6 = { [408] = true, [503] = true, [504] = true }

local function backoffSeconds(p2, p3, p4)
	return (p3 + math.random() * (p4 - p3)) * math.pow(2, p2 - 1) / 1000
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

local function withRetry(p2, options)
	local v7 = options or {}
	local v8 = v7.maxRetryCount or 4
	local v9 = v7.retryJitterMinMs or 0
	local v10 = v7.retryJitterMaxMs or 4000
	local retryOnStatuses = v7.retryOnStatuses or v6
	local retryOnHttpErrors = if FFlagHttpClientRetryExtensions then v7.retryOnHttpErrors else nil
	local retryBudgetSec = if FFlagHttpClientRetryExtensions then v7.retryBudgetSec else nil

	if v8 < 0 then
		mutedError(`withRetry: maxRetryCount must be >= 0, got {v8}; falling back to default`)
		v8 = 4
	end

	if v10 <= v9 then
		mutedError(`withRetry: retryJitterMinMs ({v9}) must be < retryJitterMaxMs ({v10}); falling back to default`)
		v9 = 0
		v10 = 4000
	end

	if retryBudgetSec ~= nil and retryBudgetSec <= 0 then
		mutedError(`withRetry: retryBudgetSec must be > 0, got {retryBudgetSec}; ignoring the budget`)
		retryBudgetSec = nil
	end

	return {
		request = function(data, callback)
			local count = 0
			local lastTime = if FFlagHttpClientRetryExtensions then os.clock() else nil
			local flag = false
			local v11 = false
			local v12 = nil
			local thread = nil

			local onMessage = data.onMessage

			local function handleMessage(p3)
				v11 = true
				onMessage(p3)
			end

			local function fn()
				if flag then
					return
				end

				local v13 = data

				if FFlagHttpClientRetryExtensions and onMessage ~= nil then
					v13 = table.clone(data)
					v13.onMessage = handleMessage
				end

				if count > 0 then
					local v14 = not data.headers and {} or table.clone(data.headers)
					v14["X-Retry-Attempt"] = tostring(count)

					if FFlagHttpClientRetryExtensions then
						if v13 == data then
							v13 = table.clone(data)
						end

						v13.headers = v14
					else
						v13 = {
							url = data.url,
							method = data.method,
							body = data.body,
							headers = v14
						}
					end

					if FFlagHttpClientRetryExtensions and v7.onRetry ~= nil then
						v7.onRetry(count)
					end
				end

				v12 = p2.request(v13, function(p3, p4)
					v12 = nil

					if flag then
						return
					end

					if FFlagHttpClientRetryExtensions and v11 then
						callback(p3, p4)
						return
					end

					local v14 = nil

					if p3 then
						local v15
						v15, v14 = shouldRetry(p4, retryOnStatuses, retryOnHttpErrors)

						if not (v15 and count < v8) then
							callback(true, p4)
							return
						end
					elseif retryOnHttpErrors ~= nil or v8 <= count then
						callback(false, p4)
						return
					end

					count += 1

					if not v14 then
						local v15 = count
						local v16 = v9
						v14 = (v16 + math.random() * (v10 - v16)) * (math.pow)(2, v15 - 1) / 1000
					end

					if
						FFlagHttpClientRetryExtensions
						and retryBudgetSec ~= nil
						and lastTime ~= nil
						and retryBudgetSec <= os.clock() - lastTime + v14
					then
						callback(p3, p4)
						return
					end

					thread = task.delay(v14, function()
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

				if v12 ~= nil then
					v12()
					v12 = nil
				end
			end
		end
	}
end

return withRetry
