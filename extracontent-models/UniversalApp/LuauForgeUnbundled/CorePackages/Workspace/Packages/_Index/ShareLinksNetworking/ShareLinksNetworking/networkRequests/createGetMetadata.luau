local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkingShareLinkTypes")

return function(p2)
	local post = p2.roduxNetworking.POST("get-metadata", function(callback, p3)
		return callback(API_URL):path("sharelinks"):path("v1"):path("get-metadata"):body({
			linkType = p3.linkType,
			linkId = p3.linkId
		})
	end)

	if p2.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return {
				responseBody = { data = "{ \"universeId\": 123, \"placeId\": 456 }" }
			}
		end)
	end

	return post
end
