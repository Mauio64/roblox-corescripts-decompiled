local HttpService = game:GetService("HttpService")

local getHeaders = require(script.Parent.Util.getHeaders)
local getPostBody = require(script.Parent.Util.getPostBody)

return function(url, method, data)
	return HttpService:RequestInternal({
		Url = url,
		Method = method,
		Body = getPostBody(data.postBody, method),
		Timeout = data.timeout or 15000,
		CachePolicy = data.cachePolicy or Enum.HttpCachePolicy.None,
		Priority = data.priority or 0,
		Headers = getHeaders(data.headers, method),
		RequestType = data.requestType or nil,
		AllowSandboxing = data.allowSandboxing or nil
	})
end
