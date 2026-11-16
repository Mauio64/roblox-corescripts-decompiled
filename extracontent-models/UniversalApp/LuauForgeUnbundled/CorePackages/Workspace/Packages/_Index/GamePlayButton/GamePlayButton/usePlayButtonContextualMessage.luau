local PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates")
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").PlayabilityStatusEnum
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").getAppFeaturePolicies
local launchErrorLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameLaunch").LaunchErrorLocalizationKeys
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useSelector
local useGameInfosSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameInfosRodux").useGameInfosSelector
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameHydrationReact")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagMigrateGameInfoToStore
local fFlagEnableGameJoinEarlyAccess = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnableGameJoinEarlyAccess
local useGameProductInfoSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameProductInfoRodux").useGameProductInfoSelector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/UniversalAppPolicy").useAppPolicy
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization
local experienceDetailsNoticeType = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryTypes").ExperienceDetailsNoticeType

local function fn(p2, p3, p4)
	if not p3 then
		return nil
	end

	if
		p2 == nil
		or (p3.playabilityStatus == playabilityStatusEnum.PurchaseRequired or p3.playabilityStatus == playabilityStatusEnum.FiatPurchaseRequired)
		and (p4 == nil or p4.isForSale == false)
	then
		return "Feature.ExperienceDetails.UnplayableError.UnplayableOther"
	end

	if p3.playabilityStatus == playabilityStatusEnum.DeviceRestricted then
		local v5 = getAppFeaturePolicies().getPlatformDisplayName() or ""

		if v5 ~= "" then
			return "Feature.ExperienceDetails.UnplayableError.DeviceRestrictedCustom", {
				device = v5
			}
		end
	end

	return launchErrorLocalizationKeys[p3.playabilityStatus]
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

	local v8 = nil
	local v9 = nil

	if fFlagMigrateGameInfoToStore then
		v9 = GameHydrationReact.useGameInfo(p2)
	else
		v8 = useGameInfosSelector(p2)
	end

	local v10 = v7 and v7.rootPlaceId

	if not v10 then
		v10 = (if fFlagMigrateGameInfoToStore then v9 and v9.rootPlaceId else v8 and v8.placeId) or nil
	end

	local v11 = useGameProductInfoSelector(p2)
	local v14

	if p3 == PlayButtonStates.UnplayableOther then
		local v15, v16 = fn(v10, p4, v11)

		if v15 ~= nil then
			if v16 then
				v14 = table.clone(v16)
				v14[1] = v15
			else
				v14 = v15
			end
		end
	end

	local v15 = useLocalization({
		agreeToNotice = "Feature.ExperienceDetails.PlayButtonMessage.AgreeToNotice",
		unplayableOtherFallback = v14
	})

	if
		(p3 == PlayButtonStates.Playable or p3 == PlayButtonStates.PlayableWithParty or p3 == PlayButtonStates.WaitingForParty)
		and v5.experienceDetailsNoticeType == experienceDetailsNoticeType.InExperiencePurchase
	then
		return v15.agreeToNotice
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
		return v15.unplayableOtherFallback
	end

	return nil
end
