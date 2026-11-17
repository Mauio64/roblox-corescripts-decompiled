local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(BuildExperience.Chat.useChatSessionCore)
local GetLibraryStore = require(BuildExperience.Stores.GetLibraryStore)
require(BuildExperience.Stores.GetLibraryStore.createLibraryStore)
local LibraryTypes = require(script.Parent.LibraryTypes)
require(BuildExperience.Chat.chatTypes)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)

local function useLibraryChatComposer(current, flag: boolean, isReadOnly: boolean?, modelPicker)
	local libraryStore = GetLibraryStore()
	local v = SignalsReact.useSignalState(libraryStore.getChatResourceRequest)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(current)
	ref3.current = current
	local onAddResource = React.useCallback(function(p): boolean
		local current2 = ref3.current
		local resourceAttachment = LibraryTypes.toResourceAttachment(p)

		if current2.findComposerResourceAttachmentIndexByUri(resourceAttachment.uri) ~= nil then
			return false
		end

		current2.addComposerResourceAttachment(resourceAttachment)
		return true
	end, {})
	local onRemoveResourceByPath = React.useCallback(function(p: string): boolean
		local current2 = ref3.current
		local composerResourceAttachmentIndexByUri = current2.findComposerResourceAttachmentIndexByUri(LibraryTypes.toResourceUri(p))

		if composerResourceAttachmentIndexByUri == nil then
			return false
		end

		current2.removeComposerResourceAttachmentAtIndex(composerResourceAttachmentIndexByUri)
		return true
	end, {})
	local isComposerSendBlocked = current.isComposerSendBlocked
		or current.isAssistantResponding and #current.composerResourceAttachments > 0
	local answerForm

	if FFlagBuildExperienceAnswerForm then
		answerForm = current.answerForm
	else
		answerForm = nil
	end

	local localToolActions

	if FFlagBuildExperienceAnswerForm then
		localToolActions = current.localToolActions
	else
		localToolActions = nil
	end

	local submitAnswerText

	if FFlagBuildExperienceAnswerForm then
		submitAnswerText = current.submitAnswerText
	else
		submitAnswerText = nil
	end

	React.useEffect(function()
		if v == nil or v.token <= ref.current then
			return
		end

		ref.current = v.token
		local resources = v.resources

		if v.action == "Remove" then
			for _, resource in resources do
				onRemoveResourceByPath(resource.path)
			end
		else
			local pathSet = {}

			for _, resource in resources do
				pathSet[resource.path] = true
			end

			for _, replacePath in v.replacePaths do
				if not pathSet[replacePath] then
					onRemoveResourceByPath(replacePath)
				end
			end

			for _, resource in resources do
				onAddResource(resource)
			end
		end

		libraryStore.consumeChatResourceRequest(v.token)

		if
			flag
			and answerForm == nil
			and v.action == "Add"
			and v.focusComposer ~= false
			and current.textBoxRef.current ~= nil
		then
			current.textBoxRef.current.focus()
		end
	end, {
		libraryStore,
		v,
		flag,
		answerForm,
		onAddResource,
		onRemoveResourceByPath,
		current.textBoxRef
	})

	React.useLayoutEffect(function()
		local current2 = {
			modelPicker = modelPicker,
			answerForm = answerForm,
			localToolActions = localToolActions,
			onSubmitAnswerText = submitAnswerText,
			composerText = current.composerText,
			composerErrorText = current.composerErrorText,
			onComposerChanged = current.setComposerText,
			images = current.composerImages,
			onImagesChanged = current.setComposerImages,
			onRetryImage = current.retryComposerImage,
			resourceAttachments = current.composerResourceAttachments,
			onAddResource = onAddResource,
			onRemoveResourceAttachment = current.removeComposerResourceAttachmentAtIndex,
			onRemoveResourceByPath = onRemoveResourceByPath,
			isSendBlocked = isComposerSendBlocked,
			isReadOnly = isReadOnly,
			tracksExternalText = true,
			textBoxRef = current.textBoxRef,
			isAssistantResponding = current.isAssistantResponding,
			canStopAssistantResponse = current.canStopAssistantResponse,
			canSendWhileResponding = current.canSendWhileResponding,
			onSend = current.sendMessage,
			onStop = current.stopAssistantResponse
		}

		ref2.current = current2
		libraryStore.setChatComposerState(current2)
	end, {
		libraryStore,
		modelPicker,
		current.composerText,
		answerForm,
		localToolActions,
		submitAnswerText,
		current.composerErrorText,
		current.setComposerText,
		current.composerImages,
		current.setComposerImages,
		current.retryComposerImage,
		current.composerResourceAttachments,
		onAddResource,
		current.removeComposerResourceAttachmentAtIndex,
		onRemoveResourceByPath,
		isComposerSendBlocked,
		isReadOnly,
		current.textBoxRef,
		current.isAssistantResponding,
		current.canStopAssistantResponse,
		current.canSendWhileResponding,
		current.sendMessage,
		current.stopAssistantResponse
	})

	React.useEffect(function()
		return function()
			if libraryStore.getChatComposerState(false) == ref2.current then
				libraryStore.setChatComposerState(nil)
			end
		end
	end, { libraryStore })
	return isComposerSendBlocked
end

return useLibraryChatComposer
