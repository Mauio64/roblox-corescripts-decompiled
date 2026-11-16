local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local GamePlayButton = require(parent.GamePlayButton)
local useGameInfo = require(script.Parent.Parent.useGameInfo)
local PlayButton = GamePlayButton.PlayButton

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local FFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess

local function ExperienceDetailsActionBarSkeleton(props)
	local size_1200 = useTokens().Size.Size_1200

	local createElement = React.createElement

	local v = {
		IconButtonSkeleton1 = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(size_1200, size_1200),
			radius = Radius.Medium,
			LayoutOrder = 1
		}),
		IconButtonSkeleton2 = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(size_1200, size_1200),
			radius = Radius.Medium,
			LayoutOrder = 2
		}),
		PlayBtnContainer = 0
	}
	local playBtnContainer

	if not FFlagSduiEdpPersistentActionBarPlayButton then
		playBtnContainer = React.createElement(View, { tag = "grow auto-y", LayoutOrder = 3 }, {
			PlayBtn = React.createElement(PlayButton, {
				universeId = props.universeId,
				referralSource = props.referralSource,
				launchSource = props.launchSource,
				experienceJoinData = props.experienceJoinData,
				placeId = props.placeIdOverride,
				useUIBloxButton = true,
				buttonSize = ButtonSize.Large,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				launchWhenLoading = FFlagLuaAppLaunchWhenLoadingEdp and true or nil,
				launchOnReleaseAfterUnmount = true,
				enableEarlyAccessPlusTooltip = FFlagEnableGameJoinEarlyAccess and true or nil,
				enableEarlyAccessState = FFlagEnableGameJoinEarlyAccess and true or nil,
				testId = "--edp-fallback-play-button"
			})
		})
	end

	v.PlayBtnContainer = playBtnContainer
	return createElement(View, {
		tag = FFlagSduiEdpPersistentActionBarPlayButton and "row align-y-center gap-small auto-xy" or "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-medium bg-surface-0 stroke-default",
		testId = "--edp-fallback-action-bar-skeleton"
	}, v)
end

local function ExperienceDetailsActionBarError(props)
	local v = useGameInfo(props.universeId)
	local v2

	if v == nil then
		v2 = false
	else
		v2 = v.isUnavailable == true
	end

	if v2 or FFlagSduiEdpPersistentActionBarPlayButton then
		return nil
	end

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-medium bg-surface-0 stroke-default",
			testId = "--edp-fallback-action-bar-error"
		},
		{
			PlayBtnContainer = React.createElement(View, { tag = "grow auto-y", LayoutOrder = 1 }, {
				PlayBtn = React.createElement(PlayButton, {
					universeId = props.universeId,
					referralSource = props.referralSource,
					launchSource = props.launchSource,
					experienceJoinData = props.experienceJoinData,
					placeId = props.placeIdOverride,
					useUIBloxButton = true,
					buttonSize = ButtonSize.Large,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					launchWhenLoading = FFlagLuaAppLaunchWhenLoadingEdp and true or nil,
					launchOnReleaseAfterUnmount = true,
					enableEarlyAccessPlusTooltip = FFlagEnableGameJoinEarlyAccess and true or nil,
					enableEarlyAccessState = FFlagEnableGameJoinEarlyAccess and true or nil,
					testId = "--edp-fallback-play-button"
				})
			})
		}
	)
end

return {
	Skeleton = React.memo(ExperienceDetailsActionBarSkeleton),
	Error = React.memo(ExperienceDetailsActionBarError)
}
