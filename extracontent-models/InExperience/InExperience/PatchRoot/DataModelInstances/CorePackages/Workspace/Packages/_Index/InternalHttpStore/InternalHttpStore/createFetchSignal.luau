local parent = script.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local HttpSignals = require(parent2.HttpSignals)
local Http = require(parent2.Http)

local StatusCodes = Http.StatusCodes
require(parent.HttpStoreTypes)

local createParsedResponse = require(parent.createParsedResponse)

local MrRouterHeaders = Http.MrRouterHeaders

local set = {
	[StatusCodes.REQUEST_TIMEOUT] = true,
	[StatusCodes.SERVICE_UNAVAILABLE] = true,
	[StatusCodes.GATEWAY_TIMEOUT] = true
}

local function createHttpFetchWithRetry(data)
	local maxRetryCount = data.MaxRetryCount or 4
	local retryJitterMinMs = data.RetryJitterMinMs or 0
	local retryJitterMaxMs = data.RetryJitterMaxMs or 4000

	local thread = nil
	local v = nil

	local signal, v2 = Signals.createSignal(0)
	local signal2, v3 = Signals.createSignal(false)

	local function cleanupCurrentFetch() -- 2 equivalent calls inferred from this helper
		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end

		if v ~= nil then
			v()
			v = nil
		end
	end

	local function dispose()
		v3(true)
		cleanupCurrentFetch() -- inferred equivalent call
	end

	local function scheduleRetry(duration: number?)
		if thread ~= nil then
			return
		end

		if duration == nil or duration > 16 then
			local v4 = math.pow(2, signal() + 1)
			local v5 = retryJitterMaxMs - retryJitterMinMs
			duration = math.max(v4 + (retryJitterMinMs + math.random() * v5) / 1000, 0)
		end

		thread = task.delay(duration, function()
			thread = nil
			v2(function(p)
				return p + 1
			end)
		end)
	end

	local computed = Signals.createComputed(function(p)
		local v4 = signal(p)

		local v5 = data

		if v4 > 0 then
			v5 = table.clone(data)
			local headers = not data.Headers and {} or table.clone(data.Headers)
			headers["X-Retry-Attempt"] = tostring(v4)
			v5.Headers = headers
		end

		cleanupCurrentFetch() -- inferred equivalent call
		local fetched, v6 = HttpSignals.fetch(v5)
		v = v6
		return fetched
	end)

	return Signals.createComputed(function(p)
		if signal2(p) then
			return {
				status = "error",
				error = { HttpError = Enum.HttpError.Aborted }
			}
		end

		local v4 = computed(p)(p)

		if v4.status == "pending" then
			return v4
		end

		if v4.status == "success" then
			local data2 = v4.data
			local statusCode = data2.StatusCode

			if
				data2.Stats and data2.Stats.WasRequestRetried
				or statusCode >= 200 and statusCode < 400
				or not (signal() < maxRetryCount)
			then
				return v4
			end

			if set[statusCode] then
				scheduleRetry()
				return { status = "pending" }
			end

			if data2.IsPrefetch and statusCode == StatusCodes.UNAUTHORIZED then
				scheduleRetry()
				return { status = "pending" }
			end

			if not (statusCode == StatusCodes.TOO_MANY_REQUESTS and data2.Headers["Retry-After"]) then
				return v4
			end

			local retryAfter = tonumber(data2.Headers["Retry-After"])

			if retryAfter ~= nil and retryAfter <= 16 then
				scheduleRetry(retryAfter)
				return { status = "pending" }
			end

			return v4
		end

		if v4.status ~= "error" then
			return v4
		end

		if signal() < maxRetryCount then
			scheduleRetry()
			return { status = "pending" }
		end

		return v4
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

	local injectMrRouterHeaders = MrRouterHeaders.injectMrRouterHeaders(state.Headers)

	if injectMrRouterHeaders ~= state.Headers then
		state = table.clone(state)
		state.Headers = injectMrRouterHeaders
	end

	local httpFetchWithRetry, v = createHttpFetchWithRetry(state)

	return createParsedResponse(httpFetchWithRetry, state), v
end

return createFetchHttpHandler
