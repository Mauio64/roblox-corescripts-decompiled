local parent = script:FindFirstAncestor("Badges").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local BadgesSeeAllPageConstants = require(script.Parent.BadgesSeeAllPageConstants)

local v = urlBuilder.new({ base = Url.APIS_URL, path = "landing-page-api/badges-see-all/v1beta1" })

local function getBadgesSeeAllUrl(universeId: string, cursor: string?)
	return (urlBuilder.addQueryString(v(), {
		universeId = universeId,
		pageSize = BadgesSeeAllPageConstants.RequestPageSize,
		cursor = cursor,
		PageEntryFormat = "Universal"
	}))
end

return getBadgesSeeAllUrl
