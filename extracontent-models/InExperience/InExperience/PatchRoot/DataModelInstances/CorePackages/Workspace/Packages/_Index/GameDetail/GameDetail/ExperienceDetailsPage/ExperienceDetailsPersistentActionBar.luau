local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local GamePlayButton = require(Parent.GamePlayButton)
local PlayButton = GamePlayButton.PlayButton
local usePlayButtonState = GamePlayButton.usePlayButtonState
local usePlayButtonContextualMessage = GamePlayButton.usePlayButtonContextualMessage
local PlayButtonContextualMessageImpressionsDetector = GamePlayButton.PlayButtonContextualMessageImpressionsDetector
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)
local SduiFeatureEntryPoint = require(Parent.SduiSharedUtilities).SduiFeatureEntryPoint
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(Parent.RoactServiceTags)
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox
local FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = SharedFlags.FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp

local function PersistentActionBarContextualMessage(t1: {[any]: any}) -- line: 50
	-- upvalues: useRoactService (copy), RoactServiceTags (copy), useTokens (copy), React (copy), usePlayButtonState (copy), usePlayButtonContextualMessage (copy), View (copy), FoundationText (copy), PlayButtonContextualMessageImpressionsDetector (copy), AppPage (copy)
	local v27 = useRoactService(RoactServiceTags.RoactNetworking)
	local v28 = useTokens()
	local v29 = React.useRef(nil)
	local v30 = usePlayButtonState(v27, t1.universeId)
	local v31 = usePlayButtonContextualMessage(t1.universeId, v30.playButtonState, v30.playabilityStatus)

	if v31 == nil or v31 == "" then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-xy",
		LayoutOrder = 2,
		testId = "--edp-persistent-action-bar-contextual-message"
	}, {
		Text = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			textStyle = v28.Color.Content.Emphasis,
			Text = v31,
			ref = v29
		}),
		ImpressionsDetector = React.createElement(PlayButtonContextualMessageImpressionsDetector, {
			scrollViewPositionChangedSignal = nil,
			containerRef = v29,
			universeId = t1.universeId,
			playabilityStatus = v30.playabilityStatus,
			contextualMessage = v31,
			pageContext = AppPage.GameDetail
		})
	})
end
local function ExperienceDetailsPersistentActionBar(t2: {[any]: any}) -- line: 88
	-- upvalues: React (copy), View (copy), SduiFeatureEntryPoint (copy), AppPage (copy), ExperienceDetailsPageConstants (copy), ExperienceDetailsFallbackActionBar (copy), PlayButton (copy), FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox (copy), FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox (copy), ButtonSize (copy), Foundation (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy), PersistentActionBarContextualMessage (copy)
	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = t2.onAbsoluteSizeChange
	}, {
		Content = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-small bg-surface-0 align-x-center padding-x-medium padding-top-medium stroke-default",
			testId = "--edp-persistent-action-bar"
		}, {
			Row = React.createElement(View, {
				tag = "row size-full-0 auto-y gap-small",
				LayoutOrder = 1
			}, {
				EntryPoint = React.createElement(SduiFeatureEntryPoint, {
					LayoutOrder = 1,
					appPage = AppPage.GameDetail,
					configKey = t2.configKey,
					identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
					loadTimer = t2.loadTimer,
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
						universeId = t2.universeId,
						launchSource = t2.launchSource,
						referralSource = t2.referralSource,
						experienceJoinData = t2.experienceJoinData,
						placeIdOverride = t2.placeIdOverride
					}),
					errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
						universeId = t2.universeId,
						launchSource = t2.launchSource,
						referralSource = t2.referralSource,
						experienceJoinData = t2.experienceJoinData,
						placeIdOverride = t2.placeIdOverride
					})
				}),
				PersistentPlayButton = React.createElement(View, {
					tag = "grow auto-y",
					LayoutOrder = 2
				}, {
					PlayBtn = React.createElement(PlayButton, {
						testId = "--edp-persistent-play-button",
						universeId = t2.universeId,
						referralSource = t2.referralSource,
						launchSource = t2.launchSource,
						experienceJoinData = t2.experienceJoinData,
						useUIBloxButton = not FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox or FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox,
						placeId = t2.placeIdOverride,
						buttonSize = ButtonSize.Large,
						fillBehavior = Foundation.Enums.FillBehavior.Fill,
						launchWhenLoading = not not FFlagLuaAppLaunchWhenLoadingEdp or nil,
						launchOnReleaseAfterUnmount = not not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp or nil
					})
				})
			}),
			ContextualMessage = React.createElement(PersistentActionBarContextualMessage, {
				universeId = t2.universeId
			})
		})
	})
end

return React.memo(ExperienceDetailsPersistentActionBar)
