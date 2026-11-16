local HttpService = game:GetService("HttpService")
local Http = script:FindFirstAncestor("Http")
local parent = Http.Parent

local Promise = require(parent.Promise)
local NetworkProfiler = require(Http.NetworkProfiler)
require(Http.RequestTypes)
local StatusCodes = require(Http.StatusCodes)
local HttpCanceller = require(Http.NetworkLayers.HttpCanceller)

local GreenlistedEndpointsForLogging = require(Http.Logger.GreenlistedEndpointsForLogging)
local MrRouterHeaders = require(parent.MrRouterHeaders)

local defineFastFlag = game:DefineFastFlag("LuaAppHttpSupportNoContent", false)
local defineFastFlag2 = game:DefineFastFlag("EnableRetryOnPrefetch401", false)

local None = Enum.HttpCachePolicy.None

local set = {
	[StatusCodes.REQUEST_TIMEOUT] = true,
	[StatusCodes.SERVICE_UNAVAILABLE] = true,
	[StatusCodes.GATEWAY_TIMEOUT] = true
}

local class = {}
class.__index = class

local function parseResponseBody(p)
	if p.StatusCode == StatusCodes.NO_CONTENT then
		return true, nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)
	return success, result
end

function class.new(httpService, url: string, p: string, data)
	local v = {
		resolve = nil,
		reject = nil,
		retryCount = 0,
		maxRetryCount = data and data.maxRetryCount or 4,
		httpRequest = nil,
		canceled = false,
		httpService = httpService,
		session = HttpCanceller.currentSession()
	}

	local internalOptions = {
		Url = url,
		Method = p and p or "GET",
		Body = 0,
		Timeout = 0,
		CachePolicy = 0,
		Priority = 0,
		Headers = 0,
		RequestType = 0
	}
	local body

	if data then
		body = data.postBody or nil
	end

	internalOptions.Body = body
	internalOptions.Timeout = data and data.timeout or 15000
	internalOptions.CachePolicy = data and data.cachePolicy or None
	internalOptions.Priority = data and data.priority or 0
	local headers

	if data then
		headers = data.headers or nil
	end

	internalOptions.Headers = headers
	internalOptions.RequestType = data and data.requestType or nil
	v.internalOptions = internalOptions

	if
		(p == "POST" or p == "PATCH")
		and (v.internalOptions.Headers == nil or v.internalOptions.Headers["Content-Type"] == nil)
	then
		v.internalOptions.Headers = v.internalOptions.Headers or {}
		v.internalOptions.Headers["Content-Type"] = "application/json"
	end

	v.internalOptions.Headers = MrRouterHeaders.injectMrRouterHeaders(v.internalOptions.Headers)

	setmetatable(v, class)
	return v
end

function class:start(resolve, reject)
	self.resolve = resolve
	self.reject = reject
	self:makeRequest()
end

function class:processResponse(data)
	local success, result

	if defineFastFlag then
		if data.StatusCode == StatusCodes.NO_CONTENT then
			success = true
		else
			success, result = pcall(HttpService.JSONDecode, HttpService, data.Body)
		end
	else
		success, result = pcall(HttpService.JSONDecode, HttpService, data.Body)
	end

	if not success then
		self.reject({ HttpError = Enum.HttpError.OK, isJSONValid = false })
		return
	end

	NetworkProfiler:track({
		queued = data.Stats.DurationInQueue,
		nameLookup = data.Stats.DurationNameLookup,
		connect = data.Stats.DurationConnect,
		sslHandshake = data.Stats.DurationSSLHandshake,
		makeRequest = data.Stats.DurationMakeRequest,
		receiveResponse = data.Stats.DurationReceiveResponse
	})

	local responseTimeMs = data.Stats.RoundTripTime * 1000
	local responseSize = data.Body and typeof(data.Body) == "string" and #data.Body or 0

	local v = {
		responseCode = data.StatusCode,
		requestUrl = self.internalOptions.Url,
		responseTimeMs = responseTimeMs,
		isJSONValid = true,
		result,
		responseBody = result,
		responseStats = data.Stats,
		responseSize = responseSize
	}

	self.resolve(v)
	GreenlistedEndpointsForLogging.sendStatusCodeCounter(self.internalOptions.Url, data.StatusCode)
end

function class:retry(p, p2)
	local v = not (p.Stats and p.Stats.WasRequestRetried)

	if v then
		self.retryCount += 1

		if self.retryCount > self.maxRetryCount then
			v = false
		end
	end

	if not v then
		self.reject(p)
		return
	end

	if self.internalOptions.Headers == nil then
		self.internalOptions.Headers = {}
	end

	self.internalOptions.Headers["X-Retry-Attempt"] = tostring(self.retryCount)

	local v2 = p2 or math.pow(2, self.retryCount)

	delay(v2, function()
		self:makeRequest()
	end)
end

function class:makeRequest()
	if self.canceled then
		return
	end

	self.httpRequest = self.httpService:RequestInternal(self.internalOptions)

	self.httpRequest:Start(function(p, data)
		if self.session ~= HttpCanceller.currentSession() then
			warn("Http request aborted", self.internalOptions.Url)
		elseif p then
			if data.StatusCode >= 200 and data.StatusCode < 400 then
				self:processResponse(data)
			elseif set[data.StatusCode] then
				self:retry(data)
			elseif defineFastFlag2 and data.IsPrefetch and data.StatusCode == StatusCodes.UNAUTHORIZED then
				self:retry(data)
			elseif data.StatusCode == StatusCodes.TOO_MANY_REQUESTS and data.Headers["Retry-After"] then
				local retryAfter = tonumber(data.Headers["Retry-After"])

				if retryAfter ~= nil and retryAfter <= 16 then
					self:retry(data, retryAfter)
					return
				end

				GreenlistedEndpointsForLogging.sendStatusCodeCounter(self.internalOptions.Url, data.StatusCode)
				self.reject(data)
			else
				GreenlistedEndpointsForLogging.sendStatusCodeCounter(self.internalOptions.Url, data.StatusCode)

				self.reject(data)
			end
		elseif not self.canceled then
			self:retry({ HttpError = data.HttpError })
		end
	end)
end

function class:cancel()
	self.canceled = true
	self.reject({ HttpError = Enum.HttpError.Aborted })

	if self.httpRequest then
		self.httpRequest:Cancel()
	end
end

local function createRequestInternalWrapper(p)
	local v = p or HttpService

	local function makeRequest(p2: string, p3: string, p4)
		local v2 = class.new(v, p2, p3, p4)

		local function cancel()
			v2:cancel()
		end

		return Promise.new(function(p5, p6)
			v2:start(p5, p6)
		end), cancel
	end

	return makeRequest
end

return createRequestInternalWrapper
