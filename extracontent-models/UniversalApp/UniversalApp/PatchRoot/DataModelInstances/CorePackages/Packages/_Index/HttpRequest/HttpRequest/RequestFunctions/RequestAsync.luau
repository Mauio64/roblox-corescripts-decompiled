local HttpService = game:GetService("HttpService")
local getHeaders = require(script.Parent.Util.getHeaders)
local getPostBody = require(script.Parent.Util.getPostBody)

return function(p1, p2, p3) -- line: 6
	-- upvalues: HttpService (copy), getPostBody (copy), getHeaders (copy)
	return {
		Start = function(_, p5) -- line: 8
			-- upvalues: HttpService (copy), p1 (copy), p2 (copy), getPostBody (copy), p3 (copy), getHeaders (copy)
			local ok, result = pcall(function() -- line: 9
				-- upvalues: HttpService (copy), p1 (copy), p2 (copy), getPostBody (copy), p3 (copy), getHeaders (copy)
				return HttpService:RequestAsync({
					Url = p1,
					Method = p2,
					Body = getPostBody(p3.postBody, p2),
					Headers = getHeaders(p3.headers, p2)
				})
			end)

			p5(ok, result)
		end,
		Cancel = function() -- line: 20
		end
	}
end
