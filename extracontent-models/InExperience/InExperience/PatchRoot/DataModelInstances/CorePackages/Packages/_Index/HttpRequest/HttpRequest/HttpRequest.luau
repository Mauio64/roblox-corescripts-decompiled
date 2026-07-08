local Parent = script:FindFirstAncestor("HttpRequest").Parent
local Cryo = require(Parent.Cryo)
local HttpService = game:GetService("HttpService")
local StatusCode = require(script.Parent.StatusCode)
local HttpSession = require(script.Parent.HttpSession)
local HttpResponse = require(script.Parent.HttpResponse)
local t1 = {
	[StatusCode.REQUEST_TIMEOUT] = true,
	[StatusCode.SERVICE_UNAVAILABLE] = true,
	[StatusCode.GATEWAY_TIMEOUT] = true
}
local t2 = {}

t2.__index = t2

function t2.new(p1, p2, p3, p4) -- line: 34
	-- upvalues: Cryo (copy), HttpSession (copy), t2 (copy)
	local v13 = p1 or {}
	local v14 = p4 or {}
	local t3 = {
		resolve = nil,
		reject = nil,
		retryCount = 0,
		httpRequest = nil,
		canceled = false,
		requestFunction = v13.requestFunction,
		postRequestFunction = v13.postRequestFunction,
		url = p2,
		requestMethod = p3,
		options = Cryo.Dictionary.join(v13.defaultOptions or {}, v14),
		waitImpl = v13.waitImpl or delay,
		maxRetryCount = v13.maxRetryCount or 4,
		maxWaitTime = v13.maxWaitTime or 16,
		session = HttpSession.currentSession()
	}

	setmetatable(t3, t2)

	return t3
end
function t2.start(p5, p6, p7) -- line: 59
	p5.resolve = p6
	p5.reject = p7
	p5:makeRequest()
end
function t2.processResponse(p8, p9) -- line: 65
	-- upvalues: HttpService (copy), HttpResponse (copy)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, p9.Body)

	if ok then
		if p8.postRequestFunction then
			pcall(p8.postRequestFunction, p9, {
				url = p8.url,
				requestMethod = p8.requestMethod,
				options = p8.options,
				retryCount = p8.retryCount
			})
		end

		p8.resolve(HttpResponse.success(p9.StatusCode, result))

		return
	end

	p8.reject(HttpResponse.error(Enum.HttpError.OK))
end
function t2.retry(p10, p11, p12) -- line: 84
	p10.retryCount = p10.retryCount + 1

	if p10.retryCount > p10.maxRetryCount then
		p10.reject(p11)

		return
	end

	p10:wait(p12 or math.pow(2, p10.retryCount))
end
function t2.wait(p13, p14) -- line: 94
	p13.waitImpl(p14, function() -- line: 95
		-- upvalues: p13 (copy)
		p13:makeRequest()
	end)
end
function t2.makeRequest(p15) -- line: 100
	-- upvalues: HttpSession (copy), t1 (copy), StatusCode (copy), HttpResponse (copy)
	if p15.canceled then
		return
	end

	p15.httpRequest = p15.requestFunction(p15.url, p15.requestMethod, p15.options)
	p15.httpRequest:Start(function(p16, p17) -- line: 105
		-- upvalues: p15 (copy), HttpSession (copy), t1 (copy), StatusCode (copy), HttpResponse (copy)
		if p15.session ~= HttpSession.currentSession() then
			warn("Http request aborted", p15.url)

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

			if p17.StatusCode == StatusCode.TOO_MANY_REQUESTS and p17.Headers["Retry-After"] then
				local num = tonumber(p17.Headers["Retry-After"])

				if num ~= nil and num <= p15.maxWaitTime then
					p15:retry(p17, num)

					return
				end

				p15.reject(p17)

				return
			end

			p15.reject(p17)

			return
		end

		if not p15.canceled then
			p15:retry(HttpResponse.error(p17.HttpError))
		end
	end)
end
function t2.cancel(p18) -- line: 132
	-- upvalues: HttpResponse (copy)
	p18.canceled = true
	p18.reject(HttpResponse.error(Enum.HttpError.Aborted))

	if p18.httpRequest then
		p18.httpRequest:Cancel()
	end
end

return t2
