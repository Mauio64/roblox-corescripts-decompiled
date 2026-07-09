local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")
local Http = require(NetworkingVirtualEvents.Parent.Http)

return function(p1) -- line: 12
	-- upvalues: Http (copy)
	return (p1.GET(script.Name, function(p2, t1: {[any]: any}?) -- line: 13
		-- upvalues: Http (copy)
		local v6 = p2(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):path("active")

		if t1 then
			v6 = v6:queryArgs(t1)
		end

		return v6
	end))
end
