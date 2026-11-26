local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder

return function(callback, p2, p3)
	local v5 = urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}/rsvps")

	local jsonEncode = HttpService:JSONEncode({ rsvpStatus = p3 })

	return callback(v5({ id = p2 }), "POST", { postBody = jsonEncode }):andThen(function(p4)
		return p4.responseBody
	end)
end
