local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.networkingShareLinkTypes)

return function(p1) -- line: 6
	-- upvalues: API_URL (copy)
	local v4 = p1.roduxNetworking.POST({
		Name = "get-metadata"
	}, function(p2, p3) -- line: 11
		-- upvalues: API_URL (copy)
		return p2(API_URL):path("sharelinks"):path("v1"):path("get-metadata"):body({
			linkType = p3.linkType,
			linkId = p3.linkId
		})
	end)

	if p1.useMockedResponse then
		v4.Mock.clear()
		v4.Mock.reply(function() -- line: 21
			return {
				responseBody = {
					data = "{ \"universeId\": 123, \"placeId\": 456 }"
				}
			}
		end)
	end

	return v4
end
