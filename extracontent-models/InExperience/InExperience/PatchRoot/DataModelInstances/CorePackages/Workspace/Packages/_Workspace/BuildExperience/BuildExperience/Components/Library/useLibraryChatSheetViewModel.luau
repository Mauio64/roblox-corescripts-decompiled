local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useChatPlaytestFooter = require(BuildExperience.Chat.useChatPlaytestFooter)
local useChatSessionCore = require(BuildExperience.Chat.useChatSessionCore)
require(BuildExperience.Components.ChatSheet.ChatSheetView)
require(BuildExperience.Components.ChatSheet.useChatSheetViewModel)
local GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local GetLibraryStore = require(BuildExperience.Stores.GetLibraryStore)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
local useLibraryChatComposer = require(script.Parent.useLibraryChatComposer)
local chatTypes = require(BuildExperience.Chat.chatTypes)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local useGamePermissions = require(BuildExperience.useGamePermissions)

local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local useBuildModelSelection = require(BuildExperience.Chat.useBuildModelSelection)
require(BuildExperience.Components.ModelPicker.ModelPickerTypes)

local useChatSheetFundingRecovery = require(BuildExperience.Components.ChatSheet.useChatSheetFundingRecovery)

local function noop() end

local function useLibraryChatSheetViewModel(data)
	local onClose = data.onClose or noop
	local v = data.isOpen == nil or data.isOpen
	local v2 = SignalsReact.useSignalState(GetAssistantBuildStore().getIsDisabled)
	local creatorAgentResumeStore = GetCreatorAgentResumeStore()
	local currentExperienceProject = getCurrentExperienceProject()
	local universeId = data.universeId or currentExperienceProject.universeId
	local chatPermissions, v3, isChatReadOnly

	if FFlagBuildCheckGamePermissions then
		chatPermissions, v3 = useGamePermissions({ universeId = universeId })

		isChatReadOnly = not chatPermissions.canEditOnBuild
	else
		isChatReadOnly = false
		v3 = false
	end

	local v4 = useChatSessionCore({
		universeId = universeId,
		placeId = data.placeId or currentExperienceProject.placeId,
		sessionId = data.sessionId,
		autoFocusComposer = false,
		hydrateHistoryWhen = v,
		sendMessageWhen = not isChatReadOnly,
		isLibraryChat = true,
		onPromptFailure = GetLibraryStore().reportPromptFailure
	})

	local v5 = useChatPlaytestFooter(v4, "ChatSheetPlaytestCta")
	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = useBuildModelSelection(
			universeId,
			data.modelSelectionDraftId,
			data.modelPicker,
			v4.modelSessionModels,
			v4.hasPreparedModelSession,
			v4.internalTesting
		)
	end

	local isComposerSendBlocked = useLibraryChatComposer(v4, v, isChatReadOnly, modelPicker)

	React.useEffect(function()
		if v and v2 then
			onClose()
		end
	end, { v, v2, onClose })

	React.useEffect(function()
		if v then
			creatorAgentResumeStore.setActiveTarget({
				universeId = universeId,
				sessionId = data.sessionId
			})

			return function()
				creatorAgentResumeStore.setActiveTarget(nil)
			end
		end

		creatorAgentResumeStore.setActiveTarget(nil)
	end, { creatorAgentResumeStore, v, universeId, data.sessionId })

	local composerResourceAttachments = v4.composerResourceAttachments
	local removeComposerResourceAttachmentAtIndex = v4.removeComposerResourceAttachmentAtIndex
	local onRemoveComposerResourceAttachment = React.useCallback(function(p: number)
		local composerResourceAttachment = composerResourceAttachments[p]
		removeComposerResourceAttachmentAtIndex(p)

		if composerResourceAttachment ~= nil then
			GetLibraryStore().reportChipEvent("Removed", {
				chatTypes.getResourceAttachmentUri(composerResourceAttachment)
			})
		end
	end, { composerResourceAttachments, removeComposerResourceAttachmentAtIndex })
	local onActivateComposerResourceAttachment = React.useCallback(function(p: number)
		local composerResourceAttachment = composerResourceAttachments[p]

		if composerResourceAttachment ~= nil then
			GetLibraryStore().reportChipEvent("Activated", {
				chatTypes.getResourceAttachmentUri(composerResourceAttachment)
			})
		end
	end, { composerResourceAttachments })
	local sendMessage = v4.sendMessage
	local onSend = React.useCallback(function(callback)
		local v6 = {}

		for _, composerResourceAttachment in composerResourceAttachments do
			table.insert(v6, chatTypes.getResourceAttachmentUri(composerResourceAttachment))
		end

		local v7 = sendMessage(callback)

		if v7 and #v6 > 0 then
			GetLibraryStore().reportChipEvent("Sent", v6)
		end

		return v7
	end, { composerResourceAttachments, sendMessage })
	local creatorCreditRecovery

	if FFlagBuildExperienceModelPicker then
		creatorCreditRecovery = useChatSheetFundingRecovery(
			v4,
			modelPicker,
			universeId,
			data.placeId or currentExperienceProject.placeId,
			data.sessionId
		)
	end

	local v6 = {}
	v6.isOpen = v
	v6.creatorCreditRecovery = creatorCreditRecovery
	v6.onClose = onClose
	v6.sheetComponent = Foundation.Sheet
	v6.snapPoints = data.snapPoints
	v6.defaultSnapPointIndex = data.defaultSnapPointIndex
	v6.messages = v4.messages
	v6.localToolActions = v4.localToolActions
	local answerForm

	if FFlagBuildExperienceAnswerForm then
		answerForm = v4.answerForm
	end

	v6.answerForm = answerForm
	local onSubmitAnswerText

	if FFlagBuildExperienceAnswerForm then
		onSubmitAnswerText = v4.submitAnswerText
	end

	v6.onSubmitAnswerText = onSubmitAnswerText
	v6.clockBinding = v4.clockBinding
	v6.onPlaytest = v5.onPlaytest
	v6.isPlaytestLoading = v5.isPlaytestLoading
	v6.isHistoryLoading = v4.isHistoryLoading or v3
	v6.scrollingFrameRef = v4.setScrollingFrame
	v6.anchorScrollToInstance = v4.anchorScrollToInstance
	v6.modelPicker = modelPicker
	v6.composerText = v4.composerText
	v6.composerErrorText = v4.composerErrorText
	v6.onComposerChanged = v4.setComposerText
	v6.composerImages = v4.composerImages
	v6.onComposerImagesChanged = v4.setComposerImages
	v6.onRetryComposerImage = v4.retryComposerImage
	v6.composerResourceAttachments = v4.composerResourceAttachments
	v6.onRemoveComposerResourceAttachment = onRemoveComposerResourceAttachment
	v6.onActivateComposerResourceAttachment = onActivateComposerResourceAttachment
	v6.isComposerSendBlocked = isComposerSendBlocked
	v6.tracksExternalComposerText = true
	v6.textBoxRef = v4.textBoxRef
	v6.isAssistantResponding = v4.isAssistantResponding
	v6.canStopAssistantResponse = v4.canStopAssistantResponse
	v6.canSendWhileResponding = v4.canSendWhileResponding
	v6.allowsComposerTypingWhileResponding = true
	v6.isChatReadOnly = isChatReadOnly
	v6.chatPermissions = chatPermissions
	v6.reservesHandleSpace = true
	v6.onSend = onSend
	v6.onStop = v4.stopAssistantResponse
	v6.onOpenChat = noop
	return v6
end

return useLibraryChatSheetViewModel
