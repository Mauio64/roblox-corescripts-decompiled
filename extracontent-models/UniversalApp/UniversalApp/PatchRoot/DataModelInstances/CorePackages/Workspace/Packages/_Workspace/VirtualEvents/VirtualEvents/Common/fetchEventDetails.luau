local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2) -- line: 5
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")({
		id = p2
	}), "GET"):andThen(function(p3) -- line: 8
		return p3.responseBody
	end)
end
