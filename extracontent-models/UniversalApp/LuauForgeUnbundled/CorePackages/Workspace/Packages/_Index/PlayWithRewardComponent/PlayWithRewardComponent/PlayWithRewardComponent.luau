local AdService = game:GetService("AdService")
local Players = game:GetService("Players")

local PlayWithRewardBlackoutCurtain = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/PlayWithRewardBlackoutCurtain")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/PlayWithRewardCoachmark")
local PlayWithRewardTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/PlayWithRewardTelemetry")
local shouldRenderPlayWithRewardBanner = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/shouldRenderPlayWithRewardBanner")

local PlayWithRewardState = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/PlayWithRewardState")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/Foundation")
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/GamePlayButton")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/RobloxAppHooks")
local RobloxAppUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/RobloxAppUpdate")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/RoactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/SharedFlags")

local setPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState

local button = Foundation.Button
local enums = Foundation.Enums
local icon = Foundation.Icon
local image = Foundation.Image
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local playButtonReferralSource = GamePlayButton.PlayButtonReferralSource
local usePlayButtonLaunchGame = GamePlayButton.usePlayButtonLaunchGame
local roactAnalytics = RoactServiceTags.RoactAnalytics
local appUpdateService = RoactServiceTags.AppUpdateService
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local handleUpdate = RobloxAppUpdate.HandleUpdate

local engineFeature = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")

local fIntPlayWithRewardFallbackBannerProductImageAssetId = SharedFlags.FIntPlayWithRewardFallbackBannerProductImageAssetId
local defineFastInt = game:DefineFastInt("LuaAppPlayWithRewardMobileEdpLayoutOrder", 120)
local fFlagEnablePlayWithRewardNonPeekviewEdp = SharedFlags.FFlagEnablePlayWithRewardNonPeekviewEdp
local fFlagSduiPlayWithReward = SharedFlags.FFlagSduiPlayWithReward
local fFlagLuaAppEnableContainedRewardUi = PlayWithRewardState.FFlagLuaAppEnableContainedRewardUi

