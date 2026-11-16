local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder

return function(callback, p2, p3)
	return callback(urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")({
		id = p2
	}), "GET"):andThen(
		function(p4)
			local mediaId = p4.responseBody
				and p4.responseBody.thumbnails
				and p4.responseBody.thumbnails[1]
				and p4.responseBody.thumbnails[1].mediaId
				or nil

			if mediaId then
				return "rbxassetid://" .. mediaId
			end

			return p3
		end,
		function()
			return p3
		end
	)
end
