require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local FFlagBuildEnableFTUXChips = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEnableFTUXChips")

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipExhaustedTelemetry")
local isImageAttachmentSupported = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/isImageAttachmentSupported")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local createGalleryCaptureSource = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Moments/createGalleryCaptureSource")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local ChatCaptureGalleryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGalleryContainer")
local ChatComposer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatComposer")
local ChatImagePreviewList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatImagePreviewList")
local PromptChipGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/PromptChipGroup")
local ChatResourceAttachmentList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatResourceAttachmentList")

local view = Foundation.View

local function ChatActions(props)
	local images = props.images or {}
	local resourceAttachments = props.resourceAttachments or {}
	local promptChips = props.promptChips or {}
	local v5 = #images > 0
	local v6 = #resourceAttachments > 0
	local v7 = FFlagBuildEnableFTUXChips and (#promptChips > 0 or props.isPromptChipsLoading == true)
	local v8 = v6 and (v5 and 3 or 2) or v5 and 2 or 1
	local state, setState = React.useState("unmounted")
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	local v9 = not (props.allowImageAttachments == false) and isImageAttachmentSupported()

	local function setCapturedImages(items)
		if props.onImagesChanged == nil then
			return
		end

		local v10 = {}

		for k, item in items do
			local v11 = nil

			for k2, image in images do
				if image.capture == item then
					v11 = image
					break
				end
			end

			table.insert(v10, v11 or { capture = item })
		end

		props.onImagesChanged(v10)
	end

	local function openCaptureGallery()
		ref2.current = true
		ref.current = createGalleryCaptureSource(nil, nil, { Enum.CaptureType.Screenshot })
		setState("open")
	end

	local function requestCloseCaptureGallery()
		setState("closing")
	end

	local function confirmCaptureGallery(p2)
		setCapturedImages(p2)
		setState("closing")
	end

	local function handleCaptureGalleryClosed()
		setState("unmounted")
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
	local v11 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-small size-full-0 auto-y"
	}

	local v13 = if v6 then React.createElement(ChatResourceAttachmentList, {
		LayoutOrder = 1,
		attachments = resourceAttachments,
		onRemove = props.onRemoveResourceAttachment,
		onActivateAttachment = props.onActivateResourceAttachment,
		testId = "ChatActions.ResourceAttachments"
	}) else nil

	local v14 = if v5 then React.createElement(ChatImagePreviewList, {
		LayoutOrder = v6 and 2 or 1,
		images = images,
		onRemove = removeImage,
		onRetry = props.onRetryImage,
		testId = "ChatActions.Images"
	}) else nil

	local createElement2 = React.createElement

	local v17 = if FFlagBuildExperienceModelPicker then props.modelPicker else nil
	local v16 = {
		LayoutOrder = v8,
		modelPicker = v17,
		text = props.composerText,
		composerErrorText = props.composerErrorText,
		onChanged = props.onComposerChanged,
		placeholder = props.placeholder,
		textBoxRef = props.textBoxRef,
		isAssistantResponding = props.isAssistantResponding,
		canStopAssistantResponse = props.canStopAssistantResponse,
		canSendWhileResponding = props.canSendWhileResponding,
		allowsTypingWhileResponding = props.allowsTypingWhileResponding,
		images = images,
		isSendBlocked = props.isSendBlocked,
		isReadOnly = props.isReadOnly,
		tracksExternalText = props.tracksExternalText,
		isAttachmentSupported = v9,
		onOpenCaptureGallery = 0,
		onSend = 0,
		onStop = 0,
		maxLines = 0,
		composerDebug = 0
	}

	if not v9 then
		openCaptureGallery = nil
	end

	v16.onOpenCaptureGallery = openCaptureGallery
	v16.onSend = props.onSend
	v16.onStop = props.onStop
	v16.maxLines = props.maxLines
	v16.composerDebug = props.composerDebug
	local v12 = {
		ResourceAttachments = v13,
		Images = v14,
		Composer = createElement2(ChatComposer, v16),
		PromptChips = 0,
		Gallery = 0
	}
	local v18

	if v7 then
		local createElement3 = React.createElement
		local v20 = {
			LayoutOrder = v8 + 1,
			promptChips = promptChips,
			isLoading = props.isPromptChipsLoading,
			onActivated = props.onPromptChipActivated,
			onExhausted = 0
		}

		local v21 = if FFlagBuildExperienceFTUXChipExhaustedTelemetry then props.onPromptChipExhausted else nil
		v20.onExhausted = v21
		v18 = createElement3(PromptChipGroup, v20)
	end

	v12.PromptChips = v18

	local v19 = if state ~= "unmounted" and ref.current ~= nil then React.createElement(ChatCaptureGalleryContainer, {
		captureSource = ref.current,
		initialCaptures = captures,
		isOpen = state == "open",
		maxSelections = 2,
		onClose = handleCaptureGalleryClosed,
		onConfirm = confirmCaptureGallery,
		shouldProgressivelyLoad = ref2.current
	}) else nil
	v12.Gallery = v19
	return createElement(view, v11, v12)
end

return ChatActions
