local parent = script:FindFirstAncestor("GamePlayButton").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonAmpAgeCheckFlow = SharedFlags.FFlagLuaAppPlayButtonAmpAgeCheckFlow

local v = {
	AgeVerification = "AgeVerification",
	UpdatePlaytestSettings = "UpdatePlaytestSettings",
	TrustedFriends = "TrustedFriends"
}

return {
	Type = v,
	getType = function(p: string?)
		if
			p == PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
			or FFlagLuaAppPlayButtonAmpAgeCheckFlow and p == PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired
		then
			return v.AgeVerification
		end

		if
			p == PlayabilityStatusEnum.ContextualPlayabilityPlaytestDisabled
			or p == PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval
		then
			return v.UpdatePlaytestSettings
		end

		if p == PlayabilityStatusEnum.ContextualPlayabilityTrustedFriendRequired then
			return v.TrustedFriends
		end

		return nil
	end
}
