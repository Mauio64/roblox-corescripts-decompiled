local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")
local Http = require(NetworkingVirtualEvents.Parent.Http)

return function(p1) -- line: 5
	-- upvalues: Http (copy)
	return (p1.POST(script.Name, function(p2, s1: string) -- line: 6
		-- upvalues: Http (copy)
		return p2(Http.Url.APIS_URL):path("virtual-events"):path("v1"):path("virtual-events"):id(s1)
	end))
end
