local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Cryo")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryTypes").PlayabilityStatusEnum

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability

local v5 = {
	playabilityStatusEnum.UnderReview,
	playabilityStatusEnum.UniverseRootPlaceIsPrivate,
	playabilityStatusEnum.InsufficientPermissionFriendsOnly,
	playabilityStatusEnum.InsufficientPermissionGroupOnly,
	playabilityStatusEnum.GameUnapproved,
	playabilityStatusEnum.AccountRestricted,
	playabilityStatusEnum.ComplianceBlocked,
	playabilityStatusEnum.ContextualPlayabilityRegionalCompliance,
	playabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls,
	playabilityStatusEnum.ContextualPlayabilityAgeGated,
	playabilityStatusEnum.ContextualPlayabilityUnrated,
	playabilityStatusEnum.ContextualPlayabilityAgeGatedByDescriptor,
	playabilityStatusEnum.ContextualPlayabilityExperienceBlockedParentalControls,
	playabilityStatusEnum.ContextualPlayabilityRequireParentApproval,
	playabilityStatusEnum.ContextualPlayabilityAgeCheckRequired,
	playabilityStatusEnum.ContextualPlayabilityCoreGated,
	playabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
}

local function isVideoEligibleForPlayability(p2, p3, p4): boolean
	if fFlagLuaAppUsePrevalidatedVideoGamePlayability and p4 then
		return true
	end

	if not p2 or p3 == nil then
		return false
	end

	if p3.isPlayable == true then
		return true
	end

	return Cryo.List.find(v5, p3.playabilityStatus) == nil
end

return isVideoEligibleForPlayability
