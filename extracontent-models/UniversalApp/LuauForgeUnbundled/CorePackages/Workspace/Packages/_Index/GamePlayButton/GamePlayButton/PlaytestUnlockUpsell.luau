local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum

local fFlagLuaAppPlayButtonAmpAgeCheckFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagLuaAppPlayButtonAmpAgeCheckFlow

local v5 = {
	AgeVerification = "AgeVerification",
	UpdatePlaytestSettings = "UpdatePlaytestSettings",
	TrustedFriends = "TrustedFriends"
}

return {
	Type = v5,
	getType = function(p2)
		if
			p2 == playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
			or fFlagLuaAppPlayButtonAmpAgeCheckFlow
			and p2 == playabilityStatusEnum.ContextualPlayabilityAgeCheckRequired
		then
			return v5.AgeVerification
		end

		if
			p2 == playabilityStatusEnum.ContextualPlayabilityPlaytestDisabled
			or p2 == playabilityStatusEnum.ContextualPlayabilityRequireParentApproval
		then
			return v5.UpdatePlaytestSettings
		end

		if p2 == playabilityStatusEnum.ContextualPlayabilityTrustedFriendRequired then
			return v5.TrustedFriends
		end

		return nil
	end
}
