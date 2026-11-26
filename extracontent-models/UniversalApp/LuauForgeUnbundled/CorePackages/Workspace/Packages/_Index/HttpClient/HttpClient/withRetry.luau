local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/Loggers").mutedError

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

local v5 = { maxRetryCount = 4, retryJitterMinMs = 0, retryJitterMaxMs = 4000 }

local v6 = { [408] = true, [503] = true, [504] = true }

local function backoffSeconds(p2, p3, p4)
	return (p3 + math.random() * (p4 - p3)) * math.pow(2, p2 - 1) / 1000
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

local function withRetry(p2, options)
	local v7 = options or {}
	local v8 = v7.maxRetryCount or 4
	local v9 = v7.retryJitterMinMs or 0
	local v10 = v7.retryJitterMaxMs or 4000
	local retryOnStatuses = v7.retryOnStatuses or v6
	local retryOnHttpErrors = v7.retryOnHttpErrors
	local retryBudgetSec = v7.retryBudgetSec

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
		request = function(p3, callback)
			local count = 0
			local lastTime = os.clock()
			local flag = false
			local flag2 = false
			local v11 = nil
			local thread = nil

			local onMessage = p3.onMessage

			local function handleMessage(p4)
				flag2 = true

				onMessage(p4)
			end

			local function fn()
				if flag then
					return
				end

				local v12 = p3

				if onMessage ~= nil then
					v12 = table.clone(p3)
					v12.onMessage = handleMessage
				end

				if count > 0 then
					local v13 = not p3.headers and {} or table.clone(p3.headers)
					v13["X-Retry-Attempt"] = tostring(count)

					if v12 == p3 then
						v12 = table.clone(p3)
					end

					v12.headers = v13

					if v7.onRetry ~= nil then
						v7.onRetry(count)
					end
				end

				v11 = p2.request(v12, function(p4, p5)
					v11 = nil

					if flag then
						return
					end

					if flag2 then
						callback(p4, p5)
						return
					end

					local v13 = nil

					if p4 then
						local v14
						v14, v13 = shouldRetry(p5, retryOnStatuses, retryOnHttpErrors)

						if not (v14 and count < v8) then
							callback(true, p5)
							return
						end
					elseif retryOnHttpErrors ~= nil or v8 <= count then
						callback(false, p5)
						return
					end

					count += 1

					if not v13 then
						local v14 = count
						local v15 = v9
						v13 = (v15 + math.random() * (v10 - v15)) * (math.pow)(2, v14 - 1) / 1000
					end

					if
						retryBudgetSec ~= nil
						and lastTime ~= nil
						and retryBudgetSec <= os.clock() - lastTime + v13
					then
						callback(p4, p5)
						return
					end

					thread = task.delay(v13, function()
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

				if v11 ~= nil then
					v11()
					v11 = nil
				end
			end
		end
	}
end

return withRetry
