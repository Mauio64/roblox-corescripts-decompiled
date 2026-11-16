local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingVirtualEvents/Http")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/types")

return function(p2)
	return (p2.POST("createCreateVirtualEvent", function(callback, data)
		return callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("create"):body({
			title = data.title,
			description = data.description,
			eventTime = {
				startTime = data.eventTime.startTime:ToIsoDate(),
				endTime = data.eventTime.endTime:ToIsoDate()
			},
			universeId = data.universeId
		})
	end))
end
