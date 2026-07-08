local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local HttpService = game:GetService("HttpService")
local VirtualEventsParent = VirtualEvents.Parent
local UrlBuilder = require(VirtualEventsParent.UrlBuilder).UrlBuilder

return function(p1) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v6 = UrlBuilder.fromString("apis:virtual-events/v1/notifications/preferences")
	local json = HttpService:JSONEncode({
		isEnabled = true
	})

	return p1(v6(), "POST", {
		postBody = json
	})
end
