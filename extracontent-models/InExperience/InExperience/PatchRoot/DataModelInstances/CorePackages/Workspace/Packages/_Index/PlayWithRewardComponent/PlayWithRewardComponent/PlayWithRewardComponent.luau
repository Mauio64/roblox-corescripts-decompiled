local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local PlayWithRewardComponent2 = script:FindFirstAncestor("PlayWithRewardComponent")
local PlayWithRewardBlackoutCurtain = require(PlayWithRewardComponent2.PlayWithRewardBlackoutCurtain)
local PlayWithRewardCoachmark = require(PlayWithRewardComponent2.PlayWithRewardCoachmark)
local PlayWithRewardTelemetry = require(PlayWithRewardComponent2.PlayWithRewardTelemetry)
local shouldRenderPlayWithRewardBanner = require(PlayWithRewardComponent2.shouldRenderPlayWithRewardBanner)
local PlayWithRewardComponent2Parent = PlayWithRewardComponent2.Parent
local PlayWithRewardState = require(PlayWithRewardComponent2Parent.PlayWithRewardState)
local Foundation = require(PlayWithRewardComponent2Parent.Foundation)
local GamePlayButton = require(PlayWithRewardComponent2Parent.GamePlayButton)
local React = require(PlayWithRewardComponent2Parent.React)
local RobloxAppHooks = require(PlayWithRewardComponent2Parent.RobloxAppHooks)
local RobloxAppUpdate = require(PlayWithRewardComponent2Parent.RobloxAppUpdate)
local RoactServiceTags = require(PlayWithRewardComponent2Parent.RoactServiceTags)
local RoactUtils = require(PlayWithRewardComponent2Parent.RoactUtils)
local SharedFlags = require(PlayWithRewardComponent2Parent.SharedFlags)
local SetPlayWithRewardState = PlayWithRewardState.SetPlayWithRewardState
local Button = Foundation.Button
local Enums = Foundation.Enums
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local PlayButtonReferralSource = GamePlayButton.PlayButtonReferralSource
local usePlayButtonLaunchGame = GamePlayButton.usePlayButtonLaunchGame
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppUpdateService = RoactServiceTags.AppUpdateService
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = RobloxAppHooks.useRoactService
local CheckForUpdate = RobloxAppUpdate.Thunks.CheckForUpdate
local EngineFeature = game:GetEngineFeature("AutoUpgradeEngineFeatureOnly")
local EngineFeature2 = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")
local v36 = game:DefineFastInt("PlayWithRewardFallbackBannerProductImageAssetId", 0)
local v37 = game:DefineFastInt("LuaAppPlayWithRewardMobileEdpLayoutOrder", 120)
local FFlagEnablePlayWithRewardNonPeekviewEdp = SharedFlags.FFlagEnablePlayWithRewardNonPeekviewEdp
local FFlagSduiPlayWithReward = SharedFlags.FFlagSduiPlayWithReward
local FFlagLuaAppEnableContainedRewardUi = PlayWithRewardState.FFlagLuaAppEnableContainedRewardUi

