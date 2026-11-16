local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local HttpService = game:GetService("HttpService")

local parent = VirtualEvents.Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	local v = urlBuilder.fromString("apis:virtual-events/v1/notifications/preferences")

	local jsonEncode = HttpService:JSONEncode({ isEnabled = true })

	return callback(v(), "POST", { postBody = jsonEncode })
end
