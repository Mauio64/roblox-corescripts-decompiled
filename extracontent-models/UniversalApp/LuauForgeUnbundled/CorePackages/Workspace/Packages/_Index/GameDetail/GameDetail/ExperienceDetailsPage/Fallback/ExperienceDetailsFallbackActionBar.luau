local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GamePlayButton")
local useGameInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/useGameInfo")
local playButton = GamePlayButton.PlayButton

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagSduiEdpPersistentActionBarPlayButton = SharedFlags.FFlagSduiEdpPersistentActionBarPlayButton
local fFlagLuaAppLaunchWhenLoadingEdp = SharedFlags.FFlagLuaAppLaunchWhenLoadingEdp
local fFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess

local function ExperienceDetailsActionBarSkeleton(props)
	local size_1200 = useTokens().Size.Size_1200

	local createElement = React.createElement

	local v7 = {
		IconButtonSkeleton1 = React.createElement(skeleton, {
			Size = UDim2.fromOffset(size_1200, size_1200),
			radius = radius.Medium,
			LayoutOrder = 1
		}),
		IconButtonSkeleton2 = React.createElement(skeleton, {
			Size = UDim2.fromOffset(size_1200, size_1200),
			radius = radius.Medium,
			LayoutOrder = 2
		}),
		PlayBtnContainer = 0
	}

	local v8 = if not fFlagSduiEdpPersistentActionBarPlayButton then React.createElement(
		view,
		{ tag = "grow auto-y", LayoutOrder = 3 },
		{
			PlayBtn = React.createElement(playButton, {
				universeId = props.universeId,
				referralSource = props.referralSource,
				launchSource = props.launchSource,
				experienceJoinData = props.experienceJoinData,
				placeId = props.placeIdOverride,
				useUIBloxButton = true,
				buttonSize = buttonSize.Large,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				launchWhenLoading = fFlagLuaAppLaunchWhenLoadingEdp and true or nil,
				launchOnReleaseAfterUnmount = true,
				enableEarlyAccessPlusTooltip = fFlagEnableGameJoinEarlyAccess and true or nil,
				enableEarlyAccessState = fFlagEnableGameJoinEarlyAccess and true or nil,
				testId = "--edp-fallback-play-button"
			})
		}
	) else nil
	v7.PlayBtnContainer = v8
	return createElement(view, {
		tag = fFlagSduiEdpPersistentActionBarPlayButton and "row align-y-center gap-small auto-xy" or "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-medium bg-surface-0 stroke-default",
		testId = "--edp-fallback-action-bar-skeleton"
	}, v7)
end

local function ExperienceDetailsActionBarError(props)
	local v5 = useGameInfo(props.universeId)
	local v6 = not (v5 == nil) and v5.isUnavailable == true

	if v6 or fFlagSduiEdpPersistentActionBarPlayButton then
		return nil
	end

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-medium bg-surface-0 stroke-default",
			testId = "--edp-fallback-action-bar-error"
		},
		{
			PlayBtnContainer = React.createElement(view, {
				tag = "grow auto-y",
				LayoutOrder = 1
			}, {
				PlayBtn = React.createElement(playButton, {
					universeId = props.universeId,
					referralSource = props.referralSource,
					launchSource = props.launchSource,
					experienceJoinData = props.experienceJoinData,
					placeId = props.placeIdOverride,
					useUIBloxButton = true,
					buttonSize = buttonSize.Large,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					launchWhenLoading = fFlagLuaAppLaunchWhenLoadingEdp and true or nil,
					launchOnReleaseAfterUnmount = true,
					enableEarlyAccessPlusTooltip = fFlagEnableGameJoinEarlyAccess and true or nil,
					enableEarlyAccessState = fFlagEnableGameJoinEarlyAccess and true or nil,
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