function LUAUFORGE_MODULE_GLOBALS_cLq_PlayWithRewardComponent(props)
	local v5 = useTokens()
	local v6 = useRoactService(roactAnalytics)
	local v7 = useRoactService(appUpdateService)
	local v8 = useDispatch()
	local localPlayer = Players.LocalPlayer
	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)

	local playWithRewardAdData = props.playWithRewardAdData
	local productId = playWithRewardAdData and playWithRewardAdData.productId or ""

	local variantId = playWithRewardAdData
		and playWithRewardAdData.experimentVariantData
		and playWithRewardAdData.experimentVariantData.variantId
		or ""

	local v9 = not (props.flowId == "") and props.isAdDataExpected
	local v10

	if fFlagEnablePlayWithRewardNonPeekviewEdp then
		v10 = shouldRenderPlayWithRewardBanner(props.universeId, props.flowId, props.fetchedUniverseId, props.playWithRewardAdData)
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
		v10 = false
	else
		v10 = (tonumber(productId) or 0) ~= 0
	end

	local placeIdOverride = props.placeIdOverride or props.placeId
	local v11 = usePlayButtonLaunchGame(
		props.universeId,
		placeIdOverride,
		props.placeId,
		playButtonReferralSource.PlayWithReward,
		"PlayWithRewardGameDetails",
		"PlayWithRewardButton",
		props.experienceJoinData
	)

	React.useEffect(function()
		if v10 then
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
	end, { v10, props.flowId, props.universeId, productId, variantId })

	local v12 = not playWithRewardAdData and "" or playWithRewardAdData.productName
	local v13 = not playWithRewardAdData and "" or playWithRewardAdData.productImageAssetId
	local v14 = v13 == ""
	local v15 = React.useCallback(function()
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
				v8(setPlayWithRewardState(props.flowId, props.universeId, false, nil))
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
				local v17 = success and result ~= nil
				local v18 = result == Enum.ShowAdResult.ShowCompleted

				local v20 = if v14 then fIntPlayWithRewardFallbackBannerProductImageAssetId else tonumber(v13) or fIntPlayWithRewardFallbackBannerProductImageAssetId
				AdService:SubmitAdNotification(universeId, v17, v18, v12, v20)
			end)

			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(
				props.flowId,
				props.universeId,
				"hidden",
				productId
			)

			PlayWithRewardBlackoutCurtain.hide()

			if v11 then
				PlayWithRewardTelemetry.logPlayWithRewardGameJoinInitiated(props.flowId, props.universeId, productId)

				v11(nil)
			end
		end

		handleUpdate(v8, v7, engineFeature, v6, "PlayWithRewardGameDetails", showAdThenLaunch)
	end, {
		props.flowId,
		props.universeId,
		v8,
		v7,
		v6,
		v11,
		v13,
		v12,
		v14,
		productId
	})

	local v16 = fFlagLuaAppEnableContainedRewardUi and (props.useLargerStyles and 108 or 76) or nil
	local v17, v18, v19, v20, v21, v22, v23, flag, v24, v25, v26, v27

	if not fFlagLuaAppEnableContainedRewardUi then
		local v28

		if props.useLargerStyles then
			v17 = v5.Padding.XLarge
			v22 = v5.Padding.XLarge
			v19 = v5.Padding.XLarge
			v28 = v5.Gap.XLarge

			v18 = v5.Size.Size_1200
			v21 = 98
			v20 = "padding-top-large"
			v23 = "gap-xxsmall"
			flag = true
			v24 = "size-1000-1200"
			v25 = "text-body-medium"
			v26 = "text-heading-small"
		else
			v17 = v5.Padding.Medium
			v22 = v5.Padding.Small
			v19 = v5.Padding.Medium
			v28 = v5.Gap.Medium

			v18 = v5.Size.Size_1000
			v21 = 66
			v20 = "padding-top-medium"
			v23 = ""
			flag = false
			v24 = "size-800-1000"
			v25 = "text-body-small"
			v26 = "text-title-medium"
		end

		v27 = v22 + v21 + v28
	end

	local v28 = if fFlagSduiPlayWithReward then props.layoutOrder or defineFastInt else defineFastInt

	if v9 then
		local createElement = React.createElement

		if fFlagLuaAppEnableContainedRewardUi then
			v20 = nil
		end

		local newUDim2 = UDim2.new

		if not fFlagLuaAppEnableContainedRewardUi then
			v16 = v18 + v17 * 2 + v19
		end

		return createElement(skeleton, {
			tag = v20,
			Size = newUDim2(1, 0, 0, v16),
			LayoutOrder = v28
		})
	else
		if not v10 then
			return nil
		end

		local titleText = playWithRewardAdData.experimentVariantData.titleText
		local subtitleText = playWithRewardAdData.experimentVariantData.subtitleText
		local buttonText = playWithRewardAdData.experimentVariantData.buttonText
		local coachmarkTitleText = playWithRewardAdData.experimentVariantData.coachmarkTitleText
		local coachmarkSubtitleText = playWithRewardAdData.experimentVariantData.coachmarkSubtitleText
		local showButton = playWithRewardAdData.experimentVariantData.showButton

		local keepRewardContained = fFlagLuaAppEnableContainedRewardUi
			and playWithRewardAdData.experimentVariantData.keepRewardContained
		local v29 = not localPlayer and 0 or localPlayer.UserId
		local v30 = not (coachmarkTitleText == "") and coachmarkSubtitleText ~= ""

		if fFlagLuaAppEnableContainedRewardUi then
			local v31

			if props.useLargerStyles then
				v21 = keepRewardContained and 76 or 98
				v17 = if keepRewardContained then v5.Padding.Large else v5.Padding.XLarge
				v22 = v5.Padding.XLarge
				v19 = v5.Padding.XLarge
				v31 = v5.Gap.XLarge
				v23 = "gap-xxsmall"
				flag = true
				v24 = "size-1000-1200"
				v25 = "text-body-medium"
				v26 = keepRewardContained and "text-title-large" or "text-heading-small"
				v20 = "padding-top-large"
			else
				v21 = keepRewardContained and 60 or 66
				v17 = if keepRewardContained then v5.Padding.Small else v5.Padding.Medium
				v22 = v5.Padding.Small
				v19 = v5.Padding.Medium
				v31 = v5.Gap.Medium
				v23 = ""
				flag = false
				v24 = "size-800-1000"
				v25 = "text-body-small"
				v26 = "text-title-medium"
				v20 = "padding-top-medium"
			end

			v27 = v22 + v21 + v31
		end

		local v31

		if v14 then
			local createElement = React.createElement
			local v33 = {
				name = enums.IconName.GiftBox,
				size = v21,
				Position = 0,
				ZIndex = 2
			}

			local v34 = if not keepRewardContained then UDim2.fromOffset(v22, -v19) else nil
			v33.Position = v34
			v31 = createElement(icon, v33)
		else
			local createElement = React.createElement
			local v33 = {
				Size = UDim2.fromOffset(v21, v21),
				Position = 0,
				Image = 0,
				BackgroundTransparency = 1,
				ZIndex = 2
			}
			local v34 = if not keepRewardContained then UDim2.fromOffset(v22, -v19) else nil
			v33.Position = v34
			v33.Image = "rbxassetid://" .. v13
			v31 = createElement(image, v33)
		end

		local createElement = React.createElement
		local v33 = {
			tag = keepRewardContained and "size-full-0 auto-y" or `size-full-0 auto-y {v20}`,
			LayoutOrder = v28
		}

		local createElement2 = React.createElement

		local v38 = {
			ProductImage = if not keepRewardContained then v31 else nil,
			ContentView = 0
		}

		local createElement3 = React.createElement
		local v41 = {
			tag = "row align-y-center gap-medium size-full-0 auto-y",
			padding = not keepRewardContained and {
				left = UDim.new(0, v27),
				top = UDim.new(0, v17),
				right = UDim.new(0, v17),
				bottom = UDim.new(0, v17)
			} or v17
		}

		if not keepRewardContained then
			v31 = nil
		end

		local createElement4 = React.createElement
		local v44 = { tag = `col fill auto-y {v23}`, LayoutOrder = 1 }

		local v46 = if titleText ~= "" then React.createElement(text, {
			tag = `auto-xy text-wrap text-align-x-left content-emphasis {v26}`,
			Text = titleText,
			LayoutOrder = 1
		}) else nil

		local v47 = if subtitleText ~= "" then React.createElement(text, {
			tag = `auto-xy text-wrap text-align-x-left content-emphasis {v25}`,
			Text = subtitleText,
			LayoutOrder = 2
		}) else nil
		local v42 = {
			ContainedProductImage = v31,
			TextContainer = createElement4(view, v44, {
				RewardTitle = v46,
				RewardDescription = v47
			}),
			ClickableIndicator = 0
		}
		local v48

		if showButton then
			local createElement5 = React.createElement
			local v50 = {
				text = buttonText,
				onActivated = v15,
				variant = enums.ButtonVariant.SoftEmphasis,
				size = 0,
				LayoutOrder = 2
			}

			local v51 = if flag then enums.InputSize.Large else enums.InputSize.Medium
			v50.size = v51
			v48 = createElement5(button, v50)
		else
			local createElement5 = React.createElement
			local v50 = {
				tag = `align-x-center align-y-center {v24}`,
				LayoutOrder = 2
			}

			local createElement6 = React.createElement
			local v53 = {
				name = enums.IconName.ChevronLargeRight,
				style = v5.Color.Content.Emphasis,
				size = 0
			}

			local v54 = if flag then enums.IconSize.Large else enums.IconSize.Medium
			v53.size = v54
			v48 = createElement5(view, v50, { Icon = createElement6(icon, v53) })
		end

		v42.ClickableIndicator = v48
		v38.ContentView = createElement3(view, v41, v42)
		local v34 = {
			Banner = createElement2(view, {
				tag = "size-full-0 auto-y radius-medium no-clip bg-shift-300",
				onActivated = if not showButton then v15 else nil,
				ref = ref
			}, v38),
			PlayWithRewardCoachmark = 0
		}

		local v49 = if v30 then React.createElement(module2, {
			anchorRef = ref,
			flowId = props.flowId,
			localUserId = v29,
			productId = productId,
			title = coachmarkTitleText,
			text = coachmarkSubtitleText,
			universeId = props.universeId
		}) else nil
		v34.PlayWithRewardCoachmark = v49
		return createElement(view, v33, v34)
	end
end

return LUAUFORGE_MODULE_GLOBALS_cLq_PlayWithRewardComponent
