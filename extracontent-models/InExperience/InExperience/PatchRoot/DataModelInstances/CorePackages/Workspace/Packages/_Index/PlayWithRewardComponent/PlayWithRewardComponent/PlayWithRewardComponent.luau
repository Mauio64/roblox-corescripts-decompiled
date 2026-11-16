local AdService = game:GetService("AdService")
local Players = game:GetService("Players")

local playWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local PlayWithRewardBlackoutCurtain = require(playWithRewardComponent.PlayWithRewardBlackoutCurtain)
local PlayWithRewardCoachmark = require(playWithRewardComponent.PlayWithRewardCoachmark)
local PlayWithRewardTelemetry = require(playWithRewardComponent.PlayWithRewardTelemetry)
local shouldRenderPlayWithRewardBanner = require(playWithRewardComponent.shouldRenderPlayWithRewardBanner)

local parent = playWithRewardComponent.Parent
local PlayWithRewardState = require(parent.PlayWithRewardState)
local Foundation = require(parent.Foundation)
local GamePlayButton = require(parent.GamePlayButton)
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppUpdate = require(parent.RobloxAppUpdate)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)

local SetPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState

local Button = Foundation.Button
local Enums = Foundation.Enums
local Icon = Foundation.Icon
local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local PlayButtonReferralSource = GamePlayButton.PlayButtonReferralSource
local usePlayButtonLaunchGame = GamePlayButton.usePlayButtonLaunchGame
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppUpdateService = RoactServiceTags.AppUpdateService
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local HandleUpdate = RobloxAppUpdate.HandleUpdate

local engineFeature = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")

local FIntPlayWithRewardFallbackBannerProductImageAssetId = SharedFlags.FIntPlayWithRewardFallbackBannerProductImageAssetId
local defineFastInt = game:DefineFastInt("LuaAppPlayWithRewardMobileEdpLayoutOrder", 120)
local FFlagEnablePlayWithRewardNonPeekviewEdp = SharedFlags.FFlagEnablePlayWithRewardNonPeekviewEdp
local FFlagSduiPlayWithReward = SharedFlags.FFlagSduiPlayWithReward
local FFlagLuaAppEnableContainedRewardUi = PlayWithRewardState.FFlagLuaAppEnableContainedRewardUi

