local parent = script.Parent.Parent

local API_URL = require(parent.API_URL)
require(parent.networkingShareLinkTypes)

return function(p)
	local post = p.roduxNetworking.POST("resolve-link", function(callback, p2)
		return callback(API_URL):path("sharelinks"):path("v1"):path("resolve-link"):body({
			linkType = p2.linkType,
			linkId = p2.linkId
		})
	end)

	if p.useMockedResponse then
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
