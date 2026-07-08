local SHARELINKS_URL = require(script.Parent.Parent.SHARELINKS_URL)

require(script.Parent.Parent.networkingShareLinkTypes)

return function(p1) -- line: 5
	-- upvalues: SHARELINKS_URL (copy)
	local v3 = p1.roduxNetworking.POST({
		Name = "resolve-link"
	}, function(p2, p3) -- line: 10
		-- upvalues: SHARELINKS_URL (copy)
		return p2(SHARELINKS_URL):path("v1"):path("resolve-link"):body({
			linkType = p3.linkType,
			linkId = p3.linkId
		})
	end)

	if p1.useMockedResponse then
		v3.Mock.clear()
		v3.Mock.reply(function() -- line: 20
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

	return v3
end
