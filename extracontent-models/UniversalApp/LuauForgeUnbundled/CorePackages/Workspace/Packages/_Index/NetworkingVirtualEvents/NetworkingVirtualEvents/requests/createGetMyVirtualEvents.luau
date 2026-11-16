local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/NetworkingVirtualEvents/Http")

return function(p2)
	return (p2.GET("createGetMyVirtualEvents", function(callback)
		return callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("my-events")
	end))
end
