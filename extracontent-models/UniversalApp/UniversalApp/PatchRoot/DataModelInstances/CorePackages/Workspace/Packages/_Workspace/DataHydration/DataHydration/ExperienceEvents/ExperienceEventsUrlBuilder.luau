local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url
local v5 = UrlBuilder.new({
	path = "virtual-events/v1/virtual-events/rsvps",
	base = Url.APIS_URL
})

return {
	buildRsvpUpdateUrl = function(s1: string) -- line: 14
		-- upvalues: UrlBuilder (copy), Url (copy)
		return UrlBuilder.new({
			path = "virtual-events/v1/virtual-events/{id}/rsvps",
			base = Url.APIS_URL
		})({
			id = s1
		})
	end,
	RSVP_UPDATE_URL = v5
}
