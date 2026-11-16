local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingVirtualEvents/Http")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/types")

return function(p2)
	return (p2.POST("createUpdateVirtualEvent", function(callback, p3, data)
		local eventTime = data.eventTime

		return callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(p3):body({
			title = data.title,
			description = data.description,
			eventTime = eventTime and {
				startTime = eventTime.startTime:ToIsoDate(),
				endTime = eventTime.endTime:ToIsoDate()
			} or nil,
			universeId = data.universeId
		})
	end))
end
