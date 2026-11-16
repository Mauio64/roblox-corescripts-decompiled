local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
local HttpSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/HttpSignals")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Http")

local statusCodes = Http.StatusCodes
require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local createParsedResponse = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/createParsedResponse")

local mrRouterHeaders = Http.MrRouterHeaders

local set = {
	[statusCodes.REQUEST_TIMEOUT] = true,
	[statusCodes.SERVICE_UNAVAILABLE] = true,
	[statusCodes.GATEWAY_TIMEOUT] = true
}

local function createHttpFetchWithRetry(data)
	local maxRetryCount = data.MaxRetryCount or 4
	local retryJitterMinMs = data.RetryJitterMinMs or 0
	local retryJitterMaxMs = data.RetryJitterMaxMs or 4000

	local thread = nil
	local v5 = nil

	local signal, v6 = Signals.createSignal(0)
	local signal2, v7 = Signals.createSignal(false)

	local function cleanupCurrentFetch()
		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end

		if v5 ~= nil then
			v5()
			v5 = nil
		end
	end

	local function dispose()
		v7(true)

		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end

		if v5 ~= nil then
			v5()
			v5 = nil
		end
	end

	local function scheduleRetry(duration)
		if thread ~= nil then
			return
		end

		if duration == nil or duration > 16 then
			local v8 = math.pow(2, signal() + 1)
			local v9 = retryJitterMaxMs - retryJitterMinMs
			duration = math.max(v8 + (retryJitterMinMs + math.random() * v9) / 1000, 0)
		end

		thread = task.delay(duration, function()
			thread = nil
			v6(function(p2)
				return p2 + 1
			end)
		end)
	end

	local computed = Signals.createComputed(function(p2)
		local v8 = signal(p2)

		local v9 = data

		if v8 > 0 then
			v9 = table.clone(data)
			local v10 = not data.Headers and {} or table.clone(data.Headers)
			v10["X-Retry-Attempt"] = tostring(v8)
			v9.Headers = v10
		end

		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end

		if v5 ~= nil then
			v5()
			v5 = nil
		end

		local fetched, v10 = HttpSignals.fetch(v9)
		v5 = v10
		return fetched
	end)

	return Signals.createComputed(function(p2)
		if signal2(p2) then
			return {
				status = "error",
				error = { HttpError = Enum.HttpError.Aborted }
			}
		end

		local v8 = computed(p2)(p2)

		if v8.status == "pending" then
			return v8
		end

		if v8.status == "success" then
			local data2 = v8.data
			local statusCode = data2.StatusCode

			if
				data2.Stats and data2.Stats.WasRequestRetried
				or statusCode >= 200 and statusCode < 400
				or not (signal() < maxRetryCount)
			then
				return v8
			end

			if set[statusCode] then
				scheduleRetry()
				return { status = "pending" }
			end

			if data2.IsPrefetch and statusCode == statusCodes.UNAUTHORIZED then
				scheduleRetry()
				return { status = "pending" }
			end

			if not (statusCode == statusCodes.TOO_MANY_REQUESTS and data2.Headers["Retry-After"]) then
				return v8
			end

			local retryAfter = tonumber(data2.Headers["Retry-After"])

			if retryAfter ~= nil and retryAfter <= 16 then
				scheduleRetry(retryAfter)
				return { status = "pending" }
			end

			return v8
		end

		if v8.status ~= "error" then
			return v8
		end

		if signal() < maxRetryCount then
			scheduleRetry()
			return { status = "pending" }
		end

		return v8
	end), dispose
end

local function createFetchHttpHandler(state)
	if state.MaxRetryCount ~= nil and state.MaxRetryCount < 0 then
		error(`MaxRetryCount must be >= 0, was provided: {state.MaxRetryCount}`)
	end

	if
		state.RetryJitterMinMs ~= nil
		and state.RetryJitterMaxMs ~= nil
		and state.RetryJitterMinMs >= state.RetryJitterMaxMs
	then
		error("RetryJitterMinMs must be smaller than RetryJitterMaxMs if both are provided")
	end

	local injectMrRouterHeaders = mrRouterHeaders.injectMrRouterHeaders(state.Headers)

	if injectMrRouterHeaders ~= state.Headers then
		state = table.clone(state)
		state.Headers = injectMrRouterHeaders
	end

	local httpFetchWithRetry, v5 = createHttpFetchWithRetry(state)

	return createParsedResponse(httpFetchWithRetry, state), v5
end

return createFetchHttpHandler
