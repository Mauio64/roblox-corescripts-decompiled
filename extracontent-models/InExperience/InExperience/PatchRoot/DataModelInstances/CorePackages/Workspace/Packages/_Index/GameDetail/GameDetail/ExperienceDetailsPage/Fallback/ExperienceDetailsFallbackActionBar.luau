local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local GamePlayButton = require(Parent.GamePlayButton)
local useGameInfo = require(script.Parent.Parent.useGameInfo)
local PlayButton = GamePlayButton.PlayButton
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox
local FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox = SharedFlags.FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox
local FFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp = SharedFlags.FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp

local function ExperienceDetailsActionBarSkeleton(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), React (copy), View (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), Skeleton (copy), EnumsRadius (copy), PlayButton (copy), FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox (copy), FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox (copy), ButtonSize (copy), Foundation (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy)
	local Size_1200 = useTokens().Size.Size_1200

	return React.createElement(View, {
		testId = "--edp-fallback-action-bar-skeleton",
		tag = not FFlagSduiEdpPersistentActionBarPlayButton and "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-medium bg-surface-0 stroke-default" or "row align-y-center gap-small auto-xy"
	}, {
		IconButtonSkeleton1 = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(Size_1200, Size_1200),
			radius = EnumsRadius.Medium
		}),
		IconButtonSkeleton2 = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(Size_1200, Size_1200),
			radius = EnumsRadius.Medium
		}),
		PlayBtnContainer = if not FFlagSduiEdpPersistentActionBarPlayButton then React.createElement(View, {
			tag = "grow auto-y",
			LayoutOrder = 3
		}, {
			PlayBtn = React.createElement(PlayButton, {
				testId = "--edp-fallback-play-button",
				universeId = t1.universeId,
				referralSource = t1.referralSource,
				launchSource = t1.launchSource,
				experienceJoinData = t1.experienceJoinData,
				placeId = t1.placeIdOverride,
				useUIBloxButton = if not FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox then nil else FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox,
				buttonSize = ButtonSize.Large,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				launchWhenLoading = not not FFlagLuaAppLaunchWhenLoadingEdp or nil,
				launchOnReleaseAfterUnmount = not not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp or nil
			})
		}) else nil
	})
end
local function ExperienceDetailsActionBarError(t2: {[any]: any}) -- line: 79
	-- upvalues: useGameInfo (copy), FFlagSduiEdpPersistentActionBarPlayButton (copy), React (copy), View (copy), PlayButton (copy), FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox (copy), FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox (copy), ButtonSize (copy), Foundation (copy), FFlagLuaAppLaunchWhenLoadingEdp (copy), FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp (copy)
	local v23 = useGameInfo(t2.universeId)

	if v23 ~= nil and v23.isUnavailable == true then
		return nil
	end

	if FFlagSduiEdpPersistentActionBarPlayButton then
		return nil
	end

	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-medium bg-surface-0 stroke-default",
		testId = "--edp-fallback-action-bar-error"
	}, {
		PlayBtnContainer = React.createElement(View, {
			tag = "grow auto-y",
			LayoutOrder = 1
		}, {
			PlayBtn = React.createElement(PlayButton, {
				testId = "--edp-fallback-play-button",
				universeId = t2.universeId,
				referralSource = t2.referralSource,
				launchSource = t2.launchSource,
				experienceJoinData = t2.experienceJoinData,
				placeId = t2.placeIdOverride,
				useUIBloxButton = not FFlagLuaAppSduiEdpFallbackPlayButtonPassUiBlox or FFlagLuaAppSduiEdpFallbackPlayButtonUseUiBlox,
				buttonSize = ButtonSize.Large,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				launchWhenLoading = not not FFlagLuaAppLaunchWhenLoadingEdp or nil,
				launchOnReleaseAfterUnmount = not not FFlagLuaAppPlayButtonLaunchOnReleaseAfterUnmountEdp or nil
			})
		})
	})
end

return {
	Skeleton = React.memo(ExperienceDetailsActionBarSkeleton),
	Error = React.memo(ExperienceDetailsActionBarError)
}
