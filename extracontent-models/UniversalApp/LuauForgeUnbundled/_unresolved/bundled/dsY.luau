local urlBuilder = require("@luauforge/bundled/dsZ").UrlBuilder
local url = require("@luauforge/bundled/drq").Url

local getFStringTopSongsSortExploreApiPageType = require("@luauforge/bundled/dqB").GetFStringTopSongsSortExploreApiPageType
local fFlagEnableTopSongsSort = require("@luauforge/bundled/dqB").FFlagEnableTopSongsSort

local v5 = urlBuilder.new({ base = url.APIS_URL, path = "/charts-api/v1/get-sorts" })

return function(callback, p2, items, p3)
	local v6 = { sessionId = p3, sortsPageToken = p2 }

	for k, item in items do
		if v6[k] then
			warn(`URL parameter {k} already exists`)
		else
			v6[k] = item
		end
	end

	if fFlagEnableTopSongsSort then
		v6.pageType = getFStringTopSongsSortExploreApiPageType()
	end

	return callback(urlBuilder.addQueryString(v5(), v6), "GET")
end
