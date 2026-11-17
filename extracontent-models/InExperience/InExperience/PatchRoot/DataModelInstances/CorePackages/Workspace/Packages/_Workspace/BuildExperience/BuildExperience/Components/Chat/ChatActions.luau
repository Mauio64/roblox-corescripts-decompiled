local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local FFlagBuildEnableFTUXChips = require(BuildExperience.Flags.FFlagBuildEnableFTUXChips)

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceFTUXChipExhaustedTelemetry)
local isImageAttachmentSupported = require(BuildExperience.utils.isImageAttachmentSupported)

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local createGalleryCaptureSource = require(parent.Moments.createGalleryCaptureSource)

require(BuildExperience.Chat.chatTypes)
local ChatCaptureGalleryContainer = require(script.Parent.ChatCaptureGallery.ChatCaptureGalleryContainer)
local ChatComposer = require(script.Parent.ChatComposer)
local ChatImagePreviewList = require(script.Parent.ChatImagePreviewList)
local PromptChipGroup = require(script.Parent.PromptChipGroup)
local ChatResourceAttachmentList = require(script.Parent.ChatResourceAttachmentList)

local View = Foundation.View

local function ChatActions(props)
	local images = props.images or {}
	local resourceAttachments = props.resourceAttachments or {}
	local promptChips = props.promptChips or {}
	local v = #images > 0
	local v2 = #resourceAttachments > 0
	local v3 = FFlagBuildEnableFTUXChips and (#promptChips > 0 or props.isPromptChipsLoading == true)
	local layoutOrder = v2 and (v and 3 or 2) or v and 2 or 1
	local state, setState = React.useState("unmounted")
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)
	local isAttachmentSupported

	if props.allowImageAttachments == false then
		isAttachmentSupported = false
	else
		isAttachmentSupported = isImageAttachmentSupported()
	end

	local function setCapturedImages(items)
		if props.onImagesChanged == nil then
			return
		end

		local v4 = {}

		for _, item in items do
			local v5 = nil

			for _, image in images do
				if image.capture == item then
					v5 = image
					break
				end
			end

			table.insert(v4, v5 or { capture = item })
		end

		props.onImagesChanged(v4)
	end

	local function openCaptureGallery()
		ref2.current = true
		ref.current = createGalleryCaptureSource(nil, nil, { Enum.CaptureType.Screenshot })
		setState("open")
	end

	local function requestCloseCaptureGallery() -- 1 equivalent call inferred from this helper
		setState("closing")
	end

	local function confirmCaptureGallery(p)
		setCapturedImages(p)
		requestCloseCaptureGallery() -- inferred equivalent call
	end

	local function handleCaptureGalleryClosed()
		setState("unmounted")
	end

	local function removeImage(p: number)
		if props.onImagesChanged == nil then
			return
		end

		local clone = table.clone(images)
		table.remove(clone, p)
		props.onImagesChanged(clone)
	end

	local captures = {}

	for _, image in images do
		if image.capture ~= nil then
			table.insert(captures, image.capture)
		end
	end

	local createElement = React.createElement
	local v4 = { LayoutOrder = props.LayoutOrder, tag = "col gap-small size-full-0 auto-y" }
	local resourceAttachments2

	if v2 then
		resourceAttachments2 = React.createElement(ChatResourceAttachmentList, {
			LayoutOrder = 1,
			attachments = resourceAttachments,
			onRemove = props.onRemoveResourceAttachment,
			onActivateAttachment = props.onActivateResourceAttachment,
			testId = "ChatActions.ResourceAttachments"
		})
	end

	local images2

	if v then
		images2 = React.createElement(ChatImagePreviewList, {
			LayoutOrder = v2 and 2 or 1,
			images = images,
			onRemove = removeImage,
			onRetry = props.onRetryImage,
			testId = "ChatActions.Images"
		})
	end

	local createElement2 = React.createElement
	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = props.modelPicker
	end

	local v5 = {
		LayoutOrder = layoutOrder,
		modelPicker = modelPicker,
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
		isAttachmentSupported = isAttachmentSupported,
		onOpenCaptureGallery = 0,
		onSend = 0,
		onStop = 0,
		maxLines = 0,
		composerDebug = 0
	}

	if not isAttachmentSupported then
		openCaptureGallery = nil
	end

	v5.onOpenCaptureGallery = openCaptureGallery
	v5.onSend = props.onSend
	v5.onStop = props.onStop
	v5.maxLines = props.maxLines
	v5.composerDebug = props.composerDebug
	local v6 = {
		ResourceAttachments = resourceAttachments2,
		Images = images2,
		Composer = createElement2(ChatComposer, v5),
		PromptChips = 0,
		Gallery = 0
	}
	local promptChips2

	if v3 then
		local createElement3 = React.createElement
		local v7 = {
			LayoutOrder = layoutOrder + 1,
			promptChips = promptChips,
			isLoading = props.isPromptChipsLoading,
			onActivated = props.onPromptChipActivated,
			onExhausted = 0
		}
		local onExhausted

		if FFlagBuildExperienceFTUXChipExhaustedTelemetry then
			onExhausted = props.onPromptChipExhausted
		end

		v7.onExhausted = onExhausted
		promptChips2 = createElement3(PromptChipGroup, v7)
	end

	v6.PromptChips = promptChips2
	local gallery

	if not (state == "unmounted" or ref.current == nil) then
		gallery = React.createElement(ChatCaptureGalleryContainer, {
			captureSource = ref.current,
			initialCaptures = captures,
			isOpen = state == "open",
			maxSelections = 2,
			onClose = handleCaptureGalleryClosed,
			onConfirm = confirmCaptureGallery,
			shouldProgressivelyLoad = ref2.current
		})
	end

	v6.Gallery = gallery
	return createElement(View, v4, v6)
end

return ChatActions
