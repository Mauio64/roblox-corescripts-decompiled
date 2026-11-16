local parent = script.Parent.Parent
local parent2 = parent.Parent

local API_URL = require(parent.API_URL)
require(parent.networkingShareLinkTypes)
local tutils = require(parent2.tutils)

local HttpService = game:GetService("HttpService")

return function(p)
	local post = p.roduxNetworking.POST("get-or-create-link", function(callback, p2)
		local copy = tutils.deepCopy(p2)
		copy.linkType = nil

		local path = callback(API_URL):path("sharelinks"):path("v1"):path("get-or-create-link")
		local v = { linkType = p2.linkType, data = 0 }
		local v2

		if next(copy) ~= nil then
			v2 = HttpService:JSONEncode(copy)
		end

		v.data = v2
		return path:body(v)
	end)

	if p.useMockedResponse then
		post.Mock.clear()
		post.Mock.reply(function()
			return {
				responseBody = { linkId = "42685" }
			}
		end)
	end

	return post
end
