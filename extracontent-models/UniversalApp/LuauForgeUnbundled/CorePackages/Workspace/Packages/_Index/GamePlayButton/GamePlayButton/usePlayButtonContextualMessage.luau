local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").getAppFeaturePolicies
local launchErrorLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameLaunch").LaunchErrorLocalizationKeys
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useSelector
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameHydrationReact")
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableGameJoinEarlyAccess
local useGameProductInfoSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameProductInfoRodux").useGameProductInfoSelector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").useAppPolicy
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization
local experienceDetailsNoticeType = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").ExperienceDetailsNoticeType

local function fn(rootPlaceId, p2, p3)
	if not p2 then
		return nil
	end

	if
		rootPlaceId == nil
		or (p2.playabilityStatus == playabilityStatusEnum.PurchaseRequired or p2.playabilityStatus == playabilityStatusEnum.FiatPurchaseRequired)
		and (p3 == nil or p3.isForSale == false)
	then
		return "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
	end

	if p2.playabilityStatus == playabilityStatusEnum.DeviceRestricted then
		local v5 = getAppFeaturePolicies().getPlatformDisplayName() or ""

		if v5 ~= "" then
			return "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedCustom", {
				device = v5
			}
		end
	end

	return launchErrorLocalizationKeys[p2.playabilityStatus]
end

return function(p2, p3, p4)
	local v5 = useAppPolicy(function(p5)
		return {
			experienceDetailsNoticeType = p5.getExperienceDetailsNoticeType()
		}
	end)

	local v6 = useSelector(function(p5)
		return p5.PlayabilityStatus
			and p5.PlayabilityStatus[p2]
			and p5.PlayabilityStatus[p2].unplayableDisplayText
			or nil
	end)

	local v7 = useSelector(function(p5)
		return p5.GameDetails[p2]
	end)

	local v8 = GameHydrationReact.useGameInfo(p2)
	local rootPlaceId = v7 and v7.rootPlaceId or v8 and v8.rootPlaceId or nil

	local v9 = useGameProductInfoSelector(p2)
	local v12

	if p3 == PlayButtonStates.UnplayableOther then
		local v13, v14 = fn(rootPlaceId, p4, v9)

		if v13 ~= nil then
			if v14 then
				v12 = table.clone(v14)
				v12[1] = v13
			else
				v12 = v13
			end
		end
	end

	local v13 = useLocalization({
		agreeToNotice = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice",
		unplayableOtherFallback = v12
	})

	if
		(p3 == PlayButtonStates.Playable or p3 == PlayButtonStates.PlayableWithParty or p3 == PlayButtonStates.WaitingForParty)
		and v5.experienceDetailsNoticeType == experienceDetailsNoticeType.InExperiencePurchase
	then
		return v13.agreeToNotice
	end

	if
		fFlagEnableGameJoinEarlyAccess
		and p4 ~= nil
		and p4.playabilityStatus == playabilityStatusEnum.PlusSubscriptionRequired
	then
		return nil
	end

	if v6 and v6 ~= "" then
		return v6
	end

	if p3 == PlayButtonStates.UnplayableOther then
		return v13.unplayableOtherFallback
	end

	return nil
end
