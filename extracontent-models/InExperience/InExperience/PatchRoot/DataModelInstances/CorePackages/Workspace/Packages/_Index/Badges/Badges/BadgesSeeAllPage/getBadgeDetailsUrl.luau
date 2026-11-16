local parent = script:FindFirstAncestor("Badges").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "landing-page-api/badge-details-page/v1beta1"
})

local function getBadgeDetailsUrl(badgeId: string, userId: string?)
	local v2 = { badgeId = badgeId }

	if userId then
		v2.userId = userId
	end

	v2.PageEntryFormat = "Universal"
	return (urlBuilder.addQueryString(v(), v2))
end

return getBadgeDetailsUrl
