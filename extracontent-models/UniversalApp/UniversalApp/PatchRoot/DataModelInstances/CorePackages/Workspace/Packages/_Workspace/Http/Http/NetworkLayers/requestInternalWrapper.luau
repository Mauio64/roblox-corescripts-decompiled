local HttpService = game:GetService("HttpService")
local Http = script:FindFirstAncestor("Http")
local HttpParent = Http.Parent
local Promise = require(HttpParent.Promise)
local NetworkProfiler = require(Http.NetworkProfiler)

require(Http.RequestTypes)

local StatusCodes = require(Http.StatusCodes)
local HttpCanceller = require(Http.NetworkLayers.HttpCanceller)
local GreenlistedEndpointsForLogging = require(Http.Logger.GreenlistedEndpointsForLogging)
local v9 = game:DefineFastFlag("LuaAppHttpSupportNoContent", false)
local v10 = game:DefineFastFlag("EnableRetryOnPrefetch401", false)
local v11 = game:DefineFastString("MrRouterEnvName", "")
local None = Enum.HttpCachePolicy.None
local t1 = {
	[StatusCodes.REQUEST_TIMEOUT] = true,
	[StatusCodes.SERVICE_UNAVAILABLE] = true,
	[StatusCodes.GATEWAY_TIMEOUT] = true
}
local t2 = {}

t2.__index = t2

local function generateTraceparent() -- line: 41
	-- upvalues: HttpService (copy)
	local v19 = HttpService:GenerateGUID(false):gsub("-", ""):lower()
	local v20 = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 16):lower()

	return string.format("00-%s-%s-01", v19, v20)
end
local function mergeMrRouterInTracestate(p1, p2) -- line: 47
	local v23 = "mrrouter-env=" .. p2
	local t3 = {}

	if p1 and #p1 > 0 then
		for match in p1:gmatch(" *([^,]+)") do
			table.insert(t3, match)
		end
	end

	local function isMrRouterEntry(p3) -- line: 57
		return p3:sub(1, 13) == "mrrouter-env="
	end

	local v27 = nil

	for i, v in ipairs(t3) do
		if v:sub(1, 13) == "mrrouter-env=" then
			v27 = i

			break
		end
	end

	if v27 == nil then
		table.insert(t3, v23)

		return table.concat(t3, ",")
	end

	local t4 = {}

	for _, v in ipairs(t3) do
		if v:sub(1, 13) ~= "mrrouter-env=" then
			table.insert(t4, v)
		end
	end

	table.insert(t4, v27, v23)

	return table.concat(t4, ",")
end
local function parseResponseBody(p4) -- line: 84
	-- upvalues: StatusCodes (copy), HttpService (copy)
	if p4.StatusCode == StatusCodes.NO_CONTENT then
		return true, nil
	end

	local ok, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

	return ok, result
end

function t2.new(p5, s1: string, s2: string, p6) -- line: 93
	-- upvalues: HttpCanceller (copy), None (copy), v11 (copy), generateTraceparent (copy), mergeMrRouterInTracestate (copy), t2 (copy)
	local t5 = {
		resolve = nil,
		reject = nil,
		retryCount = 0,
		httpRequest = nil,
		canceled = false,
		maxRetryCount = p6 and p6.maxRetryCount or 4,
		httpService = p5,
		session = HttpCanceller.currentSession(),
		internalOptions = {
			Url = s1,
			Method = s2 and s2 or "GET",
			Body = p6 and p6.postBody or nil,
			Timeout = p6 and p6.timeout or 15000,
			CachePolicy = p6 and p6.cachePolicy or None,
			Priority = p6 and p6.priority or 0,
			Headers = p6 and p6.headers or nil,
			RequestType = p6 and p6.requestType or nil
		}
	}

	if (s2 == "POST" or s2 == "PATCH") and (t5.internalOptions.Headers == nil or t5.internalOptions.Headers["Content-Type"] == nil) then
		t5.internalOptions.Headers = t5.internalOptions.Headers or {}
		t5.internalOptions.Headers["Content-Type"] = "application/json"
	end

	if #v11 > 0 then
		t5.internalOptions.Headers = t5.internalOptions.Headers or {}

		local Headers = t5.internalOptions.Headers

		if not Headers.Traceparent then
			Headers.Traceparent = generateTraceparent()
		end

		Headers.Tracestate = mergeMrRouterInTracestate(Headers.Tracestate, v11)
	end

	setmetatable(t5, t2)

	return t5
end
function t2.start(p7, p8, p9) -- line: 136
	p7.resolve = p8
	p7.reject = p9
	p7:makeRequest()
