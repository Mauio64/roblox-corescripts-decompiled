local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local HttpService = game:GetService("HttpService")

local parent = VirtualEvents.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, id, rsvpStatus)
	local v = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps")

	local jsonEncode = HttpService:JSONEncode({ rsvpStatus = rsvpStatus })

	return callback(v({ id = id }), "POST", { postBody = jsonEncode }):andThen(function(p)
		return p.responseBody
	end)
end
