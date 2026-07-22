local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local GamePlayButtonParent = GamePlayButton.Parent
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)

require(GamePlayButtonParent.PlayabilityRodux)

local PlayabilityStatusEnum = require(GamePlayButtonParent.DiscoveryTypes).PlayabilityStatusEnum
local getAppFeaturePolicies = require(GamePlayButtonParent.UniversalAppPolicy).getAppFeaturePolicies
local LaunchErrorLocalizationKeys = require(GamePlayButtonParent.GameLaunch).LaunchErrorLocalizationKeys
local useSelector = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useSelector
local useGameInfosSelector = require(GamePlayButtonParent.GameInfosRodux).useGameInfosSelector
local useGameProductInfoSelector = require(GamePlayButtonParent.GameProductInfoRodux).useGameProductInfoSelector
local useAppPolicy = require(GamePlayButtonParent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(GamePlayButtonParent.Localization).Hooks.useLocalization
local ExperienceDetailsNoticeType = require(GamePlayButtonParent.DiscoveryTypes).ExperienceDetailsNoticeType

local function v13(p1, p2, p3) -- line: 21
	-- upvalues: PlayabilityStatusEnum (copy), getAppFeaturePolicies (copy), LaunchErrorLocalizationKeys (copy)
	if p2 then
		if p1 == nil or (p2.playabilityStatus == PlayabilityStatusEnum.PurchaseRequired or p2.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseRequired) and (p3 == nil or p3.isForSale == false) then
			return "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
		end

		if p2.playabilityStatus == PlayabilityStatusEnum.DeviceRestricted then
			local v17 = getAppFeaturePolicies().getPlatformDisplayName() or ""

			if v17 ~= "" then
				return "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedCustom", {
					device = v17
				}
			end
		end

		return LaunchErrorLocalizationKeys[p2.playabilityStatus]
	end

	return nil
end

return function(p4, s1: string, p5) -- line: 77
	-- upvalues: useAppPolicy (copy), useSelector (copy), useGameInfosSelector (copy), useGameProductInfoSelector (copy), useLocalization (copy), PlayButtonStates (copy), v13 (copy), ExperienceDetailsNoticeType (copy)
	local v27 = useAppPolicy(function(p6) -- line: 78
		return {
			experienceDetailsNoticeType = p6.getExperienceDetailsNoticeType()
		}
	end)
	local v28 = useSelector(function(p7) -- line: 84
		-- upvalues: p4 (copy)
		return p7.PlayabilityStatus and (not not p7.PlayabilityStatus[p4] and p7.PlayabilityStatus[p4].unplayableDisplayText) or nil
	end)
	local v29 = useSelector(function(p8) -- line: 91
		-- upvalues: p4 (copy)
		return p8.GameDetails[p4]
	end)
	local v30 = useGameInfosSelector(p4)
	local v31 = v29 and v29.rootPlaceId or (v30 and v30.placeId or nil)
	local v32 = useGameProductInfoSelector(p4)
	local v33 = useLocalization
	local t1 = {
		agreeToNotice = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice"
	}
	local v37

	if s1 == PlayButtonStates.UnplayableOther then
		local v35, v36 = v13(v31, p5, v32)

		if v35 == nil then
			v37 = nil
		elseif v36 then
			v37 = table.clone(v36)
			v37[1] = v35
		else
			v37 = v35
		end
	else
		v37 = nil
	end

	t1.unplayableOtherFallback = v37

	local v38 = v33(t1)

	if (s1 == PlayButtonStates.Playable or s1 == PlayButtonStates.PlayableWithParty or s1 == PlayButtonStates.WaitingForParty) and v27.experienceDetailsNoticeType == ExperienceDetailsNoticeType.InExperiencePurchase then
		return v38.agreeToNotice
	end

	if v28 and v28 ~= "" then
		return v28
	end

	if s1 == PlayButtonStates.UnplayableOther then
		return v38.unplayableOtherFallback
	end

	return nil
end
