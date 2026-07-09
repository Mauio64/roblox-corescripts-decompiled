local Parent = script:FindFirstAncestor("Badges").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local FFlagSduiUniversalPageEntry = require(Parent.SharedFlags).FFlagSduiUniversalPageEntry
local v5 = UrlBuilder.new({
	path = "landing-page-api/badges-see-all/v1beta1",
	base = Url.APIS_URL
})
local v6 = game:DefineFastInt("LuaAppBadgesSeeAllRequestPageSize", 50)

local function getBadgesSeeAllUrl(s1: string, s2: string?) -- line: 16
	-- upvalues: UrlBuilder (copy), v5 (copy), v6 (copy), FFlagSduiUniversalPageEntry (copy)
	return (UrlBuilder.addQueryString(v5(), {
		universeId = s1,
		pageSize = v6,
		cursor = s2,
		PageEntryFormat = if not FFlagSduiUniversalPageEntry then nil else "Universal"
	}))
end

return getBadgesSeeAllUrl
