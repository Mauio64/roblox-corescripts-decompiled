local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local Http = require(NetworkingVirtualEvents.Parent.Http)
require(NetworkingVirtualEvents.types)

return function(p)
	return (p.POST(script.Name, function(callback, data)
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
