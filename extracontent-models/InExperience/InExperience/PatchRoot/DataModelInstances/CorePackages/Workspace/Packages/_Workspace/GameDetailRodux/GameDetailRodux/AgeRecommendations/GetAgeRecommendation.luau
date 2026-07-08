local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Url = require(Parent.Http).Url
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local HttpService = game:GetService("HttpService")
local v5 = UrlBuilder.new({
	path = "experience-guidelines-api/experience-guidelines/get-age-recommendation",
	base = Url.APIS_URL
})

return function(p1, s1: string) -- line: 29
	-- upvalues: v5 (copy), HttpService (copy)
	return p1(v5(), "POST", {
		postBody = HttpService:JSONEncode({
			universeId = s1
		})
	})
end
