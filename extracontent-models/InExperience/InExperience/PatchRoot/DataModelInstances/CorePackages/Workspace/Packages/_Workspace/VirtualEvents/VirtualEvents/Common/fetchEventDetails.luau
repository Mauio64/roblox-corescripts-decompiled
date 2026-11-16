local parent = script:FindFirstAncestor("VirtualEvents").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, id)
	return callback(urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")({ id = id }), "GET"):andThen(function(p)
		return p.responseBody
	end)
end
