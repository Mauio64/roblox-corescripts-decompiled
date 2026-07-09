local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local HttpService = game:GetService("HttpService")
local VirtualEventsParent = VirtualEvents.Parent
local UrlBuilder = require(VirtualEventsParent.UrlBuilder).UrlBuilder

return function(p1) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	return p1(UrlBuilder.fromString("apis:virtual-events/v1/notifications/modal-history")(), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
