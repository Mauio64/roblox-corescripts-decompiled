local HttpService = game:GetService("HttpService")
local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

local Packages = script:FindFirstAncestor("Packages")
local FFlagEnableSquadRegroupExperimentation = require(Packages.SharedFlags).FFlagEnableSquadRegroupExperimentation
local FFlagEnablePrivatePartyStartJoin = require(Packages.SharedFlags).FFlagEnablePrivatePartyStartJoin

return function(p1) -- line: 11
	-- upvalues: SQUAD_URL (copy), HttpService (copy), FFlagEnableSquadRegroupExperimentation (copy), FFlagEnablePrivatePartyStartJoin (copy)
	return (p1.roduxNetworking.POST({
		Name = "CreateExperienceInvite"
	}, function(p2, p3) -- line: 15
		-- upvalues: SQUAD_URL (copy), HttpService (copy), FFlagEnableSquadRegroupExperimentation (copy), FFlagEnablePrivatePartyStartJoin (copy)
		return p2(SQUAD_URL):path("group-up"):path("v1"):path("invite-to-experience"):body({
			membershipEntityId = p3.membershipEntityId,
			placeId = p3.placeId,
			requestId = HttpService:GenerateGUID(false),
			voteIdentifier = p3.voteIdentifier,
			source = if not FFlagEnableSquadRegroupExperimentation then nil else p3.source,
			inviteType = if not FFlagEnablePrivatePartyStartJoin then nil else p3.inviteType
		})
	end))
end
