local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Button = Foundation.Button
local Loading = Foundation.Loading
local View = Foundation.View
local GradientBackdrop = MomentsCommon.GradientBackdrop
local MusicPreviewItem = require(MomentsCreationFlow.Components.MusicPreviewItem)
local Waveform = require(MomentsCreationFlow.Components.Waveform)
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useMusicEditorController = require(MomentsCreationFlow.Hooks.useMusicEditorController)
local useToggleState = MomentsCommon.Hooks.useToggleState
local useTokens = Foundation.Hooks.useTokens
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)
local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local uDim2 = UDim2.new(0, 48, 1, 0)

local function MusicEditor(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), useDeviceInsets (copy), React (copy), CreationFlowContext (copy), useToggleState (copy), useCallback (copy), useMusicEditorController (copy), View (copy), Button (copy), Foundation (copy), CreationFlowLocalization (copy), GradientBackdrop (copy), uDim2 (copy), SegmentSelectorWidth (copy), Waveform (copy), Loading (copy), MusicPreviewItem (copy)
	local v24 = useTokens()
	local v25 = useDeviceInsets()
	local v26 = React.useContext(CreationFlowContext)
	local v27 = useToggleState(false)
	local v28 = useToggleState(false)
	local v29 = useCallback(function() -- line: 51
		-- upvalues: t1 (copy), v28 (copy)
		t1.playbackController.volume.mute()
		t1.playbackController.timeline.seek(0)
		t1.playbackController.playback.pause()
		v28.enable()
	end, { t1.playbackController.timeline.seek })
	local v30 = useCallback(function() -- line: 58
		-- upvalues: t1 (copy), v28 (copy)
		t1.playbackController.volume.unmute()
		t1.playbackController.playback.play()
		v28.disable()
	end, {})
	local v31 = useCallback(function() -- line: 64
		-- upvalues: t1 (copy), v27 (copy)
		t1.playbackController.volume.unmute()
		t1.playbackController.playback.play()
		v27.enable()
	end, {})

	React.useEffect(function() -- line: 70
		-- upvalues: v27 (copy)
		v27.disable()
	end, { t1.musicEdit.assetId })

	local v32 = useMusicEditorController(v27.enabled, v30, v29, t1.onStartTimeChanged, t1.musicEdit, t1.playbackController.audio.timeLength)
	local waveformRef = v32.waveformRef
	local waveformPosition = v32.waveformPosition
	local waveformDisplayRef = v32.waveformDisplayRef

	return React.createElement(View, {
		tag = "auto-y align-x-center align-y-top anchor-bottom-center bg-surface-100 col gap-large position-bottom-center radius-medium size-full-0",
		ZIndex = 5
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v24.Padding.Small),
			PaddingBottom = UDim.new(0, (math.max(v25.bottom, v24.Padding.Small))),
			PaddingLeft = UDim.new(0, (math.max(v25.left, v24.Padding.Large))),
			PaddingRight = UDim.new(0, (math.max(v25.right, v24.Padding.Large)))
		}),
		Nav = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
		}, {
			BackButton = React.createElement(Button, {
				ZIndex = 6,
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v26.getLocalization(CreationFlowLocalization.GeneralCtaBack),
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = t1.onBack,
				size = Foundation.Enums.InputSize.Medium
			}),
			DoneButton = React.createElement(Button, {
				ZIndex = 6,
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v26.getLocalization(CreationFlowLocalization.GeneralCtaDone),
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = t1.onDone,
				size = Foundation.Enums.InputSize.Medium
			})
		}),
		SegmentSelector = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-1600"
		}, {
			Timeline = React.createElement(View, {
				tag = "clip size-full-full",
				ZIndex = 1
			}, {
				DragDetector = React.createElement("UIDragDetector", {
					DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
					ref = waveformRef,
					ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
				}),
				LeftGradientBackdrop = React.createElement(GradientBackdrop, {
					rotation = 0,
					startingTransparency = 0,
					zIndex = 2,
					color3 = v24.Color.Surface.Surface_100.Color3,
					size = uDim2
				}),
				RightGradientBackdrop = React.createElement(GradientBackdrop, {
					rotation = 180,
					startingTransparency = 0,
					zIndex = 2,
					anchorPoint = Vector2.new(1, 0),
					color3 = v24.Color.Surface.Surface_100.Color3,
					position = UDim2.fromScale(1, 0),
					size = uDim2
				}),
				WaveformContainer = React.createElement(View, {
					tag = "anchor-center-center position-center-center radius-medium",
					Size = UDim2.new(0, SegmentSelectorWidth, 1, 0)
				}, {
					WaveformDisplay = React.createElement(Waveform, {
						zIndex = 1,
						audioAssetId = t1.musicEdit.assetId,
						position = waveformPosition:map(function(p1) -- line: 161
							return UDim2.fromScale(p1, 0.5)
						end),
						onWaveformReady = v31,
						ref = waveformDisplayRef,
						videoDuration = t1.playbackController.timeline.duration
					})
				})
			}),
			SegmentOutline = React.createElement(View, {
				tag = "anchor-center-center position-center-center radius-medium",
				ZIndex = 2,
				Size = UDim2.new(0, SegmentSelectorWidth, 1, -v24.Size.Size_100)
			}, {
				Scrubber = if not v27.enabled or v28.enabled then nil else React.createElement(View, {
					tag = "anchor-center-center bg-system-contrast size-100-1900 radius-circle",
					Position = UDim2.fromScale(t1.playbackController.timeline.elapsed / t1.playbackController.timeline.duration, 0.5)
				}),
				LoadingIndicator = if v27.enabled then nil else React.createElement(Loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					size = Foundation.Enums.IconSize.Medium
				}),
				OutlineStroke = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = v24.Color.System.Contrast.Color3,
					Transparency = v24.Color.System.Contrast.Transparency,
					Thickness = v24.Stroke.Thick
				})
			})
		}),
		MusicPreviewItemWrapper = React.createElement(View, {
			tag = "auto-y size-full-0",
			LayoutOrder = 3
		}, {
			MusicPreviewItem = React.createElement(MusicPreviewItem, {
				musicAssetId = t1.musicEdit.assetId
			})
		})
	})
end

return MusicEditor
