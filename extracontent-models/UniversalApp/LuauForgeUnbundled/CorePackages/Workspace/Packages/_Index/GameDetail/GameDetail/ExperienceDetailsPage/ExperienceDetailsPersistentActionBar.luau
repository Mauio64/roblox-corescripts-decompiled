local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens

local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GamePlayButton")
local playButton = GamePlayButton.PlayButton
local usePlayButtonState = GamePlayButton.usePlayButtonState
local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local playButtonContextualMessageImpressionsDetector = GamePlayButton.PlayButtonContextualMessageImpressionsDetector
local plusEarlyAccessUpsellBanner = GamePlayButton.PlusEarlyAccessUpsellBanner

local ExperienceDetailsPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageConstants")
local ExperienceDetailsFallbackActionBar = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/Fallback/ExperienceDetailsFallbackActionBar")

local sduiFeatureEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities").SduiFeatureEntryPoint

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactServiceTags")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local fFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local fFlagEnableSplitPaneEDPFix = SharedFlags.FFlagEnableSplitPaneEDPFix
local v5 = fFlagEnableSplitPaneEDPFix
	and "col size-full-0 auto-y gap-small bg-surface-0 align-x-center padding-x-medium padding-top-medium"
	or "col size-full-0 auto-y gap-small bg-surface-0 align-x-center padding-x-medium padding-top-medium stroke-default"

local function PersistentActionBarContextualMessage(p2)
	local v6 = useRoactService(RoactServiceTags.RoactNetworking)
	local v7 = useTokens()
	local ref = React.useRef(nil)

	local v8 = usePlayButtonState(v6, p2.universeId)
	local v9 = usePlayButtonContextualMessage(p2.universeId, v8.playButtonState, v8.playabilityStatus)

	if v9 == nil or v9 == "" then
		return nil
	end

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-xy",
			LayoutOrder = 2,
			testId = "--edp-persistent-action-bar-contextual-message"
		},
		{
			Text = React.createElement(text, {
				tag = "auto-xy text-body-medium text-wrap text-align-x-left",
				textStyle = v7.Color.Content.Emphasis,
				Text = v9,
				ref = ref
			}),
			ImpressionsDetector = React.createElement(playButtonContextualMessageImpressionsDetector, {
				containerRef = ref,
				universeId = p2.universeId,
				playabilityStatus = v8.playabilityStatus,
				contextualMessage = v9,
				pageContext = appPage.GameDetail,
				scrollViewPositionChangedSignal = nil
			})
		}
	)
end

local function ExperienceDetailsPersistentActionBar(props)
	local element = React.createElement(playButton, {
		universeId = props.universeId,
		referralSource = props.referralSource,
		launchSource = props.launchSource,
		experienceJoinData = props.experienceJoinData,
		useUIBloxButton = true,
		placeId = props.placeIdOverride,
		buttonSize = buttonSize.Large,
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		launchWhenLoading = fFlagLuaAppLaunchWhenLoadingEdp and true or nil,
		launchOnReleaseAfterUnmount = true,
		enableEarlyAccessPlusTooltip = fFlagEnableGameJoinEarlyAccess and true or nil,
		enableEarlyAccessState = fFlagEnableGameJoinEarlyAccess and true or nil,
		testId = "--edp-persistent-play-button"
	})

	local createElement = React.createElement
	local onAbsoluteSizeChangesByAbsoluteSize = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChange
	}

	local createElement2 = React.createElement
	local v10

	if fFlagEnableSplitPaneEDPFix then
		v10 = {
			[v5] = true,
			["stroke-default"] = props.showOutline ~= false,
			["padding-bottom-xsmall"] = fFlagEnableGameJoinEarlyAccess
		}
	else
		v10 = if fFlagEnableGameJoinEarlyAccess then v5 .. " padding-bottom-xsmall" else v5
	end

	local v11 = {
		Row = React.createElement(view, {
			tag = "row size-full-0 auto-y gap-small",
			LayoutOrder = 1
		}, {
			EntryPoint = React.createElement(sduiFeatureEntryPoint, {
				appPage = appPage.GameDetail,
				configKey = props.configKey,
				identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
				loadTimer = props.loadTimer,
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1,
				loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
					universeId = props.universeId,
					launchSource = props.launchSource,
					referralSource = props.referralSource,
					experienceJoinData = props.experienceJoinData,
					placeIdOverride = props.placeIdOverride
				}),
				errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
					universeId = props.universeId,
					launchSource = props.launchSource,
					referralSource = props.referralSource,
					experienceJoinData = props.experienceJoinData,
					placeIdOverride = props.placeIdOverride
				})
			}),
			PersistentPlayButton = React.createElement(view, {
				tag = "grow auto-y",
				LayoutOrder = 2
			}, {
				PlayBtn = element
			})
		}),
		ContextualMessage = React.createElement(PersistentActionBarContextualMessage, {
			universeId = props.universeId
		}),
		PlusUpsell = 0
	}

	local v12 = if fFlagEnableGameJoinEarlyAccess then React.createElement(plusEarlyAccessUpsellBanner, {
		universeId = props.universeId,
		LayoutOrder = 3
	}) else nil
	v11.PlusUpsell = v12
	return createElement("Frame", onAbsoluteSizeChangesByAbsoluteSize, {
		Content = createElement2(view, {
			tag = v10,
			testId = "--edp-persistent-action-bar"
		}, v11)
	})
end

return React.memo(ExperienceDetailsPersistentActionBar)
