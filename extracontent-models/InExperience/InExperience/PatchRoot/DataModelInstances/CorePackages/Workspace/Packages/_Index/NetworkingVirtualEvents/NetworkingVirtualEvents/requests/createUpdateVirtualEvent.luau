local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")
local Http = require(NetworkingVirtualEvents.Parent.Http)

require(NetworkingVirtualEvents.types)

return function(p1) -- line: 6
	-- upvalues: Http (copy)
	return (p1.POST(script.Name, function(p2, s1: string, p3) -- line: 9
		-- upvalues: Http (copy)
		local eventTime = p3.eventTime

		return p2(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(s1):body({
			title = p3.title,
			description = p3.description,
			eventTime = if not eventTime then nil else {
				startTime = eventTime.startTime:ToIsoDate(),
				endTime = eventTime.endTime:ToIsoDate()
			},
			universeId = p3.universeId
		})
	end))
end
