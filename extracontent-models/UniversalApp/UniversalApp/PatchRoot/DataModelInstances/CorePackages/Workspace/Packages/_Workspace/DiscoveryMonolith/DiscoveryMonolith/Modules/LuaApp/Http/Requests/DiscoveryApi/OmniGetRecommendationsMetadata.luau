local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Url = require(Parent.Http).Url
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Cryo = require(Parent.Cryo)
local v6 = UrlBuilder.new({
	path = "discovery-api/omni-recommendation-metadata",
	base = Url.APIS_URL
})

return function(p1, p2) -- line: 26
	-- upvalues: Cryo (copy), v6 (copy), HttpService (copy)
	local t1 = {
		sessionId = "sessionId",
		contents = Cryo.List.map(p2, function(p3) -- line: 28
			return {
				contentType = p3.contentType,
				contentId = p3.contentId
			}
		end)
	}

	return p1(v6(), "POST", {
		postBody = HttpService:JSONEncode(t1)
	})
end
