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
local HandleUpdate = RobloxAppUpdate.HandleUpdate
local EngineFeature = game:GetEngineFeature("AutoUpgradeEngineFeatureOnly")
local EngineFeature2 = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")
local v37 = game:DefineFastInt("PlayWithRewardFallbackBannerProductImageAssetId", 0)
local v38 = game:DefineFastInt("LuaAppPlayWithRewardMobileEdpLayoutOrder", 120)
local FFlagEnablePlayWithRewardNonPeekviewEdp = SharedFlags.FFlagEnablePlayWithRewardNonPeekviewEdp
local FFlagSduiPlayWithReward = SharedFlags.FFlagSduiPlayWithReward
local FFlagLuaAppEnableContainedRewardUi = PlayWithRewardState.FFlagLuaAppEnableContainedRewardUi
local FFlagCheckForUpdatePromise = SharedFlags.FFlagCheckForUpdatePromise

function PlayWithRewardComponent(t1: {[any]: any}) -- line: 69
	-- upvalues: useTokens (copy), useRoactService (copy), RoactAnalytics (copy), AppUpdateService (copy), useDispatch (copy), Players (copy), React (copy), FFlagEnablePlayWithRewardNonPeekviewEdp (copy), shouldRenderPlayWithRewardBanner (copy), usePlayButtonLaunchGame (copy), PlayButtonReferralSource (copy), PlayWithRewardTelemetry (copy), PlayWithRewardBlackoutCurtain (copy), SetPlayWithRewardState (copy), AdService (copy), v37 (copy), EngineFeature (copy), FFlagCheckForUpdatePromise (copy), HandleUpdate (copy), EngineFeature2 (copy), CheckForUpdate (copy), FFlagLuaAppEnableContainedRewardUi (copy), FFlagSduiPlayWithReward (copy), v38 (copy), Skeleton (copy), Icon (copy), Enums (copy), FoundationImage (copy), View (copy), FoundationText (copy), Button (copy), PlayWithRewardCoachmark (copy)
	local v44 = useTokens()
	local v45 = useRoactService(RoactAnalytics)
	local v46 = useRoactService(AppUpdateService)
	local v47 = useDispatch()
	local LocalPlayer = Players.LocalPlayer
	local v49 = React.useRef(nil)
	local v50 = React.useRef(false)
	local playWithRewardAdData = t1.playWithRewardAdData
	local v52 = playWithRewardAdData and playWithRewardAdData.productId or ""
	local v53 = playWithRewardAdData and (not not playWithRewardAdData.experimentVariantData and playWithRewardAdData.experimentVariantData.variantId) or ""
	local v54 = t1.flowId ~= "" and t1.isAdDataExpected
	local u55 = if not FFlagEnablePlayWithRewardNonPeekviewEdp then LocalPlayer ~= nil and (t1.flowId ~= "" and (t1.fetchedUniverseId ~= nil and (t1.fetchedUniverseId == t1.universeId and (playWithRewardAdData ~= nil and (playWithRewardAdData.adAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable and (playWithRewardAdData.experimentVariantData ~= nil and ((playWithRewardAdData.experimentVariantData.titleText ~= "" or playWithRewardAdData.experimentVariantData.subtitleText ~= "") and (tonumber(v52) or 0) ~= 0))))))) else shouldRenderPlayWithRewardBanner(t1.universeId, t1.flowId, t1.fetchedUniverseId, t1.playWithRewardAdData)
	local v56 = t1.placeIdOverride or t1.placeId
	local v57 = usePlayButtonLaunchGame(t1.universeId, v56, t1.placeId, PlayButtonReferralSource.PlayWithReward, "PlayWithRewardGameDetails", "PlayWithRewardButton", t1.experienceJoinData)

	React.useEffect(function() -- line: 119
		-- upvalues: u55 (ref), v50 (copy), PlayWithRewardTelemetry (copy), t1 (copy), v52 (copy), v53 (copy)
		if u55 then
			v50.current = true
			PlayWithRewardTelemetry.logPlayWithRewardBannerShown(t1.flowId, t1.universeId, "startShow", v52, v53)
		end

		return function() -- line: 131
			-- upvalues: v50 (copy), PlayWithRewardTelemetry (copy), t1 (copy), v52 (copy), v53 (copy)
			if v50.current then
				v50.current = false
				PlayWithRewardTelemetry.logPlayWithRewardBannerShown(t1.flowId, t1.universeId, "endShow", v52, v53)
			end
		end
	end, {
		u55,
		t1.flowId,
		t1.universeId,
		v52,
		v53
	})

	local v58 = not playWithRewardAdData and "" or playWithRewardAdData.productName
	local v59 = not playWithRewardAdData and "" or playWithRewardAdData.productImageAssetId
	local v60 = v59 == ""
	local v61 = React.useCallback(function() -- line: 150
		-- upvalues: PlayWithRewardTelemetry (copy), t1 (copy), v52 (copy), PlayWithRewardBlackoutCurtain (copy), v47 (copy), SetPlayWithRewardState (copy), AdService (copy), v58 (copy), v60 (copy), v37 (copy), v59 (copy), v57 (copy), EngineFeature (copy), FFlagCheckForUpdatePromise (copy), HandleUpdate (copy), v46 (copy), EngineFeature2 (copy), v45 (copy), CheckForUpdate (copy)
		local function showAdThenLaunch() -- line: 151
			-- upvalues: PlayWithRewardTelemetry (copy), t1 (copy), v52 (copy), PlayWithRewardBlackoutCurtain (copy), v47 (copy), SetPlayWithRewardState (copy), AdService (copy), v58 (copy), v60 (copy), v37 (copy), v59 (copy), v57 (copy)
			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(t1.flowId, t1.universeId, "shown", v52)
			PlayWithRewardBlackoutCurtain.show()
			PlayWithRewardTelemetry.logPlayWithRewardButtonClicked(t1.flowId, t1.universeId, v52)

			local ok, result = pcall(function() -- line: 162
				-- upvalues: v47 (copy), SetPlayWithRewardState (copy), t1 (copy), PlayWithRewardTelemetry (copy), v52 (copy), AdService (copy)
				v47(SetPlayWithRewardState(t1.flowId, t1.universeId, false, nil))
				PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackAttempted(t1.flowId, t1.universeId, v52)

				return AdService:ShowRewardedVideoAdAtClientAsync(t1.universeId)
			end)

			pcall(function() -- line: 172
				-- upvalues: PlayWithRewardTelemetry (copy), t1 (copy), result (copy), v52 (copy), AdService (copy), ok (copy), v58 (copy), v60 (copy), v37 (copy), v59 (copy)
				PlayWithRewardTelemetry.logPlayWithRewardAdPlaybackStopped(t1.flowId, t1.universeId, tostring(result), v52)
				AdService:SubmitAdNotification(tonumber(t1.universeId) or 0, ok and result ~= nil, result == Enum.ShowAdResult.ShowCompleted, v58, if not v60 then tonumber(v59) or v37 else v37)
			end)
			PlayWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(t1.flowId, t1.universeId, "hidden", v52)
			PlayWithRewardBlackoutCurtain.hide()

			if v57 then
				PlayWithRewardTelemetry.logPlayWithRewardGameJoinInitiated(t1.flowId, t1.universeId, v52)
				v57(nil)
			end
		end

		if EngineFeature then
			if FFlagCheckForUpdatePromise then
				HandleUpdate(v47, v46, EngineFeature2, v45, "PlayWithRewardGameDetails", showAdThenLaunch)

				return
			end

			v47(CheckForUpdate(v46, EngineFeature2, v45, showAdThenLaunch, {
				ctx = "PlayWithRewardGameDetails"
			}))

			return
		end

		showAdThenLaunch()
	end, {
		t1.flowId,
		t1.universeId,
		v47,
		v46,
		v45,
		v57,
		v59,
		v58,
		v60,
		v52
	})
	local n1 = nil
	local XLarge = nil
	local XLarge2 = nil
	local XLarge3 = nil
	local s1 = nil
	local s2 = nil
	local s3 = nil
	local s4 = nil
	local v70 = nil
	local s5 = nil
	local Size_1200 = nil
	local v73 = nil
	local v74 = if not FFlagLuaAppEnableContainedRewardUi then nil else not t1.useLargerStyles and 76 or 108

	if not FFlagLuaAppEnableContainedRewardUi then
		local XLarge4

		if t1.useLargerStyles then
			n1 = 98
			XLarge = v44.Padding.XLarge
			XLarge2 = v44.Padding.XLarge
			XLarge3 = v44.Padding.XLarge
			XLarge4 = v44.Gap.XLarge
			s1 = "padding-top-large"
			s2 = "text-heading-small"
			s3 = "text-body-medium"
			s4 = "gap-xxsmall"
			v70 = true
			s5 = "size-1000-1200"
			Size_1200 = v44.Size.Size_1200
		else
			n1 = 66
			XLarge = v44.Padding.Medium
			XLarge2 = v44.Padding.Small
			XLarge3 = v44.Padding.Medium
			XLarge4 = v44.Gap.Medium
			s1 = "padding-top-medium"
			s2 = "text-title-medium"
			s3 = "text-body-small"
			s4 = ""
			v70 = false
			s5 = "size-800-1000"
			Size_1200 = v44.Size.Size_1000
		end

		v73 = XLarge2 + n1 + XLarge4
	end

	local v76 = if not FFlagSduiPlayWithReward then v38 else t1.layoutOrder or v38

	if v54 then
		return React.createElement(Skeleton, {
			tag = if not FFlagLuaAppEnableContainedRewardUi then s1 else nil,
			Size = UDim2.new(1, 0, 0, if not FFlagLuaAppEnableContainedRewardUi then Size_1200 + XLarge * 2 + XLarge3 else v74),
			LayoutOrder = v76
		})
	end

	if not u55 then
		return nil
	end

	local titleText = playWithRewardAdData.experimentVariantData.titleText
	local subtitleText = playWithRewardAdData.experimentVariantData.subtitleText
	local buttonText = playWithRewardAdData.experimentVariantData.buttonText
	local coachmarkTitleText = playWithRewardAdData.experimentVariantData.coachmarkTitleText
	local coachmarkSubtitleText = playWithRewardAdData.experimentVariantData.coachmarkSubtitleText
	local showButton = playWithRewardAdData.experimentVariantData.showButton
	local v83 = FFlagLuaAppEnableContainedRewardUi and playWithRewardAdData.experimentVariantData.keepRewardContained
	local v84 = not LocalPlayer and 0 or LocalPlayer.UserId
	local v85 = coachmarkTitleText ~= "" and coachmarkSubtitleText ~= ""

	if FFlagLuaAppEnableContainedRewardUi then
		local XLarge5

		if t1.useLargerStyles then
			n1 = not v83 and 98 or 76
			XLarge = if not v83 then v44.Padding.XLarge else v44.Padding.Large
			XLarge2 = v44.Padding.XLarge
			XLarge3 = v44.Padding.XLarge
			XLarge5 = v44.Gap.XLarge
			s1 = "padding-top-large"
			s2 = not v83 and "text-heading-small" or "text-title-large"
			s3 = "text-body-medium"
			s4 = "gap-xxsmall"
			v70 = true
			s5 = "size-1000-1200"
		else
			n1 = not v83 and 66 or 60
			XLarge = if not v83 then v44.Padding.Medium else v44.Padding.Small
			XLarge2 = v44.Padding.Small
			XLarge3 = v44.Padding.Medium
			XLarge5 = v44.Gap.Medium
			s1 = "padding-top-medium"
			s2 = "text-title-medium"
			s3 = "text-body-small"
			s4 = ""
			v70 = false
			s5 = "size-800-1000"
		end

		v73 = XLarge2 + n1 + XLarge5
	end

	local v87 = if not v60 then React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromOffset(n1, n1),
		Position = if not v83 then UDim2.fromOffset(XLarge2, -XLarge3) else nil,
		Image = "rbxassetid://" .. v59
	}) else React.createElement(Icon, {
		ZIndex = 2,
		name = Enums.IconName.GiftBox,
		size = n1,
		Position = if not v83 then UDim2.fromOffset(XLarge2, -XLarge3) else nil
	})

	return React.createElement(View, {
		tag = if not v83 then `size-full-0 auto-y { s1 }` else "size-full-0 auto-y",
		LayoutOrder = v76
	}, {
		Banner = React.createElement(View, {
			tag = "size-full-0 auto-y radius-medium no-clip bg-shift-300",
			onActivated = if not showButton then v61 else nil,
			ref = v49
		}, {
			ProductImage = if not v83 then v87 else nil,
			ContentView = React.createElement(View, {
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				padding = if not v83 then {
					left = UDim.new(0, v73),
					top = UDim.new(0, XLarge),
					right = UDim.new(0, XLarge),
					bottom = UDim.new(0, XLarge)
				} else XLarge
			}, {
				ContainedProductImage = if not v83 then nil else v87,
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
						style = v44.Color.Content.Emphasis,
						size = if not v70 then Enums.IconSize.Medium else Enums.IconSize.Large
					})
				}) else React.createElement(Button, {
					LayoutOrder = 2,
					text = buttonText,
					onActivated = v61,
					variant = Enums.ButtonVariant.SoftEmphasis,
					size = if not v70 then Enums.InputSize.Medium else Enums.InputSize.Large
				})
			})
		}),
		PlayWithRewardCoachmark = if not v85 then nil else React.createElement(PlayWithRewardCoachmark, {
			anchorRef = v49,
			flowId = t1.flowId,
			localUserId = v84,
			productId = v52,
			title = coachmarkTitleText,
			text = coachmarkSubtitleText,
			universeId = t1.universeId
		})
	})
end

return PlayWithRewardComponent
