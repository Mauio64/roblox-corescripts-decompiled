local parent = script:FindFirstAncestor("GameTile").Parent
local Cryo = require(parent.Cryo)
local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus

local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local VideoUtils = require(parent.VideoUtils)
local isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags.FFlagLuaAppUsePrevalidatedVideoGamePlayability
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags2.FFlagLuaAppSduiVideoThumbnail

local v = not FFlagLuaAppSduiVideoThumbnail and {
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
} or nil

local function useIsVideoEligible(p, flag: boolean?)
	local v2 = useSelector(function(p2)
		return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p2, p)
	end)

	local v3 = useSelector(function(p2)
		return p2.PlayabilityStatus and p2.PlayabilityStatus[p] or nil
	end)

	if FFlagLuaAppSduiVideoThumbnail then
		return isVideoEligibleForPlayability(v2 == RetrievalStatus.Done, v3, flag)
	end

	if FFlagLuaAppUsePrevalidatedVideoGamePlayability and flag then
		return true
	end

	if v2 ~= RetrievalStatus.Done or v3 == nil then
		return false
	end

	return v3.isPlayable == true or Cryo.List.find(v, v3.playabilityStatus) == nil
end

return useIsVideoEligible
