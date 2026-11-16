local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

return {
	buildRsvpUpdateUrl = function(id: string)
		return urlBuilder.new({
			base = Url.APIS_URL,
			path = "virtual-events/v1/virtual-events/{id}/rsvps"
		})({ id = id })
	end,
	RSVP_UPDATE_URL = urlBuilder.new({
		base = Url.APIS_URL,
		path = "virtual-events/v1/virtual-events/rsvps"
	})
}
