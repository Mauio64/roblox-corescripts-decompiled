local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local button = Foundation.Button
local icon = Foundation.Icon
local text = Foundation.Text
local textArea = Foundation.TextArea
local view = Foundation.View

local inputSize = Foundation.Enums.InputSize
local inputVariant = Foundation.Enums.InputVariant
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local AudioWaveformOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/AudioWaveformOverlay")
local VideoTimeline = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/VideoTimeline")
local VoiceActionBar = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/VoiceActionBar")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local GetFFlagMomentsTTSStartTimePositioning = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSStartTimePositioning")
local v5 = if require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSCompactActionBar") then inputSize.Medium else inputSize.Large

local function VoiceEditorView(props)
	local v6 = useDeviceInsets()
	local v7 = useTokens()

	local isGenerating = props.isGenerating
	local isInputInvalid = props.isInputInvalid

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		tag = "col align-x-center align-y-top gap-xlarge size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v7.Padding.XLarge),
			bottom = UDim.new(0, (math.max(v6.bottom, v7.Padding.XLarge))),
			left = UDim.new(0, (math.max(v6.left, v7.Padding.XLarge))),
			right = UDim.new(0, (math.max(v6.right, v7.Padding.XLarge)))
		}
	}

	local createElement2 = React.createElement
	local v11 = {
		playback = props.playback,
		capture = props.capture,
		interactive = true,
		dragOnly = GetFFlagMomentsTTSStartTimePositioning,
		onSeek = props.onTimelineSeek,
		playheadPosition = props.playheadPosition,
		layoutOrder = 1
	}

	local v13 = if props.showAudioWaveform then React.createElement(AudioWaveformOverlay, {
		audioDuration = props.audioDuration,
		videoDuration = props.videoDuration,
		startTime = props.startTime,
		dragDetectorRef = props.waveformDragDetectorRef,
		isSelected = props.waveformSelected,
		samples = props.waveformSamples
	}) else nil
	local children = {
		Timeline = createElement2(VideoTimeline, v11, { AudioWaveform = v13 }),
		ComposerSection = 0,
		ActionButton = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v17 = {
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

	local v19 = if isInputInvalid then v7.Color.System.Alert.Color3 else v7.Color.Stroke.Emphasis.Color3
	v17.stroke = {
		Color = v19,
		Transparency = isInputInvalid and 0 or v7.Color.Stroke.Emphasis.Transparency,
		Thickness = v7.Stroke.Standard
	}

	v17.cornerRadius = UDim.new(0, v7.Radius.Medium)
	v17.onAbsoluteSizeChanged = props.onComposerResize
	v17.ref = props.composerContainerRef
	local v20 = {
		Composer = React.createElement(textArea, {
			LayoutOrder = 1,
			text = props.text,
			width = UDim.new(1, 0),
			placeholder = props.placeholderText,
			numLines = props.numLines,
			label = "",
			size = inputSize.Medium,
			variant = inputVariant.Utility,
			onChanged = props.onTextChanged,
			onFocusLost = props.onTextBoxFocusLost,
			isDisabled = isGenerating,
			textBoxRef = props.textBoxRef
		}),
		VoicePill = 0
	}

	local v21 = if props.showVoiceSelector then React.createElement(view, {
		LayoutOrder = 2,
		tag = "auto-xy",
		padding = {
			top = UDim.new(0, v7.Padding.Small),
			bottom = UDim.new(0, v7.Padding.Small),
			left = UDim.new(0, v7.Padding.Small),
			right = UDim.new(0, v7.Padding.Small)
		}
	}, {
		Pill = React.createElement(view, {
			ref = props.voiceSelectorButtonRef,
			onActivated = props.onOpenVoiceSelector,
			stateLayer = { affordance = stateLayerAffordance.Background },
			tag = "row align-y-center gap-small auto-xy radius-circle bg-surface-300",
			padding = {
				top = UDim.new(0, v7.Padding.Small),
				bottom = UDim.new(0, v7.Padding.Small),
				left = UDim.new(0, v7.Padding.Medium),
				right = UDim.new(0, v7.Padding.Medium)
			}
		}, {
			Label = React.createElement(text, {
				LayoutOrder = 1,
				tag = "auto-xy text-label-small content-emphasis",
				Text = props.selectedVoiceName or ""
			}),
			Chevron = React.createElement(icon, {
				LayoutOrder = 2,
				name = BuilderIcons.Icon.ChevronSmallDown,
				size = Foundation.Enums.IconSize.Small,
				style = v7.Color.Content.Default
			})
		})
	}) else nil
	v20.VoicePill = v21
	children.ComposerSection = createElement3(view, {
		LayoutOrder = 2,
		tag = "col size-full-0 auto-y"
	}, {
		InputContainer = createElement4(view, v17, v20),
		HelperRow = React.createElement(view, {
			LayoutOrder = 2,
			tag = "row flex-x-between align-y-center size-full-0 auto-y",
			padding = { top = UDim.new(0, v7.Gap.Small) }
		}, {
			HelperText = React.createElement(text, {
				LayoutOrder = 1,
				tag = {
					["auto-xy text-caption-small content-alert"] = isInputInvalid,
					["auto-xy text-caption-small content-default"] = not isInputInvalid
				},
				Text = props.helperText
			}),
			CharCount = React.createElement(text, {
				LayoutOrder = 2,
				tag = {
					["auto-xy text-caption-small content-alert"] = props.isOverLimit,
					["auto-xy text-caption-small content-default"] = not props.isOverLimit
				},
				Text = `{props.charCount} / {props.maxChars}`
			})
		})
	})
	local v22

	if props.showDelete then
		local createElement5 = React.createElement
		local v24 = {
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
		local v25 = if props.showSave then props.saveText else isGenerating and "" or props.createText
		v24.primaryText = v25
		local v26 = if props.showSave then props.onSave else props.onCreateVoiceover
		v24.primaryOnActivated = v26
		v24.primaryIsDisabled = not props.showSave and not (props.canGenerate or isGenerating)
		v24.primaryIsLoading = not props.showSave and isGenerating
		local v28 = if props.showSave or props.canGenerate or isGenerating then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard
		v24.primaryVariant = v28
		v22 = createElement5(VoiceActionBar, v24)
	elseif props.showSave then
		v22 = React.createElement(button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 3,
			onActivated = props.onSave,
			size = v5,
			text = props.saveText,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			width = UDim.new(1, 0)
		})
	else
		local createElement5 = React.createElement
		local v24 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0),
			ref = props.createButtonRef
		}

		local createElement6 = React.createElement
		local v27 = {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isDisabled = not (props.canGenerate or isGenerating),
			isLoading = isGenerating,
			onActivated = props.onCreateVoiceover,
			size = v5,
			text = isGenerating and "" or props.createText,
			variant = 0,
			width = 0
		}
		local v28 = if props.canGenerate or isGenerating then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard
		v27.variant = v28

		v27.width = UDim.new(1, 0)
		v22 = createElement5("Frame", v24, { Button = createElement6(button, v27) })
	end

	children.ActionButton = v22
	return createElement(view, v9, children)
end

return VoiceEditorView
