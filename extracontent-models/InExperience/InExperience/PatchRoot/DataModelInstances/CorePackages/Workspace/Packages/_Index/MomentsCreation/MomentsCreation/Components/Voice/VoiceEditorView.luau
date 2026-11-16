local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Text = Foundation.Text
local TextArea = Foundation.TextArea
local View = Foundation.View

local InputSize = Foundation.Enums.InputSize
local InputVariant = Foundation.Enums.InputVariant
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local AudioWaveformOverlay = require(MomentsCreation.Components.Voice.AudioWaveformOverlay)
local VideoTimeline = require(MomentsCreation.Components.VideoTimeline)
local VoiceActionBar = require(MomentsCreation.Components.Voice.VoiceActionBar)
require(MomentsCreation.Types.CreationFlowTypes)

local GetFFlagMomentsTTSStartTimePositioning = require(MomentsCreation.Flags.GetFFlagMomentsTTSStartTimePositioning)
local FFlagMomentsTTSCompactActionBar = require(MomentsCreation.Flags.FFlagMomentsTTSCompactActionBar)
local size

if FFlagMomentsTTSCompactActionBar then
	size = InputSize.Medium
else
	size = InputSize.Large
end

local function VoiceEditorView(props)
	local v = useDeviceInsets()
	local v2 = useTokens()

	local isGenerating = props.isGenerating
	local isInputInvalid = props.isInputInvalid

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		tag = "col align-x-center align-y-top gap-xlarge size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v2.Padding.XLarge),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.XLarge))),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}

	local createElement2 = React.createElement
	local v4 = {
		playback = props.playback,
		capture = props.capture,
		interactive = true,
		dragOnly = GetFFlagMomentsTTSStartTimePositioning,
		onSeek = props.onTimelineSeek,
		playheadPosition = props.playheadPosition,
		layoutOrder = 1
	}
	local audioWaveform

	if props.showAudioWaveform then
		audioWaveform = React.createElement(AudioWaveformOverlay, {
			audioDuration = props.audioDuration,
			videoDuration = props.videoDuration,
			startTime = props.startTime,
			dragDetectorRef = props.waveformDragDetectorRef,
			isSelected = props.waveformSelected,
			samples = props.waveformSamples
		})
	end

	local children = {
		Timeline = createElement2(VideoTimeline, v4, { AudioWaveform = audioWaveform }),
		ComposerSection = 0,
		ActionButton = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v5 = {
		LayoutOrder = 1,
		tag = {
			["col size-full-0 auto-y"] = props.showVoiceSelector,
			["size-full-0 auto-y"] = not props.showVoiceSelector
		},
		stroke = 0,
		cornerRadius = 0,
		onAbsoluteSizeChanged = 0,
		ref = 0
	}
	local color

	if isInputInvalid then
		color = v2.Color.System.Alert.Color3
	else
		color = v2.Color.Stroke.Emphasis.Color3
	end

	v5.stroke = {
		Color = color,
		Transparency = isInputInvalid and 0 or v2.Color.Stroke.Emphasis.Transparency,
		Thickness = v2.Stroke.Standard
	}

	v5.cornerRadius = UDim.new(0, v2.Radius.Medium)
	v5.onAbsoluteSizeChanged = props.onComposerResize
	v5.ref = props.composerContainerRef
	local v6 = {
		Composer = React.createElement(TextArea, {
			LayoutOrder = 1,
			text = props.text,
			width = UDim.new(1, 0),
			placeholder = props.placeholderText,
			numLines = props.numLines,
			label = "",
			size = InputSize.Medium,
			variant = InputVariant.Utility,
			onChanged = props.onTextChanged,
			onFocusLost = props.onTextBoxFocusLost,
			isDisabled = isGenerating,
			textBoxRef = props.textBoxRef
		}),
		VoicePill = 0
	}
	local voicePill

	if props.showVoiceSelector then
		voicePill = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-xy",
			padding = {
				top = UDim.new(0, v2.Padding.Small),
				bottom = UDim.new(0, v2.Padding.Small),
				left = UDim.new(0, v2.Padding.Small),
				right = UDim.new(0, v2.Padding.Small)
			}
		}, {
			Pill = React.createElement(View, {
				ref = props.voiceSelectorButtonRef,
				onActivated = props.onOpenVoiceSelector,
				stateLayer = { affordance = StateLayerAffordance.Background },
				tag = "row align-y-center gap-small auto-xy radius-circle bg-surface-300",
				padding = {
					top = UDim.new(0, v2.Padding.Small),
					bottom = UDim.new(0, v2.Padding.Small),
					left = UDim.new(0, v2.Padding.Medium),
					right = UDim.new(0, v2.Padding.Medium)
				}
			}, {
				Label = React.createElement(Text, {
					LayoutOrder = 1,
					tag = "auto-xy text-label-small content-emphasis",
					Text = props.selectedVoiceName or ""
				}),
				Chevron = React.createElement(Icon, {
					LayoutOrder = 2,
					name = BuilderIcons.Icon.ChevronSmallDown,
					size = Foundation.Enums.IconSize.Small,
					style = v2.Color.Content.Default
				})
			})
		})
	end

	v6.VoicePill = voicePill
	children.ComposerSection = createElement3(View, {
		LayoutOrder = 2,
		tag = "col size-full-0 auto-y"
	}, {
		InputContainer = createElement4(View, v5, v6),
		HelperRow = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row flex-x-between align-y-center size-full-0 auto-y",
			padding = { top = UDim.new(0, v2.Gap.Small) }
		}, {
			HelperText = React.createElement(Text, {
				LayoutOrder = 1,
				tag = {
					["auto-xy text-caption-small content-alert"] = isInputInvalid,
					["auto-xy text-caption-small content-default"] = not isInputInvalid
				},
				Text = props.helperText
			}),
			CharCount = React.createElement(Text, {
				LayoutOrder = 2,
				tag = {
					["auto-xy text-caption-small content-alert"] = props.isOverLimit,
					["auto-xy text-caption-small content-default"] = not props.isOverLimit
				},
				Text = `{props.charCount} / {props.maxChars}`
			})
		})
	})
	local actionButton

	if props.showDelete then
		local createElement5 = React.createElement
		local v7 = {
			layoutOrder = 3,
			onDelete = props.onDelete,
			primaryRef = props.createButtonRef,
			deleteRef = props.deleteButtonRef,
			primaryText = 0,
			primaryOnActivated = 0,
			primaryIsDisabled = 0,
			primaryIsLoading = 0,
			primaryVariant = 0
		}
		local primaryText

		if props.showSave then
			primaryText = props.saveText
		else
			primaryText = isGenerating and "" or props.createText
		end

		v7.primaryText = primaryText
		local primaryOnActivated

		if props.showSave then
			primaryOnActivated = props.onSave
		else
			primaryOnActivated = props.onCreateVoiceover
		end

		v7.primaryOnActivated = primaryOnActivated
		v7.primaryIsDisabled = not props.showSave and not (props.canGenerate or isGenerating)
		v7.primaryIsLoading = not props.showSave and isGenerating
		local primaryVariant

		if props.showSave or props.canGenerate or isGenerating then
			primaryVariant = Foundation.Enums.ButtonVariant.Emphasis
		else
			primaryVariant = Foundation.Enums.ButtonVariant.Standard
		end

		v7.primaryVariant = primaryVariant
		actionButton = createElement5(VoiceActionBar, v7)
	elseif props.showSave then
		actionButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 3,
			onActivated = props.onSave,
			size = size,
			text = props.saveText,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			width = UDim.new(1, 0)
		})
	else
		local createElement5 = React.createElement
		local v7 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0),
			ref = props.createButtonRef
		}

		local createElement6 = React.createElement
		local v8 = {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isDisabled = not (props.canGenerate or isGenerating),
			isLoading = isGenerating,
			onActivated = props.onCreateVoiceover,
			size = size,
			text = isGenerating and "" or props.createText,
			variant = 0,
			width = 0
		}
		local variant

		if props.canGenerate or isGenerating then
			variant = Foundation.Enums.ButtonVariant.Emphasis
		else
			variant = Foundation.Enums.ButtonVariant.Standard
		end

		v8.variant = variant

		v8.width = UDim.new(1, 0)
		actionButton = createElement5("Frame", v7, { Button = createElement6(Button, v8) })
	end

	children.ActionButton = actionButton
	return createElement(View, v3, children)
end

return VoiceEditorView
