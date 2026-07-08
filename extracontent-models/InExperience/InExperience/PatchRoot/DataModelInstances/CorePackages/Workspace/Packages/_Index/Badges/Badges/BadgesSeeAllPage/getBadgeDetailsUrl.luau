local Parent = script:FindFirstAncestor("Badges").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local FFlagSduiUniversalPageEntry = require(Parent.SharedFlags).FFlagSduiUniversalPageEntry
local v5 = UrlBuilder.new({
	path = "landing-page-api/badge-details-page/v1beta1",
	base = Url.APIS_URL
})

local function getBadgeDetailsUrl(s1: string, s2: string?) -- line: 14
	-- upvalues: FFlagSduiUniversalPageEntry (copy), UrlBuilder (copy), v5 (copy)
	local t1 = {
		badgeId = s1
	}

	if s2 then
		t1.userId = s2
	end

	if FFlagSduiUniversalPageEntry then
		t1.PageEntryFormat = "Universal"
	end

	return (UrlBuilder.addQueryString(v5(), t1))
end

return getBadgeDetailsUrl
