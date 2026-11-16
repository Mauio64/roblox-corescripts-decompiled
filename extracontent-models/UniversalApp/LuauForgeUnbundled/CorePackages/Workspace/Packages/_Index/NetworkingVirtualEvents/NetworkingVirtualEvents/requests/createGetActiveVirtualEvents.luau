local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingVirtualEvents/Http")

return function(p2)
	return (p2.GET("createGetActiveVirtualEvents", function(callback, p3)
		local path = callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("active")

		if p3 then
			path = path:queryArgs(p3)
		end

		return path
	end))
end
