local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local Http = require(NetworkingVirtualEvents.Parent.Http)
require(NetworkingVirtualEvents.types)

return function(p)
	return (p.POST(script.Name, function(callback, p2: string, rsvpStatus)
		return (callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(p2):path("rsvps"):body({
			rsvpStatus = rsvpStatus
		}))
	end))
end
