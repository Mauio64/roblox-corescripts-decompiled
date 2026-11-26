local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingVirtualEvents/Http")

return function(p2)
	return (p2.GET("createGetVirtualEventRsvps", function(callback, p3, p4)
		local path = callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(p3):path("rsvps")

		if p4 then
			path = path:queryArgs(p4)
		end

		return path
	end))
end
