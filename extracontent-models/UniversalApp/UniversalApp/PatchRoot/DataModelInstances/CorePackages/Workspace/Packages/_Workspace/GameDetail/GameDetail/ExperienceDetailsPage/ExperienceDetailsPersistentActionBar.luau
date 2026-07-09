local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local ButtonSize = Foundation.Enums.ButtonSize
local PlayButton = require(Parent.GamePlayButton).PlayButton
local ExperienceDetailsPageConstants = require(script.Parent.ExperienceDetailsPageConstants)
local ExperienceDetailsFallbackActionBar = require(script.Parent.Fallback.ExperienceDetailsFallbackActionBar)
local SduiFeatureEntryPoint = require(Parent.SduiSharedUtilities).SduiFeatureEntryPoint
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox
local FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = SharedFlags.FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp

local function ExperienceDetailsPersistentActionBar(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), View (copy), SduiFeatureEntryPoint (copy), AppPage (copy), ExperienceDetailsPageConstants (copy), ExperienceDetailsFallbackActionBar (copy), PlayButton (copy), FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox (copy), FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox (copy), ButtonSize (copy), Foundation (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy)
	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = t1.onAbsoluteSizeChange
	}, {
		Content = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-small bg-surface-0 align-x-center padding-x-medium padding-top-medium stroke-default",
			testId = "--edp-persistent-action-bar"
		}, {
			Row = React.createElement(View, {
				tag = "row size-full-0 auto-y gap-small"
			}, {
				EntryPoint = React.createElement(SduiFeatureEntryPoint, {
					LayoutOrder = 1,
					appPage = AppPage.GameDetail,
					configKey = t1.configKey,
					identifier = ExperienceDetailsPageConstants.EDP_ACTION_BAR_IDENTIFIER,
					loadTimer = t1.loadTimer,
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					loadingSlot = React.createElement(ExperienceDetailsFallbackActionBar.Skeleton, {
						universeId = t1.universeId,
						launchSource = t1.launchSource,
						referralSource = t1.referralSource,
						experienceJoinData = t1.experienceJoinData,
						placeIdOverride = t1.placeIdOverride
					}),
					errorSlot = React.createElement(ExperienceDetailsFallbackActionBar.Error, {
						universeId = t1.universeId,
						launchSource = t1.launchSource,
						referralSource = t1.referralSource,
						experienceJoinData = t1.experienceJoinData,
						placeIdOverride = t1.placeIdOverride
					})
				}),
				PersistentPlayButton = React.createElement(View, {
					tag = "grow auto-y",
					LayoutOrder = 2
				}, {
					PlayBtn = React.createElement(PlayButton, {
						testId = "--edp-persistent-play-button",
						universeId = t1.universeId,
						referralSource = t1.referralSource,
						launchSource = t1.launchSource,
						experienceJoinData = t1.experienceJoinData,
						useUIBloxButton = not FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox or FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox,
						placeId = t1.placeIdOverride,
						buttonSize = ButtonSize.Large,
						fillBehavior = Foundation.Enums.FillBehavior.Fill,
						launchWhenLoading = not not FFlagLuaAppLaunchWhenLoadingEdp or nil,
						launchOnReleaseAfterUnmount = not not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp or nil
					})
				})
			})
		})
	})
end

return React.memo(ExperienceDetailsPersistentActionBar)
