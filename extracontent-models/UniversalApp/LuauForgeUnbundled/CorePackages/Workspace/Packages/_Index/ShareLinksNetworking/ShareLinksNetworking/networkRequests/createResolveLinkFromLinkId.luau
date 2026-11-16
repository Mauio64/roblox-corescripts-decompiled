local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkingShareLinkTypes")

return function(p2)
	local post = p2.roduxNetworking.POST("resolve-link", function(callback, p3)
		return callback(API_URL):path("sharelinks"):path("v1"):path("resolve-link"):body({
			linkType = p3.linkType,
			linkId = p3.linkId
		})
	end)

	if p2.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return {
				responseBody = {
					experienceInviteData = {
						instanceId = "ABCDEF",
						inviterId = 46430379,
						placeId = 1818,
						status = "Valid",
						universeId = 13058
					}
				}
			}
		end)
	end

	return post
end
