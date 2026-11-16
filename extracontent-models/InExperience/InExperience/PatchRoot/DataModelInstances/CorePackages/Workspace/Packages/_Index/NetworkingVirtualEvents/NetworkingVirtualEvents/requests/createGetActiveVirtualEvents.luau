local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

local Http = require(NetworkingVirtualEvents.Parent.Http)

return function(p)
	return (p.GET(script.Name, function(callback, p2)
		local path = callback(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("active")

		if p2 then
			path = path:queryArgs(p2)
		end

		return path
	end))
end
