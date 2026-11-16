local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AssetCardTypes = require(AppChat.Components.ChatConversation.AssetCardView.AssetCardTypes)
require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)
local loadFoundationCloudAsset = require(AppChat.Utils.loadFoundationCloudAsset)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local SharedFlags = require(parent.SharedFlags)
local FIntPlusReferralRewardRobux = SharedFlags.FIntPlusReferralRewardRobux

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePlusReferralEntrypointTelemetry = SharedFlags2.FFlagEnablePlusReferralEntrypointTelemetry
local FFlagAppChatPlusReferralHideSenderJoin = require(AppChat.Flags.FFlagAppChatPlusReferralHideSenderJoin)
local FFlagAppChatPlusReferralLargerPictogram = require(AppChat.Flags.FFlagAppChatPlusReferralLargerPictogram)

local function usePlusReferralAssetCardViewModel(data)
	local image = React.useMemo(function()
		local v = loadFoundationCloudAsset("pictograms/plus_robux")
		return Content.fromUri(v)
	end, {})

	local v = useLocalization({
		title = {
			"Feature.RobloxSubscription.Heading.ReferralRecipientEntry",
			amount = tostring(FIntPlusReferralRewardRobux)
		},
		join = "Feature.Chat.Drawer.Join"
	})

	local v2 = useIsInExperience()
	local v3

	if FFlagAppChatPlusReferralHideSenderJoin then
		v3 = useLocalUserId()
	end

	local v4 = FFlagAppChatPlusReferralHideSenderJoin and tostring(v3) == data.referrerId
	local referrerId = data.referrerId
	local onActivated = React.useCallback(function()
		local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
		local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase

		local plusReferralLandingSheet = RobloxSubscriptionPurchaseApp.SurfaceName.PlusReferralLandingSheet
		local v5

		if v2 then
			v5 = RobloxSubscriptionPurchaseApp.SurfaceContext.InGame
		else
			v5 = RobloxSubscriptionPurchaseApp.SurfaceContext.InApp
		end

		initiateRobloxSubscriptionPurchase(
			nil,
			nil,
			nil,
			plusReferralLandingSheet,
			v5,
			nil,
			FFlagEnablePlusReferralEntrypointTelemetry and {
				entrypoint = RobloxSubscriptionPurchaseApp.Entrypoint.AppChat
			} or nil,
			(tonumber(referrerId))
		)
	end, { referrerId, v2 })
	local onActivated2

	if v4 then
		onActivated2 = nil
	else
		onActivated2 = onActivated
	end

	return React.useMemo(function()
		return {
			status = AssetCardTypes.Status.Ready,
			groupShape = data.groupShape,
			mediaRef = data.mediaRef,
			media = {
				image = image,
				aspectRatio = 1,
				isPictogram = true,
				pictogramScale = FFlagAppChatPlusReferralLargerPictogram and 1 or nil,
				onActivated = onActivated2,
				isSelectable = not v4
			},
			footer = {
				titleText = v.title,
				titleMaxLines = 2,
				onActivated = onActivated2,
				action = not v4 and {
					label = v.join,
					onActivated = onActivated,
					isSelectable = false
				} or nil
			}
		}
	end, { data.groupShape, data.mediaRef, image, v.title, v.join, onActivated, v4, onActivated2 })
end

return usePlusReferralAssetCardViewModel
