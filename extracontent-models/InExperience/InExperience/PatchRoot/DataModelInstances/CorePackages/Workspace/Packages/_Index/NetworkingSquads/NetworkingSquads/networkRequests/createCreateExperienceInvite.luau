local HttpService = game:GetService("HttpService")

local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)
require(script.Parent.Parent.networkingSquadTypes)

local Packages = script:FindFirstAncestor("Packages")
local SharedFlags = require(Packages.SharedFlags)
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation
local SharedFlags2 = require(Packages.SharedFlags)
local FFlagEnablePrivatePartyStartJoin = SharedFlags2.FFlagEnablePrivatePartyStartJoin

return function(p)
	return (p.roduxNetworking.POST("CreateExperienceInvite", function(callback, data)
		local path = callback(SQUAD_URL):path("group-up"):path("v1"):path("invite-to-experience")
		local v = {
			membershipEntityId = data.membershipEntityId,
			placeId = data.placeId,
			requestId = HttpService:GenerateGUID(false),
			voteIdentifier = data.voteIdentifier,
			source = 0,
			inviteType = 0
		}
		local source

		if FFlagEnableSquadRegroupExperimentation then
			source = data.source
		end

		v.source = source
		local inviteType

		if FFlagEnablePrivatePartyStartJoin then
			inviteType = data.inviteType
		end

		v.inviteType = inviteType
		return path:body(v)
	end))
end
