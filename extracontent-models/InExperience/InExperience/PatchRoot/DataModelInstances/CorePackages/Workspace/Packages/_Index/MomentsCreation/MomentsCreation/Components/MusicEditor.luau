local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local Button = Foundation.Button
local Loading = Foundation.Loading
local View = Foundation.View
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local MusicPreviewItem = require(MomentsCreation.Components.MusicPreviewItem)
local Waveform = require(MomentsCreation.Components.Waveform)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useToggleState = MomentsCommon.Hooks.useToggleState
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useMusicEditorController = require(MomentsCreation.Hooks.useMusicEditorController)
local useMusicInfo = require(MomentsCreation.Hooks.useMusicInfo)
local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local uDim2 = UDim2.new(0, 48, 1, 0)

local function MusicEditor(t1: {[any]: any}) -- line: 59
	-- upvalues: useTokens (copy), useDeviceInsets (copy), useCreationFlowStrings (copy), useToggleState (copy), useMusicInfo (copy), React (copy), useEffect (copy), Signals (copy), useCallback (copy), useMusicEditorController (copy), useMemo (copy), useSignalBinding (copy), View (copy), Button (copy), Foundation (copy), GradientBackdrop (copy), uDim2 (copy), SegmentSelectorWidth (copy), Waveform (copy), Loading (copy), MusicPreviewItem (copy)
	local playback = t1.controller.preview.playback
	local v30 = useTokens()
	local v31 = useDeviceInsets()
	local v32 = useCreationFlowStrings()
	local v33 = useToggleState(false)
	local v34 = useToggleState(false)
	local v35 = useMusicInfo(t1.musicEdit.assetId)
	local v36 = (v35 == nil or v35.Duration == nil) and 0 or v35.Duration
	local v37, v38 = React.useState(playback.getDuration(false))

	useEffect(function() -- line: 73
		-- upvalues: Signals (copy), v38 (copy), playback (copy)
		return Signals.createEffect(function(p1) -- line: 74
			-- upvalues: v38 (copy), playback (copy)
			v38(playback.getDuration(p1))
		end)
	end, { playback })

	local v39 = useCallback(function() -- line: 79
		-- upvalues: playback (copy), v34 (copy)
		playback.setMuted(true)
		playback.seek(0)
		playback.pause()
		v34.enable()
	end, {
		playback,
		v34.enable
	})
	local v40 = useCallback(function() -- line: 86
		-- upvalues: playback (copy), v34 (copy)
		playback.setMuted(false)
		playback.play()
		v34.disable()
	end, {
		playback,
		v34.disable
	})
	local v41 = useCallback(function() -- line: 92
		-- upvalues: playback (copy), v33 (copy)
		playback.setMuted(false)
		playback.play()
		v33.enable()
	end, {
		playback,
		v33.enable
	})

	useEffect(function() -- line: 98
		-- upvalues: v33 (copy)
		v33.disable()
	end, {
		t1.musicEdit.assetId,
		v33.disable
	})

	local v42 = useMusicEditorController(v33.enabled, v40, v39, t1.onStartTimeChanged, t1.musicEdit, v36)
	local waveformRef = v42.waveformRef
	local waveformPosition = v42.waveformPosition
	local waveformDisplayRef = v42.waveformDisplayRef
	local v46 = useMemo(function() -- line: 116
		-- upvalues: Signals (copy), playback (copy)
		return Signals.createComputed(function(p2) -- line: 117
			-- upvalues: playback (copy)
			local v52 = playback.getDuration(p2)

			if v52 <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p2) / v52, 0, 1))
		end)
	end, { playback })
	local v47 = useSignalBinding(v46)

	return React.createElement(View, {
		tag = "col align-x-center align-y-top gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v30.Padding.Small),
			bottom = UDim.new(0, (math.max(v31.bottom, v30.Padding.Small))),
			left = UDim.new(0, (math.max(v31.left, v30.Padding.Large))),
			right = UDim.new(0, (math.max(v31.right, v30.Padding.Large)))
		}
	}, {
		Nav = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		}, {
			BackButton = React.createElement(Button, {
				ZIndex = 6,
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v32.GeneralCtaBack,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = t1.onBack,
				size = Foundation.Enums.InputSize.Medium
			}),
			DoneButton = React.createElement(Button, {
				ZIndex = 6,
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v32.GeneralCtaDone,
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
				tag = "size-full-full clip",
				ZIndex = 1
			}, {
				DragDetector = React.createElement("UIDragDetector", {
					CursorIcon = "",
					DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
					ref = waveformRef,
					ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
				}),
				LeftGradientBackdrop = React.createElement(GradientBackdrop, {
					rotation = 0,
					startingTransparency = 0,
					zIndex = 2,
					color3 = v30.Color.Surface.Surface_100.Color3,
					size = uDim2
				}),
				RightGradientBackdrop = React.createElement(GradientBackdrop, {
					rotation = 180,
					startingTransparency = 0,
					zIndex = 2,
					anchorPoint = Vector2.new(1, 0),
					color3 = v30.Color.Surface.Surface_100.Color3,
					position = UDim2.fromScale(1, 0),
					size = uDim2
				}),
				WaveformContainer = React.createElement(View, {
					tag = "position-center-center anchor-center-center radius-medium",
					Size = UDim2.new(0, SegmentSelectorWidth, 1, 0)
				}, {
					WaveformDisplay = React.createElement(Waveform, {
						zIndex = 1,
						audioAssetId = t1.musicEdit.assetId,
						position = waveformPosition:map(function(p3) -- line: 203
							return UDim2.fromScale(p3, 0.5)
						end),
						onWaveformReady = v41,
						ref = waveformDisplayRef,
						videoDuration = v37
					})
				})
			}),
			SegmentOutline = React.createElement(View, {
				tag = "position-center-center anchor-center-center radius-medium",
				ZIndex = 2,
				Size = UDim2.new(0, SegmentSelectorWidth, 1, -v30.Size.Size_100),
				stroke = {
					Color = v30.Color.System.Contrast.Color3,
					Transparency = v30.Color.System.Contrast.Transparency,
					Thickness = v30.Stroke.Thick
				}
			}, {
				Scrubber = if not v33.enabled or v34.enabled then nil else React.createElement(View, {
					tag = "anchor-center-center size-100-1900 radius-circle bg-system-contrast",
					Position = v47:map(function(p4) -- line: 227
						return UDim2.fromScale(p4, 0.5)
					end)
				}),
				LoadingIndicator = if v33.enabled then nil else React.createElement(Loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					size = Foundation.Enums.IconSize.Medium
				})
			})
		}),
		MusicPreviewItemWrapper = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 3
		}, {
			MusicPreviewItem = React.createElement(MusicPreviewItem, {
				layoutOrder = 1,
				isPreviewing = false,
				musicAssetId = t1.musicEdit.assetId
			})
		})
	})
end

return MusicEditor
