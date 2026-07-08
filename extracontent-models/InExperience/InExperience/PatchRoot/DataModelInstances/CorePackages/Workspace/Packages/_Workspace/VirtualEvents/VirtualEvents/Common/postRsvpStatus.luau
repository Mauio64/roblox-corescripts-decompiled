local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local HttpService = game:GetService("HttpService")
local VirtualEventsParent = VirtualEvents.Parent
local UrlBuilder = require(VirtualEventsParent.UrlBuilder).UrlBuilder

return function(p1, p2, p3) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v8 = UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps")
	local json = HttpService:JSONEncode({
		rsvpStatus = p3
	})

	return p1(v8({
		id = p2
	}), "POST", {
		postBody = json
	}):andThen(function(p4) -- line: 17
		return p4.responseBody
	end)
end
