local parent = script:FindFirstAncestor("VideoUtils").Parent

local Cryo = require(parent.Cryo)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags.FFlagLuaAppUsePrevalidatedVideoGamePlayability

local v = {
	PlayabilityStatusEnum.UnderReview,
	PlayabilityStatusEnum.UniverseRootPlaceIsPrivate,
	PlayabilityStatusEnum.InsufficientPermissionFriendsOnly,
	PlayabilityStatusEnum.InsufficientPermissionGroupOnly,
	PlayabilityStatusEnum.GameUnapproved,
	PlayabilityStatusEnum.AccountRestricted,
	PlayabilityStatusEnum.ComplianceBlocked,
	PlayabilityStatusEnum.ContextualPlayabilityRegionalCompliance,
	PlayabilityStatusEnum.ContextualPlayabilityAgeRecommendationParentalControls,
	PlayabilityStatusEnum.ContextualPlayabilityAgeGated,
	PlayabilityStatusEnum.ContextualPlayabilityUnrated,
	PlayabilityStatusEnum.ContextualPlayabilityAgeGatedByDescriptor,
	PlayabilityStatusEnum.ContextualPlayabilityExperienceBlockedParentalControls,
	PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval,
	PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired,
	PlayabilityStatusEnum.ContextualPlayabilityCoreGated,
	PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
}

local function isVideoEligibleForPlayability(flag: boolean, p, flag2: boolean?): boolean
	if FFlagLuaAppUsePrevalidatedVideoGamePlayability and flag2 then
		return true
	end

	return not not flag and p ~= nil and (p.isPlayable == true or Cryo.List.find(v, p.playabilityStatus) == nil)
end

return isVideoEligibleForPlayability
