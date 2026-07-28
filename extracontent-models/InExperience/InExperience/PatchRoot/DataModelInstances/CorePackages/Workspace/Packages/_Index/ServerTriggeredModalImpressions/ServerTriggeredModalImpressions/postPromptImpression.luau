local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("ServerTriggeredModalImpressions").Parent
local Promise = require(Parent.Promise)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local v6 = UrlBuilder.new({
	path = "modals-api/v1/prompts/impression",
	base = UrlBase.APIS
})

return function(p1, s1: string, s2: string?) -- line: 15
	-- upvalues: v6 (copy), HttpService (copy), Promise (copy)
	local ok, result = pcall(function() -- line: 16
		-- upvalues: p1 (copy), v6 (copy), HttpService (copy), s1 (copy), s2 (copy)
		return p1(v6(), "POST", {
			postBody = HttpService:JSONEncode({
				promptType = s1,
				promptId = s2
			})
		})
	end)

	if not ok then
		return Promise.reject(result)
	end

	return result
end
