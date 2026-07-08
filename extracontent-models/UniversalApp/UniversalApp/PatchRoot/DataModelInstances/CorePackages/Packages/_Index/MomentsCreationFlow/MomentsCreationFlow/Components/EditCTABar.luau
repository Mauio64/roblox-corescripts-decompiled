local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local BuilderIcons = require(MomentsCreationFlowParent.BuilderIcons)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
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

return function(t1: {[any]: any}) -- line: 40
	-- upvalues: useDeviceInsets (copy), useTokens (copy), React (copy), CreationFlowContext (copy), useDispatch (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), EventNames (copy), View (copy), GradientBackdrop (copy), Icon (copy), ThreeBarsVerticalTrianglesHorizontal (copy), Foundation (copy), FoundationText (copy), CreationFlowLocalization (copy), MusicNote (copy), TextUppercaseALowercaseA (copy)
	local v23 = useDeviceInsets()
	local v24 = useTokens()
	local v25 = React.useContext(CreationFlowContext)
	local v26 = useDispatch()
	local v27, v28 = React.useBinding(UDim2.fromScale(1, 0))
	local v29 = React.useCallback(function(p1) -- line: 48
		-- upvalues: v28 (copy)
		v28(UDim2.new(0, 1.5 * p1.AbsoluteSize.X, 1, 0))
	end, {})
	local v30 = React.useCallback(function() -- line: 52
		-- upvalues: v26 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v25 (copy), EventNames (copy)
		v26(CreationFlowStateUpdated(CreationFlowState.Trimming))
		v25.fireEvent(EventNames.EditingFlowTrimButtonPressed)
	end)
	local v31 = React.useCallback(function() -- line: 57
		-- upvalues: v26 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v25 (copy), EventNames (copy)
		v26(CreationFlowStateUpdated(CreationFlowState.Music))
		v25.fireEvent(EventNames.EditingFlowMusicButtonPressed)
	end)
	local v32 = React.useCallback(function() -- line: 62
		-- upvalues: v26 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v25 (copy), EventNames (copy)
		v26(CreationFlowStateUpdated(CreationFlowState.TextOverlay))
		v25.fireEvent(EventNames.EditingFlowTextOverlayButtonPressed)
	end)

	return React.createElement(View, {
		tag = "auto-x anchor-center-right position-center-right size-0-full",
		ZIndex = t1.zIndex
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			rotation = 180,
			color3 = v24.Color.Common.Scrim.Color3,
			size = v27
		}),
		EditCTABar = React.createElement(View, {
			tag = "align-x-right align-y-center anchor-center-right auto-x col gap-small position-center-right size-0-full",
			onAbsoluteSizeChanged = v29
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v24.Padding.Large),
				PaddingRight = UDim.new(0, v23.right + v24.Padding.Large)
			}),
			TrimCTAButton = if t1.captureType ~= Enum.CaptureType.Video then nil else React.createElement(View, {
				LayoutOrder = 1,
				tag = "align-x-right align-y-center auto-xy row gap-medium padding-xsmall radius-medium",
				onActivated = v30
			}, {
				Icon = React.createElement(Icon, {
					LayoutOrder = 2,
					name = ThreeBarsVerticalTrianglesHorizontal,
					size = Foundation.Enums.IconSize.Large
				}),
				Text = if not t1.showText then nil else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-label-medium content-emphasis",
					Text = v25.getLocalization(CreationFlowLocalization.EditingCtaTrimming)
				})
			}),
			MusicCTAButton = if t1.captureType ~= Enum.CaptureType.Video and t1.captureType ~= Enum.CaptureType.Screenshot then nil else React.createElement(View, {
				LayoutOrder = 2,
				tag = "align-x-right align-y-center auto-xy row gap-medium padding-xsmall radius-medium",
				onActivated = v31
			}, {
				Icon = React.createElement(Icon, {
					LayoutOrder = 2,
					name = MusicNote,
					size = Foundation.Enums.IconSize.Large
				}),
				Text = if not t1.showText then nil else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-label-medium content-emphasis",
					Text = v25.getLocalization(CreationFlowLocalization.EditingCtaMusic)
				})
			}),
			TextOverlayCTAButton = if t1.captureType ~= Enum.CaptureType.Video then nil else React.createElement(View, {
				LayoutOrder = 3,
				tag = "align-x-right align-y-center auto-xy row gap-medium padding-xsmall radius-medium",
				onActivated = v32
			}, {
				Icon = React.createElement(Icon, {
					LayoutOrder = 2,
					name = TextUppercaseALowercaseA,
					size = Foundation.Enums.IconSize.Large
				}),
				Text = if not t1.showText then nil else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-label-medium content-emphasis",
					Text = v25.getLocalization(CreationFlowLocalization.EditingCtaTextOverlay)
				})
			})
		})
	})
end
