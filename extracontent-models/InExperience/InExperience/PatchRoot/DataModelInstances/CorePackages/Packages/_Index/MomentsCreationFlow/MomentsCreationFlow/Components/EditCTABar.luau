local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local TextUppercaseALowercaseA = BuilderIcons.Icon.TextUppercaseALowercaseA
local ThreeBarsVerticalTrianglesHorizontal = BuilderIcons.Icon.ThreeBarsVerticalTrianglesHorizontal
local MusicNote = BuilderIcons.Icon.MusicNote

local GradientBackdrop = MomentsCommon.GradientBackdrop

local CreationFlowStateUpdated = require(MomentsCreationFlow.Actions.CreationFlowStateUpdated)

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useDispatch = MomentsCommon.Hooks.useDispatch
local useTokens = Foundation.Hooks.useTokens

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local CreationFlowState = require(MomentsCreationFlow.Enums.CreationFlowState)

local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)
local EventNames = require(MomentsCreationFlow.Analytics.EventNames)

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = React.useContext(CreationFlowContext)

	local v4 = useDispatch()
	local size, v5 = React.useBinding(UDim2.fromScale(1, 0))

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v5(UDim2.new(0, 1.5 * p.AbsoluteSize.X, 1, 0))
	end, {})

	local onActivated = React.useCallback(function()
		v4(CreationFlowStateUpdated(CreationFlowState.Trimming))
		v3.fireEvent(EventNames.EditingFlowTrimButtonPressed)
	end)

	local onActivated2 = React.useCallback(function()
		v4(CreationFlowStateUpdated(CreationFlowState.Music))
		v3.fireEvent(EventNames.EditingFlowMusicButtonPressed)
	end)

	local onActivated3 = React.useCallback(function()
		v4(CreationFlowStateUpdated(CreationFlowState.TextOverlay))
		v3.fireEvent(EventNames.EditingFlowTextOverlayButtonPressed)
	end)

	local createElement = React.createElement
	local v6 = {
		tag = "auto-x anchor-center-right position-center-right size-0-full",
		ZIndex = props.zIndex
	}
	local v7 = {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			color3 = v2.Color.Common.Scrim.Color3,
			rotation = 180,
			size = size
		}),
		EditCTABar = 0
	}

	local createElement2 = React.createElement

	local v8 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v2.Padding.Large),
			PaddingRight = UDim.new(0, v.right + v2.Padding.Large)
		}),
		TrimCTAButton = 0,
		MusicCTAButton = 0,
		TextOverlayCTAButton = 0
	}
	local trimCTAButton

	if props.captureType == Enum.CaptureType.Video then
		local createElement3 = React.createElement

		local v9 = {
			Icon = React.createElement(Icon, {
				name = ThreeBarsVerticalTrianglesHorizontal,
				LayoutOrder = 2,
				size = Foundation.Enums.IconSize.Large
			}),
			Text = 0
		}
		local text

		if props.showText then
			text = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-medium content-emphasis",
				Text = v3.getLocalization(CreationFlowLocalization.EditingCtaTrimming)
			})
		end

		v9.Text = text
		trimCTAButton = createElement3(
			View,
			{
				LayoutOrder = 1,
				onActivated = onActivated,
				tag = "align-x-right align-y-center auto-xy row gap-medium padding-xsmall radius-medium"
			},
			v9
		)
	end

	v8.TrimCTAButton = trimCTAButton
	local musicCTAButton

	if props.captureType == Enum.CaptureType.Video or props.captureType == Enum.CaptureType.Screenshot then
		local createElement3 = React.createElement

		local v9 = {
			Icon = React.createElement(Icon, {
				name = MusicNote,
				LayoutOrder = 2,
				size = Foundation.Enums.IconSize.Large
			}),
			Text = 0
		}
		local text

		if props.showText then
			text = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-medium content-emphasis",
				Text = v3.getLocalization(CreationFlowLocalization.EditingCtaMusic)
			})
		end

		v9.Text = text
		musicCTAButton = createElement3(
			View,
			{
				LayoutOrder = 2,
				onActivated = onActivated2,
				tag = "align-x-right align-y-center auto-xy row gap-medium padding-xsmall radius-medium"
			},
			v9
		)
	end

	v8.MusicCTAButton = musicCTAButton
	local textOverlayCTAButton

	if props.captureType == Enum.CaptureType.Video then
		local createElement3 = React.createElement

		local v9 = {
			Icon = React.createElement(Icon, {
				name = TextUppercaseALowercaseA,
				LayoutOrder = 2,
				size = Foundation.Enums.IconSize.Large
			}),
			Text = 0
		}
		local text

		if props.showText then
			text = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-medium content-emphasis",
				Text = v3.getLocalization(CreationFlowLocalization.EditingCtaTextOverlay)
			})
		end

		v9.Text = text
		textOverlayCTAButton = createElement3(
			View,
			{
				LayoutOrder = 3,
				onActivated = onActivated3,
				tag = "align-x-right align-y-center auto-xy row gap-medium padding-xsmall radius-medium"
			},
			v9
		)
	end

	v8.TextOverlayCTAButton = textOverlayCTAButton
	v7.EditCTABar = createElement2(
		View,
		{
			tag = "align-x-right align-y-center anchor-center-right auto-x col gap-small position-center-right size-0-full",
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		},
		v8
	)
	return createElement(View, v6, v7)
end