function PlayWithRewardComponent(t1: {[any]: any}) -- line: 66
	-- upvalues: useTokens (copy), useRoactService (copy), RoactAnalytics (copy), AppUpdateService (copy), useDispatch (copy), Players (copy), React (copy), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), shouldRenderPlayWithRewardBanner (copy), usePlayButtonLaunchGame (copy), PlayButtonReferralSource (copy), PlayWithRewardTelemetry (copy), PlayWithRewardBlackoutCurtain (copy), SetPlayWithRewardState (copy), AdService (copy), v36 (copy), EngineFeature (copy), CheckForUpdate (copy), EngineFeature2 (copy), FFlagLuaAppEnableContainedRewardUi (copy), FFlagSduiPlayWithReward (copy), v37 (copy), Skeleton (copy), Icon (copy), Enums (copy), FoundationImage (copy), View (copy), FoundationText (copy), Button (copy), PlayWithRewardCoachmark (copy)
	local v42 = useTokens()
	local v43 = useRoactService(RoactAnalytics)
	local v44 = useRoactService(AppUpdateService)
	local v45 = useDispatch()
	local LocalPlayer = Players.LocalPlayer
	local v47 = React.useRef(nil)
	local v48 = React.useRef(false)
	local playWithRewardAdData = t1.playWithRewardAdData
	local v50 = playWithRewardAdData and playWithRewardAdData.productId or ""
	local v51 = playWithRewardAdData and (not not playWithRewardAdData.experimentVariantData and playWithRewardAdData.experimentVariantData.variantId) or ""
	local v52 = t1.flowId ~= "" and t1.isAdDataExpected
	local u53 = if not FFlagEnablePlayWithRewardNonPeekviewEdp then LocalPlayer ~= nil and (t1.flowId ~= "" and (t1.fetchedUniverseId ~= nil and (t1.fetchedUniverseId == t1.universeId and (playWithRewardAdData ~= nil and (playWithRewardAdData.adAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable and (playWithRewardAdData.experimentVariantData ~= nil and ((playWithRewardAdData.experimentVariantData.titleText ~= "" or playWithRewardAdData.experimentVariantData.subtitleText ~= "") and (tonumber(v50) or 0) ~= 0))))))) else shouldRenderPlayWithRewardBanner(t1.universeId, t1.flowId, t1.fetchedUniverseId, t1.playWithRewardAdData)
	local v54 = t1.placeIdOverride or t1.placeId
	local v55 = usePlayButtonLaunchGame(t1.universeId, v54, t1.placeId, PlayButtonReferralSource.PlayWithReward, "PlayWithRewardGameDetails", "PlayWithRewardButton", t1.experienceJoinData)

	React.useEffect(function() -- line: 116
		-- upvalues: u53 (ref), v48 (copy), PlayWithRewardTelemetry (copy), t1 (copy), v50 (copy), v51 (copy)
		if u53 then
			v48.current = true
			PlayWithRewardTelemetry.logPlayWithRewardBannerShown(t1.flowId, t1.universeId, "startShow", v50, v51)
		end

		return function() -- line: 128
			-- upvalues: v48 (copy), PlayWithRewardTelemetry (copy), t1 (copy), v50 (copy), v51 (copy)
			if v48.current then
				v48.current = false
				PlayWithRewardTelemetry.logPlayWithRewardBannerShown(t1.flowId, t1.universeId, "endShow", v50, v51)
			end
		end
	end, {
		u53,
		t1.flowId,
		t1.universeId,
		v50,
		v51
	})

	local v56 = not playWithRewardAdData and "" or playWithRewardAdData.productName
	local v57 = not playWithRewardAdData and "" or playWithRewardAdData.productImageAssetId
	local v58 = v57 == ""
	local v59 = React.useCallback(function() -- line: 147
		-- upvalues: PlayWithRewardTelemetry (copy), t1 (copy), v50 (copy), PlayWithRewardBlackoutCurtain (copy), v45 (copy), SetPlayWithRewardState (copy), AdService (copy), v56 (copy), v58 (copy), v36 (copy), v57 (copy), v55 (copy), EngineFeature (copy), CheckForUpdate (copy), v44 (copy), EngineFeature2 (copy), v43 (copy)
		local function showAdThenLaunch() -- line: 148
			-- upvalues: PlayWithRewardTelemetry (copy), t1 (copy), v50 (copy), PlayWithRewardBlackoutCurtain (copy), v45 (copy), SetPlayWithRewardState (copy), AdService (copy), v56 (copy), v58 (copy), v36 (copy), v57 (copy), v55 (copy)
			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(t1.flowId, t1.universeId, "shown", v50)
			PlayWithRewardBlackoutCurtain.show()
			PlayWithRewardTelemetry.logPlayWithRewardButtonClicked(t1.flowId, t1.universeId, v50)

			local ok, result = pcall(function() -- line: 159
				-- upvalues: v45 (copy), SetPlayWithRewardState (copy), t1 (copy), PlayWithRewardTelemetry (copy), v50 (copy), AdService (copy)
				v45(SetPlayWithRewardState(t1.flowId, t1.universeId, false, nil))
				PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackAttempted(t1.flowId, t1.universeId, v50)

				return AdService:ShowRewardedVideoAdAtClientAsync(t1.universeId)
			end)

			pcall(function() -- line: 169
				-- upvalues: PlayWithRewardTelemetry (copy), t1 (copy), result (copy), v50 (copy), AdService (copy), ok (copy), v56 (copy), v58 (copy), v36 (copy), v57 (copy)
				PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackStopped(t1.flowId, t1.universeId, tostring(result), v50)
				AdService:SubmitAdNotification(tonumber(t1.universeId) or 0, ok and result ~= nil, result == Enum.ShowAdResult.ShowCompleted, v56, if not v58 then tonumber(v57) or v36 else v36)
			end)
			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(t1.flowId, t1.universeId, "hidden", v50)
			PlayWithRewardBlackoutCurtain.hide()

			if v55 then
				PlayWithRewardTelemetry.logPlayWithRewardGameJoinInitiated(t1.flowId, t1.universeId, v50)
				v55(nil)
			end
		end

		if EngineFeature then
			v45(CheckForUpdate(v44, EngineFeature2, v43, showAdThenLaunch, {
				ctx = "PlayWithRewardGameDetails"
			}))

			return
		end

		showAdThenLaunch()
	end, {
		t1.flowId,
		t1.universeId,
		v45,
		v44,
		v43,
		v55,
		v57,
		v56,
		v58,
		v50
	})
	local n1 = nil
	local XLarge = nil
	local XLarge2 = nil
	local XLarge3 = nil
	local s1 = nil
	local s2 = nil
	local s3 = nil
	local s4 = nil
	local v68 = nil
	local s5 = nil
	local Size_1200 = nil
	local v71 = nil
	local v72 = if not FFlagLuaAppEnableContainedRewardUi then nil else not t1.useLargerStyles and 76 or 108

	if not FFlagLuaAppEnableContainedRewardUi then
		local XLarge4

		if t1.useLargerStyles then
			n1 = 98
			XLarge = v42.Padding.XLarge
			XLarge2 = v42.Padding.XLarge
			XLarge3 = v42.Padding.XLarge
			XLarge4 = v42.Gap.XLarge
			s1 = "padding-top-large"
			s2 = "text-heading-small"
			s3 = "text-body-medium"
			s4 = "gap-xxsmall"
			v68 = true
			s5 = "size-1000-1200"
			Size_1200 = v42.Size.Size_1200
		else
			n1 = 66
			XLarge = v42.Padding.Medium
			XLarge2 = v42.Padding.Small
			XLarge3 = v42.Padding.Medium
			XLarge4 = v42.Gap.Medium
			s1 = "padding-top-medium"
			s2 = "text-title-medium"
			s3 = "text-body-small"
			s4 = ""
			v68 = false
			s5 = "size-800-1000"
			Size_1200 = v42.Size.Size_1000
		end

		v71 = XLarge2 + n1 + XLarge4
	end

	local v74 = if not FFlagSduiPlayWithReward then v37 else t1.layoutOrder or v37

	if v52 then
		return React.createElement(Skeleton, {
			tag = if not FFlagLuaAppEnableContainedRewardUi then s1 else nil,
			Size = UDim2.new(1, 0, 0, if not FFlagLuaAppEnableContainedRewardUi then Size_1200 + XLarge * 2 + XLarge3 else v72),
			LayoutOrder = v74
		})
	end

	if not u53 then
		return nil
	end

	local titleText = playWithRewardAdData.experimentVariantData.titleText
	local subtitleText = playWithRewardAdData.experimentVariantData.subtitleText
	local buttonText = playWithRewardAdData.experimentVariantData.buttonText
	local coachmarkTitleText = playWithRewardAdData.experimentVariantData.coachmarkTitleText
	local coachmarkSubtitleText = playWithRewardAdData.experimentVariantData.coachmarkSubtitleText
	local showButton = playWithRewardAdData.experimentVariantData.showButton
	local v81 = FFlagLuaAppEnableContainedRewardUi and playWithRewardAdData.experimentVariantData.keepRewardContained
	local v82 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v83 = coachmarkTitleText ~= "" and coachmarkSubtitleText ~= ""

	if FFlagLuaAppEnableContainedRewardUi then
		local XLarge5

		if t1.useLargerStyles then
			n1 = not v81 and 98 or 76
			XLarge = if not v81 then v42.Padding.XLarge else v42.Padding.Large
			XLarge2 = v42.Padding.XLarge
			XLarge3 = v42.Padding.XLarge
			XLarge5 = v42.Gap.XLarge
			s1 = "padding-top-large"
			s2 = not v81 and "text-heading-small" or "text-title-large"
			s3 = "text-body-medium"
			s4 = "gap-xxsmall"
			v68 = true
			s5 = "size-1000-1200"
		else
			n1 = not v81 and 66 or 60
			XLarge = if not v81 then v42.Padding.Medium else v42.Padding.Small
			XLarge2 = v42.Padding.Small
			XLarge3 = v42.Padding.Medium
			XLarge5 = v42.Gap.Medium
			s1 = "padding-top-medium"
			s2 = "text-title-medium"
			s3 = "text-body-small"
			s4 = ""
			v68 = false
			s5 = "size-800-1000"
		end

		v71 = XLarge2 + n1 + XLarge5
	end

	local v85 = if not v58 then React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromOffset(n1, n1),
		Position = if not v81 then UDim2.fromOffset(XLarge2, -XLarge3) else nil,
		Image = "rbxassetid://" .. v57
	}) else React.createElement(Icon, {
		ZIndex = 2,
		name = Enums.IconName.GiftBox,
		size = n1,
		Position = if not v81 then UDim2.fromOffset(XLarge2, -XLarge3) else nil
	})

	return React.createElement(View, {
		tag = if not v81 then `size-full-0 auto-y { s1 }` else "size-full-0 auto-y",
		LayoutOrder = v74
	}, {
		Banner = React.createElement(View, {
			tag = "size-full-0 auto-y radius-medium no-clip bg-shift-300",
			onActivated = if not showButton then v59 else nil,
			ref = v47
		}, {
			ProductImage = if not v81 then v85 else nil,
			ContentView = React.createElement(View, {
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				padding = if not v81 then {
					left = UDim.new(0, v71),
					top = UDim.new(0, XLarge),
					right = UDim.new(0, XLarge),
					bottom = UDim.new(0, XLarge)
				} else XLarge
			}, {
				ContainedProductImage = if not v81 then nil else v85,
				TextContainer = React.createElement(View, {
					LayoutOrder = 1,
					tag = `col fill auto-y { s4 }`
				}, {
					RewardTitle = if titleText == "" then nil else React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = `auto-xy text-wrap text-align-x-left content-emphasis { s2 }`,
						Text = titleText
					}),
					RewardDescription = if subtitleText == "" then nil else React.createElement(FoundationText, {
						LayoutOrder = 2,
						tag = `auto-xy text-wrap text-align-x-left content-emphasis { s3 }`,
						Text = subtitleText
					})
				}),
				ClickableIndicator = if not showButton then React.createElement(View, {
					LayoutOrder = 2,
					tag = `align-x-center align-y-center { s5 }`
				}, {
					Icon = React.createElement(Icon, {
						name = Enums.IconName.ChevronLargeRight,
						style = v42.Color.Content.Emphasis,
						size = if not v68 then Enums.IconSize.Medium else Enums.IconSize.Large
					})
				}) else React.createElement(Button, {
					LayoutOrder = 2,
					text = buttonText,
					onActivated = v59,
					variant = Enums.ButtonVariant.SoftEmphasis,
					size = if not v68 then Enums.InputSize.Medium else Enums.InputSize.Large
				})
			})
		}),
		PlayWithRewardCoachmark = if not v83 then nil else React.createElement(PlayWithRewardCoachmark, {
			anchorRef = v47,
			flowId = t1.flowId,
			localUserId = v82,
			productId = v50,
			title = coachmarkTitleText,
			text = coachmarkSubtitleText,
			universeId = t1.universeId
		})
	})
end

return PlayWithRewardComponent
