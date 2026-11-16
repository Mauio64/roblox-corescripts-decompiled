require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")

local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")
local FFlagBuildEnableFTUXChips = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEnableFTUXChips")

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipExhaustedTelemetry")

local v5 = if FFlagBuildExperienceChatImageAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/isImageAttachmentSupported") else nil

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local v6 = if FFlagBuildExperienceChatImageAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Moments/createGalleryCaptureSource") else nil

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local v7 = if FFlagBuildExperienceChatImageAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGalleryContainer") else nil

local ChatComposer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatComposer")

local v8 = if FFlagBuildExperienceChatImageAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatImagePreviewList") else nil

local PromptChipGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/PromptChipGroup")

local fFlagBuildExperienceChatResourceAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceChatResourceAttachments

local v9 = if fFlagBuildExperienceChatResourceAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatResourceAttachmentList") else nil

local view = Foundation.View

local function ChatActions(props)
	local images = props.images or {}
	local resourceAttachments = props.resourceAttachments or {}
	local promptChips = props.promptChips or {}
	local v10 = FFlagBuildExperienceChatImageAttachments and #images > 0
	local v11 = fFlagBuildExperienceChatResourceAttachments and #resourceAttachments > 0
	local v12 = FFlagBuildEnableFTUXChips and (#promptChips > 0 or props.isPromptChipsLoading == true)
	local v13 = v11 and (v10 and 3 or 2) or v10 and 2 or 1
	local state, setState, ref, ref2

	if FFlagBuildExperienceChatImageAttachments then
		state, setState = React.useState("unmounted")

		ref = React.useRef(nil)

		ref2 = React.useRef(false)
	else
		ref = nil
		ref2 = nil
		setState = nil
		state = "unmounted"
	end

	local v14 = FFlagBuildExperienceChatImageAttachments

	if v14 then
		v14 = not (props.allowImageAttachments == false) and v5()
	end

	local function setCapturedImages(items)
		if props.onImagesChanged == nil then
			return
		end

		local v15 = {}

		for k, item in items do
			local v16 = nil

			for k2, image in images do
				if image.capture == item then
					v16 = image
					break
				end
			end

			table.insert(v15, v16 or { capture = item })
		end

		props.onImagesChanged(v15)
	end

	local function openCaptureGallery()
		if ref == nil or ref2 == nil or setState == nil then
			return
		end

		ref2.current = true
		ref.current = v6(nil, nil, { Enum.CaptureType.Screenshot })
		setState("open")
	end

	local function requestCloseCaptureGallery()
		if setState ~= nil then
			setState("closing")
		end
	end

	local function confirmCaptureGallery(p2)
		setCapturedImages(p2)

		if setState ~= nil then
			setState("closing")
		end
	end

	local function handleCaptureGalleryClosed()
		if setState ~= nil then
			setState("unmounted")
		end
	end

	local function removeImage(p2)
		if props.onImagesChanged == nil then
			return
		end

		local clone = table.clone(images)
		table.remove(clone, p2)
		props.onImagesChanged(clone)
	end

	local captures = {}

	for k, image in images do
		if image.capture ~= nil then
			table.insert(captures, image.capture)
		end
	end

	local createElement = React.createElement
	local v16 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-small size-full-0 auto-y"
	}

	local v18 = if v11 then React.createElement(v9, {
		LayoutOrder = 1,
		attachments = resourceAttachments,
		onRemove = props.onRemoveResourceAttachment,
		onActivateAttachment = props.onActivateResourceAttachment,
		testId = "ChatActions.ResourceAttachments"
	}) else nil

	local v19 = if v10 then React.createElement(v8, {
		LayoutOrder = v11 and 2 or 1,
		images = images,
		onRemove = removeImage,
		onRetry = props.onRetryImage,
		testId = "ChatActions.Images"
	}) else nil

	local createElement2 = React.createElement

	local v22 = if FFlagBuildExperienceModelPicker then props.modelPicker else nil
	local v21 = {
		LayoutOrder = v13,
		modelPicker = v22,
		text = props.composerText,
		composerErrorText = props.composerErrorText,
		onChanged = props.onComposerChanged,
		placeholder = props.placeholder,
		textBoxRef = props.textBoxRef,
		isAssistantResponding = props.isAssistantResponding,
		canStopAssistantResponse = props.canStopAssistantResponse,
		canSendWhileResponding = props.canSendWhileResponding,
		allowsTypingWhileResponding = props.allowsTypingWhileResponding,
		images = if FFlagBuildExperienceChatImageAttachments then images else nil,
		isSendBlocked = props.isSendBlocked,
		isReadOnly = props.isReadOnly,
		tracksExternalText = props.tracksExternalText,
		isAttachmentSupported = v14,
		onOpenCaptureGallery = 0,
		onSend = 0,
		onStop = 0,
		maxLines = 0,
		composerDebug = 0
	}

	if not v14 then
		openCaptureGallery = nil
	end

	v21.onOpenCaptureGallery = openCaptureGallery
	v21.onSend = props.onSend
	v21.onStop = props.onStop
	v21.maxLines = props.maxLines
	v21.composerDebug = props.composerDebug
	local v17 = {
		ResourceAttachments = v18,
		Images = v19,
		Composer = createElement2(ChatComposer, v21),
		PromptChips = 0,
		Gallery = 0
	}
	local v24

	if v12 then
		local createElement3 = React.createElement
		local v26 = {
			LayoutOrder = v13 + 1,
			promptChips = promptChips,
			isLoading = props.isPromptChipsLoading,
			onActivated = props.onPromptChipActivated,
			onExhausted = 0
		}

		local v27 = if FFlagBuildExperienceFTUXChipExhaustedTelemetry then props.onPromptChipExhausted else nil
		v26.onExhausted = v27
		v24 = createElement3(PromptChipGroup, v26)
	end

	v17.PromptChips = v24
	local v25

	if FFlagBuildExperienceChatImageAttachments and state ~= "unmounted" and ref ~= nil and ref.current ~= nil then
		v25 = React.createElement(v7, {
			captureSource = ref.current,
			initialCaptures = captures,
			isOpen = state == "open",
			maxSelections = 2,
			onClose = handleCaptureGalleryClosed,
			onConfirm = confirmCaptureGallery,
			shouldProgressivelyLoad = ref2 ~= nil and ref2.current
		})
	end

	v17.Gallery = v25
	return createElement(view, v16, v17)
end

return ChatActions
