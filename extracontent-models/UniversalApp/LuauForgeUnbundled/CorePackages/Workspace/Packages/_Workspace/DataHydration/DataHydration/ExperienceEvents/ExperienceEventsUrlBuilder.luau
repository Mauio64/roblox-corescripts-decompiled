local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local url = Http.Url

return {
	buildRsvpUpdateUrl = function(p2)
		return urlBuilder.new({
			base = url.APIS_URL,
			path = "virtual-events/v1/virtual-events/{id}/rsvps"
		})({ id = p2 })
	end,
	RSVP_UPDATE_URL = urlBuilder.new({
		base = url.APIS_URL,
		path = "virtual-events/v1/virtual-events/rsvps"
	})
}
