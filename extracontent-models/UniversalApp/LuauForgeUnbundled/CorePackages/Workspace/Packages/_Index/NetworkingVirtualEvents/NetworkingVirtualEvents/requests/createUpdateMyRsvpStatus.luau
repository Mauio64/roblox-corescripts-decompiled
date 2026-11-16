local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingVirtualEvents/Http")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/types")

return function(p2)
	return (p2.POST("createUpdateMyRsvpStatus", function(callback, p3, p4)
		return (callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(p3):path("rsvps"):body({
			rsvpStatus = p4
		}))
	end))
end