end
function t2.processResponse(p10, p11) -- line: 142
	-- upvalues: v9 (copy), StatusCodes (copy), HttpService (copy), NetworkProfiler (copy), GreenlistedEndpointsForLogging (copy)
	local v47, v48

	if v9 then
		if p11.StatusCode == StatusCodes.NO_CONTENT then
			v47 = true
			v48 = nil
		else
			v47, v48 = pcall(HttpService.JSONDecode, HttpService, p11.Body)
		end
	else
		v47, v48 = pcall(HttpService.JSONDecode, HttpService, p11.Body)
	end

	if not v47 then
		p10.reject({
			isJSONValid = false,
			HttpError = Enum.HttpError.OK
		})

		return
	end

	NetworkProfiler:track({
		queued = p11.Stats.DurationInQueue,
		nameLookup = p11.Stats.DurationNameLookup,
		connect = p11.Stats.DurationConnect,
		sslHandshake = p11.Stats.DurationSSLHandshake,
		makeRequest = p11.Stats.DurationMakeRequest,
		receiveResponse = p11.Stats.DurationReceiveResponse
	})

	local v49 = p11.Stats.RoundTripTime * 1000
	local v50 = (not p11.Body or typeof(p11.Body) ~= "string") and 0 or #p11.Body
	local t6 = {
		responseCode = p11.StatusCode,
		requestUrl = p10.internalOptions.Url,
		responseTimeMs = v49,
		isJSONValid = true,
		v48,
		responseBody = v48,
		responseStats = p11.Stats,
		responseSize = v50
	}

	p10.resolve(t6)
	GreenlistedEndpointsForLogging.sendStatusCodeCounter(p10.internalOptions.Url, p11.StatusCode)
end
function t2.retry(p12, p13, p14) -- line: 179
	local v55 = true

	if p13.Stats and p13.Stats.WasRequestRetried then
		v55 = false
	end

	if v55 then
		p12.retryCount = p12.retryCount + 1

		if p12.retryCount > p12.maxRetryCount then
			v55 = false
		end
	end

	if not v55 then
		p12.reject(p13)

		return
	end

	if p12.internalOptions.Headers == nil then
		p12.internalOptions.Headers = {}
	end

	p12.internalOptions.Headers["X-Retry-Attempt"] = tostring(p12.retryCount)

	local v56 = p14 or math.pow(2, p12.retryCount)

	delay(v56, function() -- line: 205
		-- upvalues: p12 (copy)
		p12:makeRequest()
	end)
end
function t2.makeRequest(p15) -- line: 210
	-- upvalues: HttpCanceller (copy), t1 (copy), v10 (copy), StatusCodes (copy), GreenlistedEndpointsForLogging (copy)
	if p15.canceled then
		return
	end

	p15.httpRequest = p15.httpService:RequestInternal(p15.internalOptions)
	p15.httpRequest:Start(function(p16, p17) -- line: 217
		-- upvalues: p15 (copy), HttpCanceller (copy), t1 (copy), v10 (copy), StatusCodes (copy), GreenlistedEndpointsForLogging (copy)
		if p15.session ~= HttpCanceller.currentSession() then
			warn("Http request aborted", p15.internalOptions.Url)

			return
		end

		if p16 then
			if p17.StatusCode >= 200 and p17.StatusCode < 400 then
				p15:processResponse(p17)

				return
			end

			if t1[p17.StatusCode] then
				p15:retry(p17)

				return
			end

			if v10 and p17.IsPrefetch and p17.StatusCode == StatusCodes.UNAUTHORIZED then
				p15:retry(p17)

				return
			end

			if p17.StatusCode == StatusCodes.TOO_MANY_REQUESTS and p17.Headers["Retry-After"] then
				local num = tonumber(p17.Headers["Retry-After"])

				if num ~= nil and num <= 16 then
					p15:retry(p17, num)

					return
				end

				GreenlistedEndpointsForLogging.sendStatusCodeCounter(p15.internalOptions.Url, p17.StatusCode)
				p15.reject(p17)

				return
			end

			GreenlistedEndpointsForLogging.sendStatusCodeCounter(p15.internalOptions.Url, p17.StatusCode)
			p15.reject(p17)

			return
		end

		if not p15.canceled then
			p15:retry({
				HttpError = p17.HttpError
			})
		end
	end)
end
function t2.cancel(p18) -- line: 257
	p18.canceled = true
	p18.reject({
		HttpError = Enum.HttpError.Aborted
	})

	if p18.httpRequest then
		p18.httpRequest:Cancel()
	end
end

local function createRequestInternalWrapper(p19) -- line: 265
	-- upvalues: HttpService (copy), t2 (copy), Promise (copy)
	local u60 = p19 or HttpService

	local function makeRequest(s3: string, s4: string, p20) -- line: 270
		-- upvalues: t2 (copy), u60 (ref), Promise (copy)
		local v72 = t2.new(u60, s3, s4, p20)

		local function cancel() -- line: 277
			-- upvalues: v72 (copy)
			v72:cancel()
		end

		return Promise.new(function(resolve, reject) -- line: 273
			-- upvalues: v72 (copy)
			v72:start(resolve, reject)
		end), cancel
	end

	return makeRequest
end

return (setmetatable({
	_mergeMrRouterInTracestate = mergeMrRouterInTracestate,
	_generateTraceparent = generateTraceparent
}, {
	__call = function(_, ...) -- line: 291
		-- upvalues: HttpService (copy), t2 (copy), Promise (copy)
		local u63 = ... or HttpService

		local function makeRequest(s5: string, s6: string, p22) -- line: 270
			-- upvalues: t2 (copy), u63 (ref), Promise (copy)
			local v77 = t2.new(u63, s5, s6, p22)

			local function cancel() -- line: 277
				-- upvalues: v77 (copy)
				v77:cancel()
			end

			return Promise.new(function(resolve, reject) -- line: 273
				-- upvalues: v77 (copy)
				v77:start(resolve, reject)
			end), cancel
		end

		return makeRequest
	end
}))
