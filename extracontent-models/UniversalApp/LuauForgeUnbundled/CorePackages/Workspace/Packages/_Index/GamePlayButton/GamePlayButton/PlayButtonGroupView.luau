local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags")
local fFlagLuaAppUseTokenHeightForPlayButton = SharedFlags.FFlagLuaAppUseTokenHeightForPlayButton
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess

local ButtonHeightSizeKeyByInputSize = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/ButtonHeightSizeKeyByInputSize")
local PlayButtonView = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonView")

local function fn() end

local function makePlayButtonProps(props, secondaryPlayButtonState, onSecondaryPlayButtonActivated, playButtonCaptureRef, loadingCaptureRef, fillBehavior2, layoutOrder, testId, p2, showEarlyAccessTooltip)
	if not fFlagEnableGameJoinEarlyAccess then
		showEarlyAccessTooltip = nil
	end

	local playButtonProps = {
		tag = p2,
		showEarlyAccessTooltip = showEarlyAccessTooltip,
		playButtonState = secondaryPlayButtonState,
		gameProductInfo = props.gameProductInfo,
		localized = props.localized,
		tokens = props.tokens,
		hasJoinTextPlayableButtonIxp = props.hasJoinTextPlayableButtonIxp,
		hasIconPlayButtonIxp = props.hasIconPlayButtonIxp,
		hasPlayButtonLoadingSkeletonIxp = props.hasPlayButtonLoadingSkeletonIxp,
		onPlayButtonActivated = onSecondaryPlayButtonActivated,
		onPlaySquadButtonActivated = props.onPlaySquadButtonActivated,
		playButtonCaptureRef = playButtonCaptureRef,
		loadingCaptureRef = loadingCaptureRef,
		shouldLaunchWhenLoading = props.shouldLaunchWhenLoading,
		shouldLaunchOnReleaseAfterUnmount = props.shouldLaunchOnReleaseAfterUnmount,
		squadButtonMenuDirection = props.squadButtonMenuDirection,
		playableText = props.playableText,
		fiatText = props.fiatText,
		earlyAccessCaption = 0,
		earlyAccessPending = 0,
		hidePlayableIcon = 0,
		hideOptionalText = 0,
		buttonSize = 0,
		fillBehavior = 0,
		useUIBloxButton = 0,
		hideIfUnplayable = 0,
		hideIfLoading = 0,
		LayoutOrder = 0,
		testId = 0
	}
	local v5 = if fFlagEnableGameJoinEarlyAccess then props.earlyAccessCaption else nil
	playButtonProps.earlyAccessCaption = v5
	local v6 = if fFlagEnableGameJoinEarlyAccess then props.earlyAccessPending else nil
	playButtonProps.earlyAccessPending = v6
	playButtonProps.hidePlayableIcon = props.hidePlayableIcon
	playButtonProps.hideOptionalText = props.hideOptionalText
	playButtonProps.buttonSize = props.buttonSize
	playButtonProps.fillBehavior = fillBehavior2
	playButtonProps.useUIBloxButton = props.useUIBloxButton
	playButtonProps.hideIfUnplayable = props.hideIfUnplayable
	playButtonProps.hideIfLoading = props.hideIfLoading
	playButtonProps.LayoutOrder = layoutOrder
	playButtonProps.testId = testId
	return playButtonProps
end

local function PlayButtonGroupView(props)
	local tokens = props.tokens
	local buttonSize = props.buttonSize or inputSize.Medium
	local v5

	if fFlagLuaAppUseTokenHeightForPlayButton then
		local v6 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
		v5 = not (tokens and tokens.Size[v6]) and 40 or tokens.Size[v6]
	else
		v5 = 0
	end

	local v6 = not tokens and 8 or tokens.Gap.Small
	local v7 = props.width

	if props.expandWidthForSecondaryPlayButton and props.secondaryPlayButtonState ~= nil and v7 ~= nil then
		v7 = UDim.new(v7.Scale * 2, v7.Offset * 2 + v6)
	end

	local v8 = if v7 then fillBehavior.Fill else props.fillBehavior
	local v9

	if props.secondaryPlayButtonState == nil and v7 == nil then
		v9 = v8
	else
		v9 = if v8 == "Fill" then fillBehavior.Fill else fillBehavior.Fit
	end

	local v10 = if props.testId then `{props.testId}--secondary` else nil

	local createElement = React.createElement
	local v12 = {}
	v12.LayoutOrder = props.LayoutOrder
	v12.Position = props.Position
	local udim

	if fFlagLuaAppUseTokenHeightForPlayButton then
		local newUDim2 = UDim2.new

		if not v7 then
			v7 = if v8 == "Fill" then UDim.new(1, 0) else UDim.new(0, 0)
		end

		udim = newUDim2(v7, UDim.new(0, v5))
	elseif v7 then
		udim = UDim2.new(v7, UDim.new(0, 0))
	elseif v8 == "Fill" then
		udim = UDim2.new(1, 0, 1, 0)
	end

	v12.Size = udim
	local v13

	if fFlagLuaAppUseTokenHeightForPlayButton then
		if v8 ~= "Fill" then
			v13 = Enum.AutomaticSize.X
		end
	else
		v13 = if v8 == "Fill" then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY
	end

	v12.AutomaticSize = v13

	v12.BackgroundTransparency = 1
	v12.BorderSizePixel = 0
	local tag = React.Tag
	local v14 = if not fFlagLuaAppMediaGalleryGamepadSupport then props.tag else nil
	v12[tag] = v14

	local createElement2 = React.createElement
	local v16 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = 0,
		Padding = 0,
		SortOrder = 0
	}
	local v17 = if v8 == "Fill" then Enum.UIFlexAlignment.Fill else Enum.UIFlexAlignment.None
	v16.HorizontalFlex = v17
	v16.Padding = UDim.new(0, v6)
	v16.SortOrder = Enum.SortOrder.LayoutOrder
	local children = {
		Layout = createElement2("UIListLayout", v16),
		PlayButton = 0,
		PopForcePicker = 0,
		SecondaryPlayButton = 0
	}

	local createElement3 = React.createElement

	local playButtonState = props.playButtonState
	local onPlayButtonActivated = props.onPlayButtonActivated
	local playButtonCaptureRef = props.playButtonCaptureRef
	local loadingCaptureRef = props.loadingCaptureRef

	local testId = props.testId
	local tag2 = if fFlagLuaAppMediaGalleryGamepadSupport then props.tag else nil
	local v21 = if fFlagEnableGameJoinEarlyAccess then props.showEarlyAccessTooltip else nil
	children.PlayButton = createElement3(
		PlayButtonView,
		makePlayButtonProps(
			props,
			playButtonState,
			onPlayButtonActivated,
			playButtonCaptureRef,
			loadingCaptureRef,
			v9,
			1,
			testId,
			tag2,
			v21
		)
	)

	local v22 = if SharedFlags.FFlagDebugEnablePopForcePicker then React.createElement(require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PopForcePicker"), {
		LayoutOrder = 3
	}) else nil
	children.PopForcePicker = v22

	local v23 = if props.secondaryPlayButtonState then React.createElement(
		PlayButtonView,
		makePlayButtonProps(
			props,
			props.secondaryPlayButtonState,
			props.onSecondaryPlayButtonActivated or fn,
			nil,
			nil,
			v9,
			2,
			v10
		)
	) else nil
	children.SecondaryPlayButton = v23
	return createElement("Frame", v12, children)
end

return React.memo(PlayButtonGroupView)
