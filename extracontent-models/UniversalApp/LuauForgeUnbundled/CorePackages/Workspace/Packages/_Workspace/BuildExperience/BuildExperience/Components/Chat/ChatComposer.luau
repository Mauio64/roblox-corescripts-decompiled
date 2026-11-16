require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local v5 = if FFlagBuildExperienceModelPicker then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerContainer") else nil

local ChatActionsRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatActionsRow")
local v6 = if require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceUseCommonTextArea") then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppBlox").Composer else require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/TextArea")
local useReleaseFocusOnDownSwipe = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/useReleaseFocusOnDownSwipe")

local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function trimMessage(value)
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local function ChatComposer(props)
	local v7 = useTokens()
	local ref = React.useRef(nil)
	local v8 = React.useMemo(function()
		local value = props.text:getValue()
		local v9 = string.gsub(value, "^%s*(.-)%s*$", "%1") == ""

		local signal, v10 = Signals.createSignal(v9)
		return { getIsComposerEmpty = signal, setIsComposerEmpty = v10 }
	end, { props.text })

	local v9 = props.isAssistantResponding and props.canSendWhileResponding ~= true
	local v10

	if fFlagBuildExperienceLibrary and props.allowsTypingWhileResponding == true then
		v10 = v9
		v9 = false
	else
		v10 = false
	end

	local modelPicker = if FFlagBuildExperienceModelPicker then props.modelPicker else nil
	local isReadOnly = props.isReadOnly == true

	local v12 = props.composerErrorText ~= nil
	local v13 = not (props.images == nil) and #props.images > 0
	local v14 = props.isAttachmentSupported and props.onOpenCaptureGallery ~= nil

	local v15 = React.useCallback(function(value)
		v8.setIsComposerEmpty(string.gsub(value, "^%s*(.-)%s*$", "%1") == "")
		props.onChanged(value)
	end, { props.onChanged, v8 })

	local useCallback = React.useCallback
	local function fn()
		if v10 then
			return
		end

		if props.onSend() then
			local setIsComposerEmpty = v8.setIsComposerEmpty
			local v16

			if FFlagBuildExperienceModelPicker then
				local value = props.text:getValue()
				v16 = string.gsub(value, "^%s*(.-)%s*$", "%1") == ""
			else
				v16 = true
			end

			setIsComposerEmpty(v16)
		end
	end
	local onSend = props.onSend
	local v18 = if FFlagBuildExperienceModelPicker then props.text else nil
	local v19 = useCallback(fn, { onSend, v8, v10, v18 })

	local v20 = React.useCallback(function()
		if props.textBoxRef ~= nil and props.textBoxRef.current ~= nil then
			props.textBoxRef.current.releaseFocus()
		end

		if props.onOpenCaptureGallery ~= nil then
			props.onOpenCaptureGallery()
		end
	end, { props.textBoxRef, props.onOpenCaptureGallery })

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			local function updateEmptyState(value)
				v8.setIsComposerEmpty(string.gsub(value, "^%s*(.-)%s*$", "%1") == "")
			end
			local __subscribeToBinding = React.__subscribeToBinding(props.text, updateEmptyState)
			local value = props.text:getValue()
			v8.setIsComposerEmpty(string.gsub(value, "^%s*(.-)%s*$", "%1") == "")

			return __subscribeToBinding
		end, { props.text, v8 })
	elseif fFlagBuildExperienceLibrary then
		React.useEffect(function()
			if not props.tracksExternalText then
				return nil
			end

			local function updateEmptyState(value)
				v8.setIsComposerEmpty(string.gsub(value, "^%s*(.-)%s*$", "%1") == "")
			end
			local __subscribeToBinding = React.__subscribeToBinding(props.text, updateEmptyState)
			local value = props.text:getValue()
			v8.setIsComposerEmpty(string.gsub(value, "^%s*(.-)%s*$", "%1") == "")

			return __subscribeToBinding
		end, { props.tracksExternalText, props.text, v8 })
	end

	useReleaseFocusOnDownSwipe(ref, props.textBoxRef)

	local v21 = FFlagBuildExperienceModelPicker
	local v22 = v7.Size.Size_100
	local v23, v24, v25

	if v21 then
		v22 = v7.Padding.Small - v7.Stroke.Standard
		v23 = "row align-y-center gap-small auto-xy"
		v24 = 1
		v25 = 3
	else
		v23 = "auto-xy"
	end

	local v26

	if v14 or modelPicker ~= nil then
		local createElement = React.createElement
		local v28 = {
			padding = {
				top = UDim.new(0, v7.Size.Size_200),
				bottom = UDim.new(0, v7.Size.Size_200 - 1),
				left = UDim.new(0, v22)
			},
			tag = v23
		}

		local v30 = if v14 then React.createElement(iconButton, {
			LayoutOrder = v24,
			icon = iconName.PlusSmall,
			isCircular = true,
			isDisabled = props.isAssistantResponding or isReadOnly,
			onActivated = v20,
			size = inputSize.Small,
			variant = buttonVariant.Standard,
			testId = "ChatComposer.AttachImage"
		}) else nil

		local v31 = if modelPicker ~= nil then React.createElement(v5, {
			LayoutOrder = 2,
			internalTesting = modelPicker.internalTesting,
			data = modelPicker.data,
			selectedId = modelPicker.selectedId,
			onSelect = modelPicker.onSelect,
			isDisabled = props.isAssistantResponding or isReadOnly or modelPicker.isDisabled == true
		}) else nil
		v26 = createElement(view, v28, { Attach = v30, Picker = v31 })
	end

	local createElement = React.createElement
	local v28 = {
		LayoutOrder = v25,
		padding = {
			top = UDim.new(0, v7.Size.Size_200),
			bottom = UDim.new(0, v7.Size.Size_200 - 1),
			left = UDim.new(0, 0),
			right = UDim.new(0, v22)
		},
		tag = { ["auto-xy"] = true }
	}

	local createElement2 = React.createElement
	local v31 = {
		isAssistantResponding = props.isAssistantResponding,
		canStopAssistantResponse = props.canStopAssistantResponse,
		canSendWhileResponding = props.canSendWhileResponding,
		getIsComposerEmpty = v8.getIsComposerEmpty,
		hasAttachments = v13,
		isSendDisabled = 0,
		isStopDisabled = 0,
		onSend = 0,
		onStop = 0
	}

	local v32 = if FFlagBuildExperienceModelPicker or not v12 then props.isSendBlocked == true or isReadOnly else v12
	v31.isSendDisabled = v32

	v31.isStopDisabled = isReadOnly
	v31.onSend = v19
	v31.onStop = props.onStop
	local element = createElement(view, v28, { Actions = createElement2(ChatActionsRow, v31) })
	local v33

	if v21 then
		v33 = React.createElement(view, {
			tag = "row align-y-center size-full-0 auto-y"
		}, {
			Leading = v26,
			Spacer = React.createElement(view, { LayoutOrder = 2, tag = "fill" }),
			Trailing = element
		})
	end

	local createElement3 = React.createElement
	local v35 = {
		text = props.text,
		onChanged = v15,
		label = "",
		hint = props.composerErrorText,
		hasError = v12,
		placeholder = props.placeholder or "",
		width = UDim.new(1, 0),
		size = inputSize.Large,
		maxLines = props.maxLines or 5,
		isDisabled = isReadOnly and true or v9,
		onReturnPressed = v19,
		textBoxRef = props.textBoxRef,
		ref = ref,
		composerDebug = props.composerDebug,
		LayoutOrder = props.LayoutOrder,
		leadingElement = 0,
		trailingElement = 0,
		footerElement = 0
	}

	if v21 then
		v26 = nil
	end

	v35.leadingElement = v26

	if v21 then
		element = nil
	end

	v35.trailingElement = element
	v35.footerElement = v33
	return createElement3(v6, v35)
end

return ChatComposer
