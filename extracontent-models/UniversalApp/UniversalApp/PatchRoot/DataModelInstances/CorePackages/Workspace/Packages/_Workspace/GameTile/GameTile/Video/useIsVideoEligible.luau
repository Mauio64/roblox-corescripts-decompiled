local Parent = script:FindFirstAncestor("GameTile").Parent
local Cryo = require(Parent.Cryo)
local FetchGamePlayabilityAndProductInfo = require(Parent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local RetrievalStatus = require(Parent.Http).Enum.RetrievalStatus
local PlayabilityStatusEnum = require(Parent.DiscoveryTypes).PlayabilityStatusEnum
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagLuaAppAddVideoIneligiblePlayabilityStatus = require(Parent.SharedFlags).FFlagLuaAppAddVideoIneligiblePlayabilityStatus
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(Parent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local t1 = {
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
	if not FFlagLuaAppAddVideoIneligiblePlayabilityStatus then nil else PlayabilityStatusEnum.ContextualPlayabilityRequireParentApproval,
	if not FFlagLuaAppAddVideoIneligiblePlayabilityStatus then nil else PlayabilityStatusEnum.ContextualPlayabilityAgeCheckRequired,
	if not FFlagLuaAppAddVideoIneligiblePlayabilityStatus then nil else PlayabilityStatusEnum.ContextualPlayabilityCoreGated,
	if not FFlagLuaAppAddVideoIneligiblePlayabilityStatus then nil else PlayabilityStatusEnum.ContextualPlayabilityUnverifiedSeventeenPlusUser
}

local function useIsVideoEligible(p1, b1: boolean?) -- line: 49
	-- upvalues: useSelector (copy), FetchGamePlayabilityAndProductInfo (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), RetrievalStatus (copy), Cryo (copy), t1 (copy)
	local v13 = useSelector(function(p2) -- line: 50
		-- upvalues: FetchGamePlayabilityAndProductInfo (copy), p1 (copy)
		return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p2, p1)
	end)
	local v14 = useSelector(function(p3) -- line: 54
		-- upvalues: p1 (copy)
		return p3.PlayabilityStatus and p3.PlayabilityStatus[p1] or nil
	end)

	if FFlagLuaAppUsePrevalidatedVideoGamePlayability and b1 then
		return true
	end

	if v13 == RetrievalStatus.Done and v14 ~= nil then
		if v14.isPlayable == true then
			return true
		end

		if Cryo.List.find(t1, v14.playabilityStatus) ~= nil then
			return false
		end

		return true
	end

	return false
end

return useIsVideoEligible
