local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkingShareLinkTypes")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksNetworking/tutils")

local HttpService = game:GetService("HttpService")

return function(p2)
	local post = p2.roduxNetworking.POST("create-link", function(callback, p3)
		local copy = tutils.deepCopy(p3)
		copy.linkType = nil

		local path = callback(API_URL):path("sharelinks"):path("v1"):path("create-link")
		local v5 = { linkType = p3.linkType, data = 0 }
		local v6 = if next(copy) ~= nil then HttpService:JSONEncode(copy) else nil
		v5.data = v6
		return path:body(v5)
	end)

	if p2.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return {
				responseBody = { linkId = "42685" }
			}
		end)
	end

	return post
end
