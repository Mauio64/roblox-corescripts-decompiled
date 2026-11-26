local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Cryo")
local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Http").Enum.RetrievalStatus

local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryTypes").PlayabilityStatusEnum
local isVideoEligibleForPlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils").isVideoEligibleForPlayability

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSduiVideoThumbnail

local v5 = not fFlagLuaAppSduiVideoThumbnail and {
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
} or nil

local function useIsVideoEligible(p2, p3)
	local v6 = useSelector(function(p4)
		return fetchGamePlayabilityAndProductInfo.GetFetchingStatus(p4, p2)
	end)

	local v7 = useSelector(function(p4)
		return p4.PlayabilityStatus and p4.PlayabilityStatus[p2] or nil
	end)

	if fFlagLuaAppSduiVideoThumbnail then
		return isVideoEligibleForPlayability(v6 == retrievalStatus.Done, v7, p3)
	end

	if fFlagLuaAppUsePrevalidatedVideoGamePlayability and p3 then
		return true
	end

	if v6 ~= retrievalStatus.Done or v7 == nil then
		return false
	end

	if v7.isPlayable == true then
		return true
	end

	return Cryo.List.find(v5, v7.playabilityStatus) == nil
end

return useIsVideoEligible
