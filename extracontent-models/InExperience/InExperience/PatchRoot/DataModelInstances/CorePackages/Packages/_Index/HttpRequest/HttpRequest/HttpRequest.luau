local parent = script:FindFirstAncestor("HttpRequest").Parent
local Cryo = require(parent.Cryo)

local HttpService = game:GetService("HttpService")

local StatusCode = require(script.Parent.StatusCode)
local HttpSession = require(script.Parent.HttpSession)
local HttpResponse = require(script.Parent.HttpResponse)

local set = {
	[StatusCode.REQUEST_TIMEOUT] = true,
	[StatusCode.SERVICE_UNAVAILABLE] = true,
	[StatusCode.GATEWAY_TIMEOUT] = true
}

local HttpRequest = {}
HttpRequest.__index = HttpRequest

function HttpRequest.new(options, url, requestMethod, options2)
	local v = options or {}
	local v2 = {
		resolve = nil,
		reject = nil,
		retryCount = 0,
		httpRequest = nil,
		canceled = false,
		requestFunction = v.requestFunction,
		postRequestFunction = v.postRequestFunction,
		url = url,
		requestMethod = requestMethod,
		options = Cryo.Dictionary.join(v.defaultOptions or {}, options2 or {}),
		waitImpl = v.waitImpl or delay,
		maxRetryCount = v.maxRetryCount or 4,
		maxWaitTime = v.maxWaitTime or 16,
		session = HttpSession.currentSession()
	}

	setmetatable(v2, HttpRequest)
	return v2
end

function HttpRequest:start(resolve, reject)
	self.resolve = resolve
	self.reject = reject
	self:makeRequest()
end

function HttpRequest:processResponse(p)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p.Body)

	if not success then
		self.reject(HttpResponse.error(Enum.HttpError.OK))

		return
	end

	if self.postRequestFunction then
		pcall(self.postRequestFunction, p, {
			url = self.url,
			requestMethod = self.requestMethod,
			options = self.options,
			retryCount = self.retryCount
		})
	end

	self.resolve(HttpResponse.success(p.StatusCode, result))
end

function HttpRequest:retry(p, p2)
	self.retryCount += 1

	if self.retryCount > self.maxRetryCount then
		self.reject(p)
	else
		self:wait(p2 or math.pow(2, self.retryCount))
	end
end

function HttpRequest:wait(p)
	self.waitImpl(p, function()
		self:makeRequest()
	end)
end

function HttpRequest:makeRequest()
	if self.canceled then
		return
	end

	self.httpRequest = self.requestFunction(self.url, self.requestMethod, self.options)
	self.httpRequest:Start(function(p, data)
		if self.session ~= HttpSession.currentSession() then
			warn("Http request aborted", self.url)
		elseif p then
			if data.StatusCode >= 200 and data.StatusCode < 400 then
				self:processResponse(data)
				return
			end

			if set[data.StatusCode] then
				self:retry(data)
				return
			end

			if data.StatusCode ~= StatusCode.TOO_MANY_REQUESTS or not data.Headers["Retry-After"] then
				self.reject(data)
				return
			end

			local retryAfter = tonumber(data.Headers["Retry-After"])

			if retryAfter == nil or not (retryAfter <= self.maxWaitTime) then
				self.reject(data)
			else
				self:retry(data, retryAfter)
			end
		elseif not self.canceled then
			self:retry(HttpResponse.error(data.HttpError))
		end
	end)
end

function HttpRequest:cancel()
	self.canceled = true
	self.reject(HttpResponse.error(Enum.HttpError.Aborted))

	if self.httpRequest then
		self.httpRequest:Cancel()
	end
end

return HttpRequest