function PlayWithRewardComponent(props)
	local v = useTokens()
	local v2 = useRoactService(RoactAnalytics)
	local v3 = useRoactService(AppUpdateService)
	local v4 = useDispatch()
	local localPlayer = Players.LocalPlayer
	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)

	local playWithRewardAdData = props.playWithRewardAdData
	local productId = playWithRewardAdData and playWithRewardAdData.productId or ""

	local variantId = playWithRewardAdData
		and playWithRewardAdData.experimentVariantData
		and playWithRewardAdData.experimentVariantData.variantId
		or ""

	local v5 = not (props.flowId == "") and props.isAdDataExpected
	local v6

	if FFlagEnablePlayWithRewardNonPeekviewEdp then
		v6 = shouldRenderPlayWithRewardBanner(
			props.universeId,
			props.flowId,
			props.fetchedUniverseId,
			props.playWithRewardAdData
		)
	elseif
		localPlayer == nil
		or props.flowId == ""
		or props.fetchedUniverseId == nil
		or props.fetchedUniverseId ~= props.universeId
		or playWithRewardAdData == nil
		or playWithRewardAdData.adAvailabilityResult ~= Enum.AdAvailabilityResult.IsAvailable
		or playWithRewardAdData.experimentVariantData == nil
		or playWithRewardAdData.experimentVariantData.titleText == ""
		and playWithRewardAdData.experimentVariantData.subtitleText == ""
	then
		v6 = false
	else
		v6 = (tonumber(productId) or 0) ~= 0
	end

	local placeIdOverride = props.placeIdOverride or props.placeId
	local v7 = usePlayButtonLaunchGame(
		props.universeId,
		placeIdOverride,
		props.placeId,
		PlayButtonReferralSource.PlayWithReward,
		"PlayWithRewardGameDetails",
		"PlayWithRewardButton",
		props.experienceJoinData
	)

	React.useEffect(function()
		if v6 then
			ref2.current = true
			PlayWithRewardTelemetry.logPlayWithRewardBannerShown(
				props.flowId,
				props.universeId,
				"startShow",
				productId,
				variantId
			)
		end

		return function()
			if ref2.current then
				ref2.current = false
				PlayWithRewardTelemetry.logPlayWithRewardBannerShown(
					props.flowId,
					props.universeId,
					"endShow",
					productId,
					variantId
				)
			end
		end
	end, { v6, props.flowId, props.universeId, productId, variantId })

	local v8 = not playWithRewardAdData and "" or playWithRewardAdData.productName
	local v9 = not playWithRewardAdData and "" or playWithRewardAdData.productImageAssetId
	local v10 = v9 == ""
	local onActivated = React.useCallback(function()
		local function showAdThenLaunch()
			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(
				props.flowId,
				props.universeId,
				"shown",
				productId
			)

			PlayWithRewardBlackoutCurtain.show()

			PlayWithRewardTelemetry.logPlayWithRewardButtonClicked(props.flowId, props.universeId, productId)

			local success, result = pcall(function()
				v4(SetPlayWithRewardState(props.flowId, props.universeId, false, nil))
				PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackAttempted(props.flowId, props.universeId, productId)

				return AdService:ShowRewardedVideoAdAtClientAsync(props.universeId)
			end)

			pcall(function()
				PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackStopped(
					props.flowId,
					props.universeId,
					tostring(result),
					productId
				)

				local universeId = tonumber(props.universeId) or 0
				local v11 = success and result ~= nil
				local v12 = result == Enum.ShowAdResult.ShowCompleted
				local v13

				if v10 then
					v13 = FIntPlayWithRewardFallbackBannerProductImageAssetId
				else
					v13 = tonumber(v9) or FIntPlayWithRewardFallbackBannerProductImageAssetId
				end

				AdService:SubmitAdNotification(universeId, v11, v12, v8, v13)
			end)

			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(
				props.flowId,
				props.universeId,
				"hidden",
				productId
			)

			PlayWithRewardBlackoutCurtain.hide()

			if v7 then
				PlayWithRewardTelemetry.logPlayWithRewardGameJoinInitiated(props.flowId, props.universeId, productId)

				v7(nil)
			end
		end

		HandleUpdate(v4, v3, engineFeature, v2, "PlayWithRewardGameDetails", showAdThenLaunch)
	end, {
		props.flowId,
		props.universeId,
		v4,
		v3,
		v2,
		v7,
		v9,
		v8,
		v10,
		productId
	})

	local v11 = FFlagLuaAppEnableContainedRewardUi and (props.useLargerStyles and 108 or 76) or nil
	local v12, v13, v14, tag, size, v15, v16, flag, v17, v18, v19, v20

	if not FFlagLuaAppEnableContainedRewardUi then
		local v21

		if props.useLargerStyles then
			v12 = v.Padding.XLarge
			v15 = v.Padding.XLarge
			v14 = v.Padding.XLarge
			v21 = v.Gap.XLarge

			v13 = v.Size.Size_1200
			size = 98
			tag = "padding-top-large"
			v16 = "gap-xxsmall"
			flag = true
			v17 = "size-1000-1200"
			v18 = "text-body-medium"
			v19 = "text-heading-small"
		else
			v12 = v.Padding.Medium
			v15 = v.Padding.Small
			v14 = v.Padding.Medium
			v21 = v.Gap.Medium

			v13 = v.Size.Size_1000
			size = 66
			tag = "padding-top-medium"
			v16 = ""
			flag = false
			v17 = "size-800-1000"
			v18 = "text-body-small"
			v19 = "text-title-medium"
		end

		v20 = v15 + size + v21
	end

	local layoutOrder

	if FFlagSduiPlayWithReward then
		layoutOrder = props.layoutOrder or defineFastInt
	else
		layoutOrder = defineFastInt
	end

	if v5 then
		local createElement = React.createElement

		if FFlagLuaAppEnableContainedRewardUi then
			tag = nil
		end

		if not FFlagLuaAppEnableContainedRewardUi then
			v11 = v13 + v12 * 2 + v14
		end

		return createElement(Skeleton, {
			tag = tag,
			Size = UDim2.new(1, 0, 0, v11),
			LayoutOrder = layoutOrder
		})
	else
		if not v6 then
			return nil
		end

		local titleText = playWithRewardAdData.experimentVariantData.titleText
		local subtitleText = playWithRewardAdData.experimentVariantData.subtitleText
		local buttonText = playWithRewardAdData.experimentVariantData.buttonText
		local coachmarkTitleText = playWithRewardAdData.experimentVariantData.coachmarkTitleText
		local coachmarkSubtitleText = playWithRewardAdData.experimentVariantData.coachmarkSubtitleText
		local showButton = playWithRewardAdData.experimentVariantData.showButton

		local keepRewardContained = FFlagLuaAppEnableContainedRewardUi
			and playWithRewardAdData.experimentVariantData.keepRewardContained
		local localUserId = not localPlayer and 0 or localPlayer.UserId
		local v21

		if coachmarkTitleText == "" then
			v21 = false
		else
			v21 = coachmarkSubtitleText ~= ""
		end

		if FFlagLuaAppEnableContainedRewardUi then
			local v22

			if props.useLargerStyles then
				size = keepRewardContained and 76 or 98

				if keepRewardContained then
					v12 = v.Padding.Large
				else
					v12 = v.Padding.XLarge
				end

				v15 = v.Padding.XLarge
				v14 = v.Padding.XLarge
				v22 = v.Gap.XLarge
				v16 = "gap-xxsmall"
				flag = true
				v17 = "size-1000-1200"
				v18 = "text-body-medium"
				v19 = keepRewardContained and "text-title-large" or "text-heading-small"
				tag = "padding-top-large"
			else
				size = keepRewardContained and 60 or 66

				if keepRewardContained then
					v12 = v.Padding.Small
				else
					v12 = v.Padding.Medium
				end

				v15 = v.Padding.Small
				v14 = v.Padding.Medium
				v22 = v.Gap.Medium
				v16 = ""
				flag = false
				v17 = "size-800-1000"
				v18 = "text-body-small"
				v19 = "text-title-medium"
				tag = "padding-top-medium"
			end

			v20 = v15 + size + v22
		end

		local containedProductImage

		if v10 then
			local createElement = React.createElement
			local v22 = { name = Enums.IconName.GiftBox, size = size, Position = 0, ZIndex = 2 }
			local position

			if not keepRewardContained then
				position = UDim2.fromOffset(v15, -v14)
			end

			v22.Position = position
			containedProductImage = createElement(Icon, v22)
		else
			local createElement = React.createElement
			local v22 = {
				Size = UDim2.fromOffset(size, size),
				Position = 0,
				Image = 0,
				BackgroundTransparency = 1,
				ZIndex = 2
			}
			local position

			if not keepRewardContained then
				position = UDim2.fromOffset(v15, -v14)
			end

			v22.Position = position
			v22.Image = "rbxassetid://" .. v9
			containedProductImage = createElement(Image, v22)
		end

		local createElement = React.createElement
		local v22 = {
			tag = keepRewardContained and "size-full-0 auto-y" or `size-full-0 auto-y {tag}`,
			LayoutOrder = layoutOrder
		}

		local createElement2 = React.createElement
		local onActivated2

		if not showButton then
			onActivated2 = onActivated
		end

		local productImage

		if not keepRewardContained then
			productImage = containedProductImage
		end

		local createElement3 = React.createElement
		local v23 = {
			tag = "row align-y-center gap-medium size-full-0 auto-y",
			padding = not keepRewardContained and {
				left = UDim.new(0, v20),
				top = UDim.new(0, v12),
				right = UDim.new(0, v12),
				bottom = UDim.new(0, v12)
			} or v12
		}

		if not keepRewardContained then
			containedProductImage = nil
		end

		local createElement4 = React.createElement
		local v24 = { tag = `col fill auto-y {v16}`, LayoutOrder = 1 }
		local rewardTitle

		if titleText ~= "" then
			rewardTitle = React.createElement(Text, {
				tag = `auto-xy text-wrap text-align-x-left content-emphasis {v19}`,
				Text = titleText,
				LayoutOrder = 1
			})
		end

		local rewardDescription

		if subtitleText ~= "" then
			rewardDescription = React.createElement(Text, {
				tag = `auto-xy text-wrap text-align-x-left content-emphasis {v18}`,
				Text = subtitleText,
				LayoutOrder = 2
			})
		end

		local v25 = {
			ContainedProductImage = containedProductImage,
			TextContainer = createElement4(View, v24, {
				RewardTitle = rewardTitle,
				RewardDescription = rewardDescription
			}),
			ClickableIndicator = 0
		}
		local clickableIndicator

		if showButton then
			local createElement5 = React.createElement
			local v26 = {
				text = buttonText,
				onActivated = onActivated,
				variant = Enums.ButtonVariant.SoftEmphasis,
				size = 0,
				LayoutOrder = 2
			}
			local size2

			if flag then
				size2 = Enums.InputSize.Large
			else
				size2 = Enums.InputSize.Medium
			end

			v26.size = size2
			clickableIndicator = createElement5(Button, v26)
		else
			local createElement5 = React.createElement
			local v26 = {
				tag = `align-x-center align-y-center {v17}`,
				LayoutOrder = 2
			}

			local createElement6 = React.createElement
			local v27 = {
				name = Enums.IconName.ChevronLargeRight,
				style = v.Color.Content.Emphasis,
				size = 0
			}
			local size2

			if flag then
				size2 = Enums.IconSize.Large
			else
				size2 = Enums.IconSize.Medium
			end

			v27.size = size2
			clickableIndicator = createElement5(View, v26, { Icon = createElement6(Icon, v27) })
		end

		v25.ClickableIndicator = clickableIndicator
		local v26 = {
			Banner = createElement2(
				View,
				{
					tag = "size-full-0 auto-y radius-medium no-clip bg-shift-300",
					onActivated = onActivated2,
					ref = ref
				},
				{ ProductImage = productImage, ContentView = createElement3(View, v23, v25) }
			),
			PlayWithRewardCoachmark = 0
		}
		local playWithRewardCoachmark

		if v21 then
			playWithRewardCoachmark = React.createElement(PlayWithRewardCoachmark, {
				anchorRef = ref,
				flowId = props.flowId,
				localUserId = localUserId,
				productId = productId,
				title = coachmarkTitleText,
				text = coachmarkSubtitleText,
				universeId = props.universeId
			})
		end

		v26.PlayWithRewardCoachmark = playWithRewardCoachmark
		return createElement(View, v22, v26)
	end
end

return PlayWithRewardComponent
