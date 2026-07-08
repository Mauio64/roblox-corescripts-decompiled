local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")
local Http = require(NetworkingVirtualEvents.Parent.Http)

require(NetworkingVirtualEvents.types)

return function(p1) -- line: 6
	-- upvalues: Http (copy)
	return (p1.POST(script.Name, function(p2, p3) -- line: 9
		-- upvalues: Http (copy)
		return p2(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("create"):body({
			title = p3.title,
			description = p3.description,
			eventTime = {
				startTime = p3.eventTime.startTime:ToIsoDate(),
				endTime = p3.eventTime.endTime:ToIsoDate()
			},
			universeId = p3.universeId
		})
	end))
end
