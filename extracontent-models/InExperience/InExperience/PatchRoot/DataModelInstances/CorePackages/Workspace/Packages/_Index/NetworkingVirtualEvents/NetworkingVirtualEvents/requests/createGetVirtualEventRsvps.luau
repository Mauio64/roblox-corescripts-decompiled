local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local Http = require(NetworkingVirtualEvents.Parent.Http)

return function(p)
	return (p.GET(script.Name, function(callback, p2: string, p3)
		local path = callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(p2):path("rsvps")

		if p3 then
			path = path:queryArgs(p3)
		end

		return path
	end))
end
