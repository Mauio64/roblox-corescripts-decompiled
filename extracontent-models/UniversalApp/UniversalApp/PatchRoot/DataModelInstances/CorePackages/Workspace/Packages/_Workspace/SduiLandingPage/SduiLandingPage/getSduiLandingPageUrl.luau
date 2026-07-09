local Parent = script:FindFirstAncestor("SduiLandingPage").Parent
local Url = require(Parent.Http).Url
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local v4 = UrlBuilder.new({
	path = "landing-page-api/spotlight-collection",
	base = Url.APIS_URL
})

local function getSduiLandingPageUrl(s1: string, s2: string) -- line: 12
	-- upvalues: UrlBuilder (copy), v4 (copy)
	return UrlBuilder.addQueryString(v4(), {
		spotlightCollectionId = s1,
		sessionId = s2
	})
end

return getSduiLandingPageUrl
