local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)

require(BuildExperience.Chat.chatTypes)
local ModelPickerContainer

if FFlagBuildExperienceModelPicker then
	ModelPickerContainer = require(BuildExperience.Components.ModelPicker.ModelPickerContainer)
else
	ModelPickerContainer = nil
end

local ChatActionsRow = require(script.Parent.ChatActionsRow)
local FFlagBuildExperienceUseCommonTextArea = require(BuildExperience.Flags.FFlagBuildExperienceUseCommonTextArea)
local v

if FFlagBuildExperienceUseCommonTextArea then
	local AppBlox = require(parent.AppBlox)
	v = AppBlox.Composer
else
	v = require(BuildExperience.FoundationFork.TextArea)
end

local useReleaseFocusOnDownSwipe = require(script.Parent.useReleaseFocusOnDownSwipe)

local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local function trimMessage(value: string) -- 5 equivalent calls inferred from this helper
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local function ChatComposer(props)
	local v2 = useTokens()
	local ref = React.useRef(nil)
	local v3 = React.useMemo(function()
		local v3 = trimMessage(props.text:getValue()) == "" -- inferred equivalent call
		local signal, setIsComposerEmpty = Signals.createSignal(v3)
		return { getIsComposerEmpty = signal, setIsComposerEmpty = setIsComposerEmpty }
	end, { props.text })

	local v4 = props.isAssistantResponding and props.canSendWhileResponding ~= true
	local v5

	if FFlagBuildExperienceLibrary and props.allowsTypingWhileResponding == true then
		v5 = v4
		v4 = false
	else
		v5 = false
	end

	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = props.modelPicker
	end

	local isReadOnly = props.isReadOnly == true

	local hasError = props.composerErrorText ~= nil
	local hasAttachments

	if props.images == nil then
		hasAttachments = false
	else
		hasAttachments = #props.images > 0
	end

	local v6 = props.isAttachmentSupported and props.onOpenCaptureGallery ~= nil

	local onChanged = React.useCallback(function(value: string)
		v3.setIsComposerEmpty(trimMessage(value) == "") -- inferred equivalent call
		props.onChanged(value)
	end, { props.onChanged, v3 })

	local useCallback = React.useCallback
	local function fn()
		if v5 then
			return
		end

		if props.onSend() then
			v3.setIsComposerEmpty(not FFlagBuildExperienceModelPicker or trimMessage(props.text:getValue()) == "") -- inferred equivalent call
		end
	end
	local onSend = props.onSend
	local v7

	if FFlagBuildExperienceModelPicker then
		v7 = props.text
	end

	local v8 = useCallback(fn, { onSend, v3, v5, v7 })

	local onActivated = React.useCallback(function()
		if props.textBoxRef ~= nil and props.textBoxRef.current ~= nil then
			props.textBoxRef.current.releaseFocus()
		end

		if props.onOpenCaptureGallery ~= nil then
			props.onOpenCaptureGallery()
		end
	end, { props.textBoxRef, props.onOpenCaptureGallery })

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			local function updateEmptyState(value: string) -- 1 equivalent call inferred from this helper
				v3.setIsComposerEmpty(trimMessage(value) == "") -- inferred equivalent call
			end
			local __subscribeToBinding = React.__subscribeToBinding(props.text, updateEmptyState)
			updateEmptyState(props.text:getValue()) -- inferred equivalent call
			return __subscribeToBinding
		end, { props.text, v3 })
	elseif FFlagBuildExperienceLibrary then
		React.useEffect(function()
			if not props.tracksExternalText then
				return nil
			end

			local function updateEmptyState(value: string) -- 1 equivalent call inferred from this helper
				v3.setIsComposerEmpty(trimMessage(value) == "") -- inferred equivalent call
			end
			local __subscribeToBinding = React.__subscribeToBinding(props.text, updateEmptyState)
			updateEmptyState(props.text:getValue()) -- inferred equivalent call
			return __subscribeToBinding
		end, { props.tracksExternalText, props.text, v3 })
	end

	useReleaseFocusOnDownSwipe(ref, props.textBoxRef)

	local v9 = FFlagBuildExperienceModelPicker
	local v10 = v2.Size.Size_100
	local tag, layoutOrder, layoutOrder2

	if v9 then
		v10 = v2.Padding.Small - v2.Stroke.Standard
		tag = "row align-y-center gap-small auto-xy"
		layoutOrder = 1
		layoutOrder2 = 3
	else
		tag = "auto-xy"
	end

	local v11

	if v6 or modelPicker ~= nil then
		local createElement = React.createElement
		local v12 = {
			padding = {
				top = UDim.new(0, v2.Size.Size_200),
				bottom = UDim.new(0, v2.Size.Size_200 - 1),
				left = UDim.new(0, v10)
			},
			tag = tag
		}
		local attach

		if v6 then
			attach = React.createElement(IconButton, {
				LayoutOrder = layoutOrder,
				icon = IconName.PlusSmall,
				isCircular = true,
				isDisabled = props.isAssistantResponding or isReadOnly,
				onActivated = onActivated,
				size = InputSize.Small,
				variant = ButtonVariant.Standard,
				testId = "ChatComposer.AttachImage"
			})
		end

		local picker

		if modelPicker ~= nil then
			picker = React.createElement(ModelPickerContainer, {
				LayoutOrder = 2,
				internalTesting = modelPicker.internalTesting,
				data = modelPicker.data,
				selectedId = modelPicker.selectedId,
				onSelect = modelPicker.onSelect,
				isDisabled = props.isAssistantResponding or isReadOnly or modelPicker.isDisabled == true
			})
		end

		v11 = createElement(View, v12, { Attach = attach, Picker = picker })
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = layoutOrder2,
		padding = {
			top = UDim.new(0, v2.Size.Size_200),
			bottom = UDim.new(0, v2.Size.Size_200 - 1),
			left = UDim.new(0, 0),
			right = UDim.new(0, v10)
		},
		tag = { ["auto-xy"] = true }
	}

	local createElement2 = React.createElement
	local v13 = {
		isAssistantResponding = props.isAssistantResponding,
		canStopAssistantResponse = props.canStopAssistantResponse,
		canSendWhileResponding = props.canSendWhileResponding,
		getIsComposerEmpty = v3.getIsComposerEmpty,
		hasAttachments = hasAttachments,
		isSendDisabled = 0,
		isStopDisabled = 0,
		onSend = 0,
		onStop = 0
	}
	local isSendDisabled

	if FFlagBuildExperienceModelPicker or not hasError then
		isSendDisabled = props.isSendBlocked == true or isReadOnly
	else
		isSendDisabled = hasError
	end

	v13.isSendDisabled = isSendDisabled

	v13.isStopDisabled = isReadOnly
	v13.onSend = v8
	v13.onStop = props.onStop
	local element = createElement(View, v12, {
		Actions = createElement2(ChatActionsRow, v13)
	})
	local footerElement

	if v9 then
		footerElement = React.createElement(View, { tag = "row align-y-center size-full-0 auto-y" }, {
			Leading = v11,
			Spacer = React.createElement(View, { LayoutOrder = 2, tag = "fill" }),
			Trailing = element
		})
	end

	local createElement3 = React.createElement
	local v14 = {
		text = props.text,
		onChanged = onChanged,
		label = "",
		hint = props.composerErrorText,
		hasError = hasError,
		placeholder = props.placeholder or "",
		width = UDim.new(1, 0),
		size = InputSize.Large,
		maxLines = props.maxLines or 5,
		isDisabled = isReadOnly and true or v4,
		onReturnPressed = v8,
		textBoxRef = props.textBoxRef,
		ref = ref,
		composerDebug = props.composerDebug,
		LayoutOrder = props.LayoutOrder,
		leadingElement = 0,
		trailingElement = 0,
		footerElement = 0
	}

	if v9 then
		v11 = nil
	end

	v14.leadingElement = v11

	if v9 then
		element = nil
	end

	v14.trailingElement = element
	v14.footerElement = footerElement
	return createElement3(v, v14)
end

return ChatComposer
