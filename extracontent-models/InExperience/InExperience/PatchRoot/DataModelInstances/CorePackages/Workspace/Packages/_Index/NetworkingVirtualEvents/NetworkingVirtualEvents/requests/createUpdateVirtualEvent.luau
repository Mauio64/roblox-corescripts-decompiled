local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local Http = require(NetworkingVirtualEvents.Parent.Http)
require(NetworkingVirtualEvents.types)

return function(p)
	return (p.POST(script.Name, function(callback, p2: string, data)
		local eventTime = data.eventTime

		return callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(p2):body({
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
