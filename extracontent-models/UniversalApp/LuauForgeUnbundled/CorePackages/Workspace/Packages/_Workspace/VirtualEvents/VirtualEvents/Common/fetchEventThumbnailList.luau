local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder

return function(callback, p2)
	return callback(urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")({
		id = p2
	}), "GET"):andThen(
		function(p3)
			return p3.responseBody and p3.responseBody.thumbnails or {}
		end,
		function()
			return {}
		end
	)
end
