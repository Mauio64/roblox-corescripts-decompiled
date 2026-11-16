local SHARELINKS_URL = require(script.Parent.Parent.SHARELINKS_URL)
require(script.Parent.Parent.networkingShareLinkTypes)
local Packages = script:FindFirstAncestor("Packages")
local tutils = require(Packages.tutils)

local HttpService = game:GetService("HttpService")

return function(p)
	local post = p.roduxNetworking.POST({ Name = "create-link" }, function(callback, p2)
		local copy = tutils.deepCopy(p2)
		copy.linkType = nil

		local path = callback(SHARELINKS_URL):path("v1"):path("create-link")
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
