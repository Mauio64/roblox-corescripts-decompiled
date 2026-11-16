local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens

local GamePlayButton = require(parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local usePlayButtonState = GamePlayButton.usePlayButtonState
local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local PlayButtonContextualMessageImpressionsDetector = GamePlayButton.PlayButtonContextualMessageImpressionsDetector
local PlusEarlyAccessUpsellBanner = GamePlayButton.PlusEarlyAccessUpsellBanner

local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess
local FFlagEnableSplitPaneEDPFix = SharedFlags.FFlagEnableSplitPaneEDPFix
local v = FFlagEnableSplitPaneEDPFix
	and "col size-full-0 auto-y gap-small bg-surface-0 align-x-center padding-x-medium padding-top-medium"
	or "col size-full-0 auto-y gap-small bg-surface-0 align-x-center padding-x-medium padding-top-medium stroke-default"

local function PersistentActionBarContextualMessage(p)
	local v2 = useRoactService(RoactServiceTags.RoactNetworking)
	local v3 = useTokens()
	local ref = React.useRef(nil)

	local v4 = usePlayButtonState(v2, p.universeId)
	local v5 = usePlayButtonContextualMessage(p.universeId, v4.playButtonState, v4.playabilityStatus)

	if v5 == nil or v5 == "" then
		return nil
	end

	return React.createElement(
		View,
		{
			tag = "size-full-0 auto-xy",
			LayoutOrder = 2,
			testId = "--edp-persistent-action-bar-contextual-message"
		},
		{
			Text = React.createElement(Text, {
				tag = "auto-xy text-body-medium text-wrap text-align-x-left",
				textStyle = v3.Color.Content.Emphasis,
				Text = v5,
				ref = ref
			}),
			ImpressionsDetector = React.createElement(PlayButtonContextualMessageImpressionsDetector, {
				containerRef = ref,
				universeId = p.universeId,
				playabilityStatus = v4.playabilityStatus,
				contextualMessage = v5,
				pageContext = AppPage.GameDetail,
				scrollViewPositionChangedSignal = nil
			})
		}
	)
end

local function ExperienceDetailsPersistentActionBar(props)
	local element = React.createElement(PlayButton, {
		universeId = props.universeId,
		referralSource = props.referralSource,
		launchSource = props.launchSource,
		experienceJoinData = props.experienceJoinData,
		useUIBloxButton = true,
		placeId = props.placeIdOverride,
		buttonSize = ButtonSize.Large,
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		launchWhenLoading = FFlagLuaAppLaunchWhenLoadingEdp and true or nil,
		launchOnReleaseAfterUnmount = true,
		enableEarlyAccessPlusTooltip = FFlagEnableGameJoinEarlyAccess and true or nil,
		enableEarlyAccessState = FFlagEnableGameJoinEarlyAccess and true or nil,
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
	local tag

	if FFlagEnableSplitPaneEDPFix then
		tag = {
			[v] = true,
			["stroke-default"] = props.showOutline ~= false,
			["padding-bottom-xsmall"] = FFlagEnableGameJoinEarlyAccess
		}
	elseif FFlagEnableGameJoinEarlyAccess then
		tag = v .. " padding-bottom-xsmall"
	else
		tag = v
	end

	local v2 = {
		Row = React.createElement(View, {
			tag = "row size-full-0 auto-y gap-small",
			LayoutOrder = 1
		}, {
			EntryPoint = React.createElement(SduiFeatureEntryPoint, {
				appPage = AppPage.GameDetail,
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
			PersistentPlayButton = React.createElement(View, {
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
	local plusUpsell

	if FFlagEnableGameJoinEarlyAccess then
		plusUpsell = React.createElement(PlusEarlyAccessUpsellBanner, {
			universeId = props.universeId,
			LayoutOrder = 3
		})
	end

	v2.PlusUpsell = plusUpsell
	return createElement("Frame", onAbsoluteSizeChangesByAbsoluteSize, {
		Content = createElement2(View, { tag = tag, testId = "--edp-persistent-action-bar" }, v2)
	})
end

return React.memo(ExperienceDetailsPersistentActionBar)
