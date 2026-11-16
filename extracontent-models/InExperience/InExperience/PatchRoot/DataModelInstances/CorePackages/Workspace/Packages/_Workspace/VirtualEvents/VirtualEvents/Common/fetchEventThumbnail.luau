local parent = script:FindFirstAncestor("VirtualEvents").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, id, p: string?)
	return callback(urlBuilder.fromString("apis:virtual-events/v1/virtual-events/{id}")({ id = id }), "GET"):andThen(
		function(p2)
			local mediaId = p2.responseBody
				and p2.responseBody.thumbnails
				and p2.responseBody.thumbnails[1]
				and p2.responseBody.thumbnails[1].mediaId
				or nil

			if mediaId then
				return "rbxassetid://" .. mediaId
			end

			return p
		end,
		function()
			return p
		end
	)
end
