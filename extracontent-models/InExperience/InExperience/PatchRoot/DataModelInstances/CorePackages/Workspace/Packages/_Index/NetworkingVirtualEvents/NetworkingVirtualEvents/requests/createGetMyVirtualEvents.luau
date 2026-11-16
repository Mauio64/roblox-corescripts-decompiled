local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local Http = require(NetworkingVirtualEvents.Parent.Http)

return function(p)
	return (p.GET(script.Name, function(callback)
		return callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("my-events")
	end))
end
