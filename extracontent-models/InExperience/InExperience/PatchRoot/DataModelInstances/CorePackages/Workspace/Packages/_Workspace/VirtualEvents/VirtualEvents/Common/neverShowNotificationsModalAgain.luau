local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local HttpService = game:GetService("HttpService")

local parent = VirtualEvents.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("apis:virtual-events/v1/notifications/modal-history")(), "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
