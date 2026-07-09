local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.networkingShareLinkTypes)

local tutils = require(ParentParentParent.tutils)
local HttpService = game:GetService("HttpService")

return function(p1) -- line: 10
	-- upvalues: tutils (copy), API_URL (copy), HttpService (copy)
	local v7 = p1.roduxNetworking.POST({
		Name = "get-or-create-link"
	}, function(p2, p3) -- line: 15
		-- upvalues: tutils (copy), API_URL (copy), HttpService (copy)
		local v10 = tutils.deepCopy(p3)

		v10.linkType = nil

		return p2(API_URL):path("sharelinks"):path("v1"):path("get-or-create-link"):body({
			linkType = p3.linkType,
			data = if next(v10) == nil then nil else HttpService:JSONEncode(v10)
		})
	end)

	if p1.useMockedResponse then
		v7.Mock.clear()
		v7.Mock.reply(function() -- line: 28
			return {
				responseBody = {
					linkId = "42685"
				}
			}
		end)
	end

	return v7
end
