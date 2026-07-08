local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.networkingShareLinkTypes)

return function(p1) -- line: 6
	-- upvalues: API_URL (copy)
	local v4 = p1.roduxNetworking.POST({
		Name = "resolve-link"
	}, function(p2, p3) -- line: 11
		-- upvalues: API_URL (copy)
		return p2(API_URL):path("sharelinks"):path("v1"):path("resolve-link"):body({
			linkType = p3.linkType,
			linkId = p3.linkId
		})
	end)

	if p1.useMockedResponse then
		v4.Mock.clear()
		v4.Mock.reply(function() -- line: 21
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

	return v4
end
