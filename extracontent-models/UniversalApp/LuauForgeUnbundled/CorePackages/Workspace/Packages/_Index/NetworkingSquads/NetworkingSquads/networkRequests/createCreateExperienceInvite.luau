local HttpService = game:GetService("HttpService")

local SQUAD_URL = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/SQUAD_URL")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

local fFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSquadRegroupExperimentation
local fFlagEnablePrivatePartyStartJoin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePrivatePartyStartJoin

return function(p2)
	return (p2.roduxNetworking.POST("CreateExperienceInvite", function(callback, data)
		local path = callback(SQUAD_URL):path("group-up"):path("v1"):path("invite-to-experience")
		local v5 = {
			membershipEntityId = data.membershipEntityId,
			placeId = data.placeId,
			requestId = HttpService:GenerateGUID(false),
			voteIdentifier = data.voteIdentifier,
			source = 0,
			inviteType = 0
		}
		local v6 = if fFlagEnableSquadRegroupExperimentation then data.source else nil
		v5.source = v6
		local v7 = if fFlagEnablePrivatePartyStartJoin then data.inviteType else nil
		v5.inviteType = v7
		return path:body(v5)
	end))
end
