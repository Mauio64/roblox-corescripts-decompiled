local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

return {
	buildStatusesUrl = urlBuilder.new({
		base = url.APIS_URL,
		path = "game-transactions/v1/receipts",
		query = "playerId={playerId}&placeId={placeId}&status=pending&locationType=ExperienceDetailPage"
	})
}
