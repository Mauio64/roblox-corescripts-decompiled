local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local LocalizationService = game:GetService("LocalizationService")
local GamePlayButtonParent = GamePlayButton.Parent
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)

require(GamePlayButtonParent.PlayabilityRodux)

local PlayabilityStatusEnum = require(GamePlayButtonParent.DiscoveryTypes).PlayabilityStatusEnum
local getAppFeaturePolicies = require(GamePlayButtonParent.UniversalAppPolicy).getAppFeaturePolicies
local LaunchErrorLocalizationKeys = require(GamePlayButtonParent.GameLaunch).LaunchErrorLocalizationKeys
local Localization = require(GamePlayButtonParent.RobloxAppLocales).Localization
local useSelector = require(GamePlayButtonParent.RoactUtils).Hooks.RoactRodux.useSelector
local useGameInfosSelector = require(GamePlayButtonParent.GameInfosRodux).useGameInfosSelector
local useGameProductInfoSelector = require(GamePlayButtonParent.GameProductInfoRodux).useGameProductInfoSelector
local useAppPolicy = require(GamePlayButtonParent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(GamePlayButtonParent.Localization).Hooks.useLocalization
local ExperienceDetailsNoticeType = require(GamePlayButtonParent.DiscoveryTypes).ExperienceDetailsNoticeType
local FFlagLuaAppPlayabilityMessageUpdate = require(GamePlayButtonParent.SharedFlags).FFlagLuaAppPlayabilityMessageUpdate
local u16 = nil
local s1 = ""

local function translateString(p1, p2) -- line: 27
	-- upvalues: LocalizationService (copy), u16 (ref), Localization (copy), s1 (ref)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	if u16 == nil then
		u16 = Localization.new(RobloxLocaleId)
		s1 = RobloxLocaleId
	end

	if RobloxLocaleId ~= s1 then
		u16:SetLocale(RobloxLocaleId)
		s1 = RobloxLocaleId
	end

	return u16:Format(p1, p2)
end
local function v19(p3, p4, p5) -- line: 40
	-- upvalues: PlayabilityStatusEnum (copy), getAppFeaturePolicies (copy), LaunchErrorLocalizationKeys (copy)
	if p4 then
		if p3 == nil or (p4.playabilityStatus == PlayabilityStatusEnum.PurchaseRequired or p4.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseRequired) and (p5 == nil or p5.isForSale == false) then
			return "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
		end

		if p4.playabilityStatus == PlayabilityStatusEnum.DeviceRestricted then
			local v26 = getAppFeaturePolicies().getPlatformDisplayName() or ""

			if v26 ~= "" then
				return "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedCustom", {
					device = v26
				}
			end
		end

		return LaunchErrorLocalizationKeys[p4.playabilityStatus]
	end

	return nil
end

return function(p6, s2: string, p7) -- line: 96
	-- upvalues: useAppPolicy (copy), useSelector (copy), useGameInfosSelector (copy), useGameProductInfoSelector (copy), FFlagLuaAppPlayabilityMessageUpdate (copy), useLocalization (copy), PlayButtonStates (copy), v19 (copy), ExperienceDetailsNoticeType (copy), LocalizationService (copy), u16 (ref), Localization (copy), s1 (ref)
	local v36 = useAppPolicy(function(p8) -- line: 97
		return {
			experienceDetailsNoticeType = p8.getExperienceDetailsNoticeType()
		}
	end)
	local v37 = useSelector(function(p9) -- line: 103
		-- upvalues: p6 (copy)
		return p9.PlayabilityStatus and (not not p9.PlayabilityStatus[p6] and p9.PlayabilityStatus[p6].unplayableDisplayText) or nil
	end)
	local v38 = useSelector(function(p10) -- line: 110
		-- upvalues: p6 (copy)
		return p10.GameDetails[p6]
	end)
	local v39 = useGameInfosSelector(p6)
	local v40 = v38 and v38.rootPlaceId or (v39 and v39.placeId or nil)
	local v41 = useGameProductInfoSelector(p6)

	if FFlagLuaAppPlayabilityMessageUpdate then
		local v42 = useLocalization
		local t1 = {
			agreeToNotice = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice"
		}
		local v46

		if s2 == PlayButtonStates.UnplayableOther then
			local v44, v45 = v19(v40, p7, v41)

			if v44 == nil then
				v46 = nil
			elseif v45 then
				v46 = table.clone(v45)
				v46[1] = v44
			else
				v46 = v44
			end
		else
			v46 = nil
		end

		t1.unplayableOtherFallback = v46

		local v47 = v42(t1)

		if (s2 == PlayButtonStates.Playable or s2 == PlayButtonStates.PlayableWithParty or s2 == PlayButtonStates.WaitingForParty) and v36.experienceDetailsNoticeType == ExperienceDetailsNoticeType.InExperiencePurchase then
			return v47.agreeToNotice
		end

		if v37 and v37 ~= "" then
			return v37
		end

		if s2 == PlayButtonStates.UnplayableOther then
			return v47.unplayableOtherFallback
		end

		return nil
	end

	local v48 = nil
	local v49 = nil

	if s2 == PlayButtonStates.UnplayableOther then
		if v37 and v37 ~= "" then
			return v37
		end

		v48, v49 = v19(v40, p7, v41)
	elseif (s2 == PlayButtonStates.Playable or s2 == PlayButtonStates.PlayableWithParty or s2 == PlayButtonStates.WaitingForParty) and v36.experienceDetailsNoticeType == ExperienceDetailsNoticeType.InExperiencePurchase then
		v48 = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice"
	end

	local v51

	if v48 then
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		if u16 == nil then
			u16 = Localization.new(RobloxLocaleId)
			s1 = RobloxLocaleId
		end

		if RobloxLocaleId ~= s1 then
			u16:SetLocale(RobloxLocaleId)
			s1 = RobloxLocaleId
		end

		v51 = u16:Format(v48, v49)

		if v51 then
			return v51
		end
	end

	v51 = nil

	return v51
end
