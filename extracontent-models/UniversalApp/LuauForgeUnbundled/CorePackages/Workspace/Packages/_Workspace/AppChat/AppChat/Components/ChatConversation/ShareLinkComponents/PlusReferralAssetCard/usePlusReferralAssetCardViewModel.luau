local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local AssetCardTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/AssetCardView/AssetCardTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")
local loadFoundationCloudAsset = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/loadFoundationCloudAsset")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId

local fIntPlusReferralRewardRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FIntPlusReferralRewardRobux

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry
local FFlagAppChatPlusReferralHideSenderJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralHideSenderJoin")
local FFlagAppChatPlusReferralLargerPictogram = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPlusReferralLargerPictogram")

local function usePlusReferralAssetCardViewModel(data)
	local v5 = React.useMemo(function()
		local v6 = loadFoundationCloudAsset("pictograms/plus_robux")
		return Content.fromUri(v6)
	end, {})

	local v6 = useLocalization({
		title = {
			"Feature.RobloxSubscription.Heading.ReferralRecipientEntry",
			amount = tostring(fIntPlusReferralRewardRobux)
		},
		join = "Feature.Chat.Drawer.Join"
	})

	local v7 = useIsInExperience()
	local v8 = if FFlagAppChatPlusReferralHideSenderJoin then useLocalUserId() else nil
	local v9 = FFlagAppChatPlusReferralHideSenderJoin and tostring(v8) == data.referrerId
	local referrerId = data.referrerId
	local v10 = React.useCallback(function()
		local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxSubscriptionPurchaseApp")
		local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase

		local plusReferralLandingSheet = RobloxSubscriptionPurchaseApp.SurfaceName.PlusReferralLandingSheet

		local v14 = if v7 then RobloxSubscriptionPurchaseApp.SurfaceContext.InGame else RobloxSubscriptionPurchaseApp.SurfaceContext.InApp
		initiateRobloxSubscriptionPurchase(
			nil,
			nil,
			nil,
			plusReferralLandingSheet,
			v14,
			nil,
			fFlagEnablePlusReferralEntrypointTelemetry and {
				entrypoint = RobloxSubscriptionPurchaseApp.Entrypoint.AppChat
			} or nil,
			(tonumber(referrerId))
		)
	end, { referrerId, v7 })
	local v11 = if not v9 then v10 else nil
	return React.useMemo(function()
		return {
			status = AssetCardTypes.Status.Ready,
			groupShape = data.groupShape,
			mediaRef = data.mediaRef,
			media = {
				image = v5,
				aspectRatio = 1,
				isPictogram = true,
				pictogramScale = FFlagAppChatPlusReferralLargerPictogram and 1 or nil,
				onActivated = v11,
				isSelectable = not v9
			},
			footer = {
				titleText = v6.title,
				titleMaxLines = 2,
				onActivated = v11,
				action = not v9 and {
					label = v6.join,
					onActivated = v10,
					isSelectable = false
				} or nil
			}
		}
	end, { data.groupShape, data.mediaRef, v5, v6.title, v6.join, v10, v9, v11 })
end

return usePlusReferralAssetCardViewModel
