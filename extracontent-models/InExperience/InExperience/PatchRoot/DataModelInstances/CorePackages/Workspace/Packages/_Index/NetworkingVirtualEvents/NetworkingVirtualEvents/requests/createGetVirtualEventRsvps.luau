local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")
local Http = require(NetworkingVirtualEvents.Parent.Http)

return function(p1) -- line: 11
	-- upvalues: Http (copy)
	return (p1.GET(script.Name, function(p2, s1: string, t1: {[any]: any}?) -- line: 14
		-- upvalues: Http (copy)
		local v7 = p2(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(s1):path("rsvps")

		if t1 then
			v7 = v7:queryArgs(t1)
		end

		return v7
	end))
end
