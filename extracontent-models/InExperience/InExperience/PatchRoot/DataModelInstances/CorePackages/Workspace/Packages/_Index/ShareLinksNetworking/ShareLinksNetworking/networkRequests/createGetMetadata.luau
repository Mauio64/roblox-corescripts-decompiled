local parent = script.Parent.Parent

local API_URL = require(parent.API_URL)
require(parent.networkingShareLinkTypes)

return function(p)
	local post = p.roduxNetworking.POST("get-metadata", function(callback, p2)
		return callback(API_URL):path("sharelinks"):path("v1"):path("get-metadata"):body({
			linkType = p2.linkType,
			linkId = p2.linkId
		})
	end)

	if p.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return {
				responseBody = { data = "{ \"universeId\": 123, \"placeId\": 456 }" }
			}
		end)
	end

	return post
end
