local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
local GetLibraryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetLibraryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetLibraryStore/createLibraryStore")
local LibraryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")

local function useLibraryChatComposer(current, p2, p3, p4)
	local v5 = GetLibraryStore()
	local v6 = SignalsReact.useSignalState(v5.getChatResourceRequest)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(current)
	ref3.current = current
	local v7 = React.useCallback(function(p5): boolean
		local current2 = ref3.current
		local resourceAttachment = LibraryTypes.toResourceAttachment(p5)

		if current2.findComposerResourceAttachmentIndexByUri(resourceAttachment.uri) ~= nil then
			return false
		end

		current2.addComposerResourceAttachment(resourceAttachment)
		return true
	end, {})
	local v8 = React.useCallback(function(p5): boolean
		local current2 = ref3.current
		local composerResourceAttachmentIndexByUri = current2.findComposerResourceAttachmentIndexByUri(LibraryTypes.toResourceUri(p5))

		if composerResourceAttachmentIndexByUri == nil then
			return false
		end

		current2.removeComposerResourceAttachmentAtIndex(composerResourceAttachmentIndexByUri)
		return true
	end, {})
	local isComposerSendBlocked = current.isComposerSendBlocked
		or current.isAssistantResponding and #current.composerResourceAttachments > 0
	local answerForm = if FFlagBuildExperienceAnswerForm then current.answerForm else nil
	local localToolActions = if FFlagBuildExperienceAnswerForm then current.localToolActions else nil
	local submitAnswerText = if FFlagBuildExperienceAnswerForm then current.submitAnswerText else nil
	React.useEffect(function()
		if v6 == nil or v6.token <= ref.current then
			return
		end

		ref.current = v6.token
		local resources = v6.resources

		if v6.action == "Remove" then
			for k, resource in resources do
				v8(resource.path)
			end
		else
			local pathSet = {}

			for k, resource in resources do
				pathSet[resource.path] = true
			end

			for k, replacePath in v6.replacePaths do
				if not pathSet[replacePath] then
					v8(replacePath)
				end
			end

			for k, resource in resources do
				v7(resource)
			end
		end

		v5.consumeChatResourceRequest(v6.token)

		if
			p2
			and answerForm == nil
			and v6.action == "Add"
			and v6.focusComposer ~= false
			and current.textBoxRef.current ~= nil
		then
			current.textBoxRef.current.focus()
		end
	end, { v5, v6, p2, answerForm, v7, v8, current.textBoxRef })

	React.useLayoutEffect(function()
		local v9 = {
			modelPicker = p4,
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
			onAddResource = v7,
			onRemoveResourceAttachment = current.removeComposerResourceAttachmentAtIndex,
			onRemoveResourceByPath = v8,
			isSendBlocked = isComposerSendBlocked,
			isReadOnly = p3,
			tracksExternalText = true,
			textBoxRef = current.textBoxRef,
			isAssistantResponding = current.isAssistantResponding,
			canStopAssistantResponse = current.canStopAssistantResponse,
			canSendWhileResponding = current.canSendWhileResponding,
			onSend = current.sendMessage,
			onStop = current.stopAssistantResponse
		}

		ref2.current = v9
		v5.setChatComposerState(v9)
	end, {
		v5,
		p4,
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
		v7,
		current.removeComposerResourceAttachmentAtIndex,
		v8,
		isComposerSendBlocked,
		p3,
		current.textBoxRef,
		current.isAssistantResponding,
		current.canStopAssistantResponse,
		current.canSendWhileResponding,
		current.sendMessage,
		current.stopAssistantResponse
	})

	React.useEffect(function()
		return function()
			if v5.getChatComposerState(false) == ref2.current then
				v5.setChatComposerState(nil)
			end
		end
	end, { v5 })
	return isComposerSendBlocked
end

return useLibraryChatComposer
