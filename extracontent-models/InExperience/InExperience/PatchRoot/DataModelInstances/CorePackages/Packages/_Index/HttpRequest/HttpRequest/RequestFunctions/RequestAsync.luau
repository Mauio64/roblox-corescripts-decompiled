local HttpService = game:GetService("HttpService")

local getHeaders = require(script.Parent.Util.getHeaders)
local getPostBody = require(script.Parent.Util.getPostBody)

return function(url, method, p)
	return {
		Start = function(_, callback)
			local success, result = pcall(function()
				return HttpService:RequestAsync({
					Url = url,
					Method = method,
					Body = getPostBody(p.postBody, method),
					Headers = getHeaders(p.headers, method)
				})
			end)

			callback(success, result)
		end,
		Cancel = function() end
	}
end
