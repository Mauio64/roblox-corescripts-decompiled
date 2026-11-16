local parent = script:FindFirstAncestor("GamePlayButton").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUseTokenHeightForPlayButton = SharedFlags.FFlagLuaAppUseTokenHeightForPlayButton
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagEnableGameJoinEarlyAccess = SharedFlags.FFlagEnableGameJoinEarlyAccess

local ButtonHeightSizeKeyByInputSize = require(script.Parent.ButtonHeightSizeKeyByInputSize)
local PlayButtonView = require(script.Parent.PlayButtonView)

local function fn() end

local function makePlayButtonProps(props, playButtonState: string, onPlayButtonActivated, playButtonCaptureRef, loadingCaptureRef, fillBehavior, layoutOrder: number, testId: string?, tag: string?, showEarlyAccessTooltip: boolean?)
	if not FFlagEnableGameJoinEarlyAccess then
		showEarlyAccessTooltip = nil
	end

	local playButtonProps = {
		tag = tag,
		showEarlyAccessTooltip = showEarlyAccessTooltip,
		playButtonState = playButtonState,
		gameProductInfo = props.gameProductInfo,
		localized = props.localized,
		tokens = props.tokens,
		hasJoinTextPlayableButtonIxp = props.hasJoinTextPlayableButtonIxp,
		hasIconPlayButtonIxp = props.hasIconPlayButtonIxp,
		hasPlayButtonLoadingSkeletonIxp = props.hasPlayButtonLoadingSkeletonIxp,
		onPlayButtonActivated = onPlayButtonActivated,
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
	local earlyAccessCaption

	if FFlagEnableGameJoinEarlyAccess then
		earlyAccessCaption = props.earlyAccessCaption
	end

	playButtonProps.earlyAccessCaption = earlyAccessCaption
	local earlyAccessPending

	if FFlagEnableGameJoinEarlyAccess then
		earlyAccessPending = props.earlyAccessPending
	end

	playButtonProps.earlyAccessPending = earlyAccessPending
	playButtonProps.hidePlayableIcon = props.hidePlayableIcon
	playButtonProps.hideOptionalText = props.hideOptionalText
	playButtonProps.buttonSize = props.buttonSize
	playButtonProps.fillBehavior = fillBehavior
	playButtonProps.useUIBloxButton = props.useUIBloxButton
	playButtonProps.hideIfUnplayable = props.hideIfUnplayable
	playButtonProps.hideIfLoading = props.hideIfLoading
	playButtonProps.LayoutOrder = layoutOrder
	playButtonProps.testId = testId
	return playButtonProps
end

local function PlayButtonGroupView(props)
	local tokens = props.tokens
	local buttonSize = props.buttonSize or InputSize.Medium
	local v

	if FFlagLuaAppUseTokenHeightForPlayButton then
		local v2 = ButtonHeightSizeKeyByInputSize[buttonSize] or "Size_1000"
		v = not (tokens and tokens.Size[v2]) and 40 or tokens.Size[v2]
	else
		v = 0
	end

	local v2 = not tokens and 8 or tokens.Gap.Small
	local v3 = props.width

	if props.expandWidthForSecondaryPlayButton and props.secondaryPlayButtonState ~= nil and v3 ~= nil then
		v3 = UDim.new(v3.Scale * 2, v3.Offset * 2 + v2)
	end

	local v4 = if v3 then FillBehavior.Fill else props.fillBehavior
	local v5

	if props.secondaryPlayButtonState == nil and v3 == nil then
		v5 = v4
	elseif v4 == "Fill" then
		v5 = FillBehavior.Fill
	else
		v5 = FillBehavior.Fit
	end

	local v6

	if props.testId then
		v6 = `{props.testId}--secondary`
	end

	local createElement = React.createElement
	local v7 = {}
	v7.LayoutOrder = props.LayoutOrder
	v7.Position = props.Position
	local udim

	if FFlagLuaAppUseTokenHeightForPlayButton then
		if not v3 then
			if v4 == "Fill" then
				v3 = UDim.new(1, 0)
			else
				v3 = UDim.new(0, 0)
			end
		end

		udim = UDim2.new(v3, UDim.new(0, v))
	elseif v3 then
		udim = UDim2.new(v3, UDim.new(0, 0))
	elseif v4 == "Fill" then
		udim = UDim2.new(1, 0, 1, 0)
	end

	v7.Size = udim
	local automaticSize

	if FFlagLuaAppUseTokenHeightForPlayButton then
		if v4 ~= "Fill" then
			automaticSize = Enum.AutomaticSize.X
		end
	elseif v4 == "Fill" then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	v7.AutomaticSize = automaticSize

	v7.BackgroundTransparency = 1
	v7.BorderSizePixel = 0
	local tag = React.Tag
	local v8

	if not FFlagLuaAppMediaGalleryGamepadSupport then
		v8 = props.tag
	end

	v7[tag] = v8

	local createElement2 = React.createElement
	local v9 = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = 0,
		Padding = 0,
		SortOrder = 0
	}
	local horizontalFlex

	if v4 == "Fill" then
		horizontalFlex = Enum.UIFlexAlignment.Fill
	else
		horizontalFlex = Enum.UIFlexAlignment.None
	end

	v9.HorizontalFlex = horizontalFlex
	v9.Padding = UDim.new(0, v2)
	v9.SortOrder = Enum.SortOrder.LayoutOrder
	local children = {
		Layout = createElement2("UIListLayout", v9),
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
	local tag2

	if FFlagLuaAppMediaGalleryGamepadSupport then
		tag2 = props.tag
	end

	local v10

	if FFlagEnableGameJoinEarlyAccess then
		v10 = props.showEarlyAccessTooltip
	end

	children.PlayButton = createElement3(
		PlayButtonView,
		makePlayButtonProps(
			props,
			playButtonState,
			onPlayButtonActivated,
			playButtonCaptureRef,
			loadingCaptureRef,
			v5,
			1,
			testId,
			tag2,
			v10
		)
	)
	local popForcePicker

	if SharedFlags.FFlagDebugEnablePopForcePicker then
		local createElement4 = React.createElement
		local PopForcePicker = require(script.Parent.PopForcePicker)
		popForcePicker = createElement4(PopForcePicker, { LayoutOrder = 3 })
	end

	children.PopForcePicker = popForcePicker
	local secondaryPlayButton

	if props.secondaryPlayButtonState then
		secondaryPlayButton = React.createElement(
			PlayButtonView,
			makePlayButtonProps(
				props,
				props.secondaryPlayButtonState,
				props.onSecondaryPlayButtonActivated or fn,
				nil,
				nil,
				v5,
				2,
				v6
			)
		)
	end

	children.SecondaryPlayButton = secondaryPlayButton
	return createElement("Frame", v7, children)
end

return React.memo(PlayButtonGroupView)
