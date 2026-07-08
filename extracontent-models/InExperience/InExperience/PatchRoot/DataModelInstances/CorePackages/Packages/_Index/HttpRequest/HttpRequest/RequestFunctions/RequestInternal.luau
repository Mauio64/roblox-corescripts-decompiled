local HttpService = game:GetService("HttpService")
local getHeaders = require(script.Parent.Util.getHeaders)
local getPostBody = require(script.Parent.Util.getPostBody)

return function(p1, p2, p3) -- line: 6
	-- upvalues: HttpService (copy), getPostBody (copy), getHeaders (copy)
	return HttpService:RequestInternal({
		Url = p1,
		Method = p2,
		Body = getPostBody(p3.postBody, p2),
		Timeout = p3.timeout or 15000,
		CachePolicy = p3.cachePolicy or Enum.HttpCachePolicy.None,
		Priority = p3.priority or 0,
		Headers = getHeaders(p3.headers, p2),
		RequestType = p3.requestType or nil,
		AllowSandboxing = p3.allowSandboxing or nil
	})
end
