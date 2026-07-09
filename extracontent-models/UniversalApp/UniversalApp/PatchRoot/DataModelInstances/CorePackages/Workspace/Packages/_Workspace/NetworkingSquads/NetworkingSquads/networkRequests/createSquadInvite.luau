local HttpService = game:GetService("HttpService")
local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 7
	-- upvalues: SQUAD_URL (copy), HttpService (copy)
	local roduxNetworking = p1.roduxNetworking
	local t1 = nil
	local v6 = roduxNetworking.POST({
		Name = "SquadInvite"
	}, function(p2, p3) -- line: 13
		-- upvalues: p1 (copy), t1 (ref), SQUAD_URL (copy), HttpService (copy)
		if p1.useMockedResponse then
			t1 = {
				responseBody = {
					channelUpgraded = false,
					parentChannelId = p3.parentChannelId,
					results = {{
						userId = 3447631062,
						resultStatus = {
							resultType = "success",
							message = "message"
						}
					}}
				}
			}
		end

		return p2(SQUAD_URL):path("group-up"):path("v1"):path("invite"):body({
			groupUpId = p3.squadId,
			invitedUserIds = p3.invitedUserIds,
			parentChannelId = p3.parentChannelId,
			isReparented = p3.isReparented,
			requestId = HttpService:GenerateGUID()
		})
	end)

	if p1.useMockedResponse then
		v6.Mock.clear()
		v6.Mock.reply(function() -- line: 44
			-- upvalues: t1 (ref)
			return t1
		end)
	end

	return v6
end
