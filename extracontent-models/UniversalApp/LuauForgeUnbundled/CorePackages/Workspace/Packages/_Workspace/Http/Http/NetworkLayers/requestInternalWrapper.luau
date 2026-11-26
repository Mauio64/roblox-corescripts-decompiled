local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Promise")
local NetworkProfiler = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/NetworkProfiler")
local FFlagDisableLegacyReportToDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/SharedFlags/FFlagDisableLegacyReportToDiag")
require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/RequestTypes")
local StatusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/StatusCodes")
local HttpCanceller = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/NetworkLayers/HttpCanceller")

local GreenlistedEndpointsForLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Logger/GreenlistedEndpointsForLogging")
local MrRouterHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/MrRouterHeaders")

local defineFastFlag = game:DefineFastFlag("LuaAppHttpSupportNoContent", false)
local defineFastFlag2 = game:DefineFastFlag("EnableRetryOnPrefetch401", false)

local none = Enum.HttpCachePolicy.None

local set = {
	[StatusCodes.REQUEST_TIMEOUT] = true,
	[StatusCodes.SERVICE_UNAVAILABLE] = true,
	[StatusCodes.GATEWAY_TIMEOUT] = true
}

local class = {}
class.__index = class

local function parseResponseBody(p2)
	if p2.StatusCode == StatusCodes.NO_CONTENT then
		return true, nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, p2.Body)
	return success, result
end

function class.new(p2, p3, p4, data)
	local v5 = {
		resolve = nil,
		reject = nil,
		retryCount = 0,
		maxRetryCount = data and data.maxRetryCount or 4,
		httpRequest = nil,
		canceled = false,
		httpService = p2,
		session = HttpCanceller.currentSession()
	}

	local v7 = if data then data.postBody or nil else nil
	local v6 = {
		Url = p3,
		Method = p4 and p4 or "GET",
		Body = v7,
		Timeout = data and data.timeout or 15000,
		CachePolicy = data and data.cachePolicy or none,
		Priority = data and data.priority or 0,
		Headers = 0,
		RequestType = 0
	}
	local v8 = if data then data.headers or nil else nil
	v6.Headers = v8
	v6.RequestType = data and data.requestType or nil
	v5.internalOptions = v6

	if
		(p4 == "POST" or p4 == "PATCH")
		and (v5.internalOptions.Headers == nil or v5.internalOptions.Headers["Content-Type"] == nil)
	then
		v5.internalOptions.Headers = v5.internalOptions.Headers or {}
		v5.internalOptions.Headers["Content-Type"] = "application/json"
	end

	v5.internalOptions.Headers = MrRouterHeaders.injectMrRouterHeaders(v5.internalOptions.Headers)

	setmetatable(v5, class)
	return v5
end

function class:start(resolve, reject)
	self.resolve = resolve
	self.reject = reject
	self:makeRequest()
end

function class:processResponse(data2)
	local success, result

	if defineFastFlag then
		if data2.StatusCode == StatusCodes.NO_CONTENT then
			success = true
		else
			success, result = pcall(HttpService.JSONDecode, HttpService, data2.Body)
		end
	else
		success, result = pcall(HttpService.JSONDecode, HttpService, data2.Body)
	end

	if not success then
		self.reject({ HttpError = Enum.HttpError.OK, isJSONValid = false })
		return
	end

	if not FFlagDisableLegacyReportToDiag then
		NetworkProfiler:track({
			queued = data2.Stats.DurationInQueue,
			nameLookup = data2.Stats.DurationNameLookup,
			connect = data2.Stats.DurationConnect,
			sslHandshake = data2.Stats.DurationSSLHandshake,
			makeRequest = data2.Stats.DurationMakeRequest,
			receiveResponse = data2.Stats.DurationReceiveResponse
		})
	end

	local v5 = data2.Stats.RoundTripTime * 1000
	local v6 = data2.Body and typeof(data2.Body) == "string" and #data2.Body or 0

	local v7 = {
		responseCode = data2.StatusCode,
		requestUrl = self.internalOptions.Url,
		responseTimeMs = v5,
		isJSONValid = true,
		result,
		responseBody = result,
		responseStats = data2.Stats,
		responseSize = v6
	}

	self.resolve(v7)
	GreenlistedEndpointsForLogging.sendStatusCodeCounter(self.internalOptions.Url, data2.StatusCode)
end

function class:retry(p2, p3)
	local v5 = not (p2.Stats and p2.Stats.WasRequestRetried)

	if v5 then
		self.retryCount += 1

		if self.retryCount > self.maxRetryCount then
			v5 = false
		end
	end

	if not v5 then
		self.reject(p2)
		return
	end

	if self.internalOptions.Headers == nil then
		self.internalOptions.Headers = {}
	end

	self.internalOptions.Headers["X-Retry-Attempt"] = tostring(self.retryCount)

	local v6 = p3 or math.pow(2, self.retryCount)

	delay(v6, function()
		self:makeRequest()
	end)
end

function class:makeRequest()
	if self.canceled then
		return
	end

	self.httpRequest = self.httpService:RequestInternal(self.internalOptions)

	self.httpRequest:Start(function(p2, data)
		if self.session ~= HttpCanceller.currentSession() then
			warn("Http request aborted", self.internalOptions.Url)
		elseif p2 then
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

local function createRequestInternalWrapper(p2)
	local v5 = p2 or HttpService

	local function makeRequest(p3, p4, p5)
		local v6 = class.new(v5, p3, p4, p5)

		local function cancel()
			v6:cancel()
		end

		return Promise.new(function(p6, p7)
			v6:start(p6, p7)
		end), cancel
	end

	return makeRequest
end

return createRequestInternalWrapper
