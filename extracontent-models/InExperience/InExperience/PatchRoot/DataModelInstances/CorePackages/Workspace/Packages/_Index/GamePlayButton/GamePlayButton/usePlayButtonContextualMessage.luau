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
local GameInfosRodux = require(parent.GameInfosRodux)
local useGameInfosSelector = GameInfosRodux.useGameInfosSelector
local GameHydrationReact = require(parent.GameHydrationReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableGameJoinEarlyAccess = SharedFlags2.FFlagEnableGameJoinEarlyAccess
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local useGameProductInfoSelector = GameProductInfoRodux.useGameProductInfoSelector
local UniversalAppPolicy2 = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy2.useAppPolicy
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local DiscoveryTypes2 = require(parent.DiscoveryTypes)
local ExperienceDetailsNoticeType = DiscoveryTypes2.ExperienceDetailsNoticeType

local function fn(p, p2, p3)
	if not p2 then
		return nil
	end

	if
		p == nil
		or (p2.playabilityStatus == PlayabilityStatusEnum.PurchaseRequired or p2.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseRequired)
		and (p3 == nil or p3.isForSale == false)
	then
		return "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
	end

	if p2.playabilityStatus == PlayabilityStatusEnum.DeviceRestricted then
		local device = getAppFeaturePolicies().getPlatformDisplayName() or ""

		if device ~= "" then
			return "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedCustom", {
				device = device
			}
		end
	end

	return LaunchErrorLocalizationKeys[p2.playabilityStatus]
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

	local v4 = nil
	local v5 = nil

	if FFlagMigrateGameInfoToStore then
		v5 = GameHydrationReact.useGameInfo(p)
	else
		v4 = useGameInfosSelector(p)
	end

	local v6 = v3 and v3.rootPlaceId

	if not v6 then
		local v7

		if FFlagMigrateGameInfoToStore then
			v7 = v5 and v5.rootPlaceId
		else
			v7 = v4 and v4.placeId
		end

		v6 = v7 or nil
	end

	local v7 = useGameProductInfoSelector(p)
	local unplayableOtherFallback

	if p2 == PlayButtonStates.UnplayableOther then
		local v8, v9 = fn(v6, p3, v7)

		if v8 ~= nil then
			if v9 then
				unplayableOtherFallback = table.clone(v9)
				unplayableOtherFallback[1] = v8
			else
				unplayableOtherFallback = v8
			end
		end
	end

	local v8 = useLocalization({
		agreeToNotice = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice",
		unplayableOtherFallback = unplayableOtherFallback
	})

	if
		(p2 == PlayButtonStates.Playable or p2 == PlayButtonStates.PlayableWithParty or p2 == PlayButtonStates.WaitingForParty)
		and v.experienceDetailsNoticeType == ExperienceDetailsNoticeType.InExperiencePurchase
	then
		return v8.agreeToNotice
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
		return v8.unplayableOtherFallback
	end

	return nil
end
