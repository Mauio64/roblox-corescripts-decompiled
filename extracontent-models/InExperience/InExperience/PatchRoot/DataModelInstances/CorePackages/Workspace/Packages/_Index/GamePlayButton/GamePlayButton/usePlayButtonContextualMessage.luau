local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local parent = GamePlayButton.Parent
local PlayButtonStates = require(GamePlayButton.PlayButtonStates)
require(parent.PlayabilityRodux)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local GameLaunch = require(parent.GameLaunch)
local LaunchErrorLocalizationKeys = GameLaunch.LaunchErrorLocalizationKeys
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local GameHydrationReact = require(parent.GameHydrationReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local useGameProductInfoSelector = GameProductInfoRodux.useGameProductInfoSelector
local UniversalAppPolicy2 = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy2.useAppPolicy
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local DiscoveryTypes2 = require(parent.DiscoveryTypes)
local ExperienceDetailsNoticeType = DiscoveryTypes2.ExperienceDetailsNoticeType

local function fn(rootPlaceId, p, p2)
	if not p then
		return nil
	end

	if
		rootPlaceId == nil
		or (p.playabilityStatus == PlayabilityStatusEnum.PurchaseRequired or p.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseRequired)
		and (p2 == nil or p2.isForSale == false)
	then
		return "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
	end

	if p.playabilityStatus == PlayabilityStatusEnum.DeviceRestricted then
		local device = getAppFeaturePolicies().getPlatformDisplayName() or ""

		if device ~= "" then
			return "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedCustom", {
				device = device
			}
		end
	end

	return LaunchErrorLocalizationKeys[p.playabilityStatus]
end

return function(p, p2: string, p3)
	local v = useAppPolicy(function(p4)
		return {
			experienceDetailsNoticeType = p4.getExperienceDetailsNoticeType()
		}
	end)

	local v2 = useSelector(function(p4)
		return p4.PlayabilityStatus and p4.PlayabilityStatus[p] and p4.PlayabilityStatus[p].unplayableDisplayText or nil
	end)

	local v3 = useSelector(function(p4)
		return p4.GameDetails[p]
	end)

	local v4 = GameHydrationReact.useGameInfo(p)
	local rootPlaceId = v3 and v3.rootPlaceId or v4 and v4.rootPlaceId or nil

	local v5 = useGameProductInfoSelector(p)
	local unplayableOtherFallback

	if p2 == PlayButtonStates.UnplayableOther then
		local v6, v7 = fn(rootPlaceId, p3, v5)

		if v6 ~= nil then
			if v7 then
				unplayableOtherFallback = table.clone(v7)
				unplayableOtherFallback[1] = v6
			else
				unplayableOtherFallback = v6
			end
		end
	end

	local v6 = useLocalization({
		agreeToNotice = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice",
		unplayableOtherFallback = unplayableOtherFallback
	})

	if
		(p2 == PlayButtonStates.Playable or p2 == PlayButtonStates.PlayableWithParty or p2 == PlayButtonStates.WaitingForParty)
		and v.experienceDetailsNoticeType == ExperienceDetailsNoticeType.InExperiencePurchase
	then
		return v6.agreeToNotice
	end

	if
		FFlagEnableGameJoinEarlyAccess
		and p3 ~= nil
		and p3.playabilityStatus == PlayabilityStatusEnum.PlusSubscriptionRequired
	then
		return nil
	end

	if v2 and v2 ~= "" then
		return v2
	end

	if p2 == PlayButtonStates.UnplayableOther then
		return v6.unplayableOtherFallback
	end

	return nil
end
