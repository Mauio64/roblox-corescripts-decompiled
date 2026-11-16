local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local useBuildModelSelection = require(BuildExperience.Chat.useBuildModelSelection)

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local chatTypes = require(BuildExperience.Chat.chatTypes)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local useChatPlaytestFooter = require(BuildExperience.Chat.useChatPlaytestFooter)
local useBuildPromptDraft = require(BuildExperience.Chat.useBuildPromptDraft)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)

local FFlagBuildExperienceDeveloperProductContext = require(BuildExperience.Flags.FFlagBuildExperienceDeveloperProductContext)
local useChatSessionCore = require(BuildExperience.Chat.useChatSessionCore)
require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)
local GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
require(script.Parent.ChatSheetView)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local fFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceInstanceSelection
	and SharedFlags.FFlagBuildExperienceChatResourceAttachments
local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)
local v = SharedFlags.FFlagBuildExperienceInGameCaptureToChat and FFlagBuildExperienceChatImageAttachments

local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local useGamePermissions = require(BuildExperience.useGamePermissions)

local useChatSheetFundingRecovery = require(BuildExperience.Components.ChatSheet.useChatSheetFundingRecovery)

local function noop() end

local function useChatSheetViewModel(data)
	local onClose = data.onClose or noop
	local v2 = data.isOpen == nil or data.isOpen
	local assistantBuildStore = GetAssistantBuildStore()
	local v3 = SignalsReact.useSignalState(assistantBuildStore.getIsDisabled)
	local creatorAgentResumeStore = GetCreatorAgentResumeStore()
	local currentExperienceProject = getCurrentExperienceProject()
	local universeId = data.universeId or currentExperienceProject.universeId
	local placeId = data.placeId or currentExperienceProject.placeId
	local chatPermissions, v4, isChatReadOnly

	if FFlagBuildCheckGamePermissions then
		chatPermissions, v4 = useGamePermissions({ universeId = universeId })

		isChatReadOnly = not chatPermissions.canEditOnBuild
	else
		isChatReadOnly = false
		v4 = false
	end

	local v5 = useChatSessionCore({
		universeId = universeId,
		placeId = placeId,
		sessionId = data.sessionId,
		autoFocusComposer = data.autoFocusComposer == true,
		focusComposerWhen = v2,
		hydrateHistoryWhen = v2,
		sendMessageWhen = not isChatReadOnly
	})
	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = useBuildModelSelection(
			universeId,
			data.modelSelectionDraftId,
			data.modelPicker,
			v5.modelSessionModels,
			v5.hasPreparedModelSession,
			v5.internalTesting
		)
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		local sessionId = data.sessionId
		local setPrefilledComposerText = v5.setPrefilledComposerText
		local sendMessage = v5.sendMessage
		local v6

		if FFlagBuildExperienceDeveloperProductContext then
			v6 = v5
		end

		useBuildPromptDraft(universeId, sessionId, setPrefilledComposerText, sendMessage, v2 and not v3, v6)
	end

	local v6 = useChatPlaytestFooter(v5, "ChatSheetPlaytestCta")

	if fFlagBuildExperienceChatResourceAttachments then
		local playButtonStore = GetPlayButtonStore()

		local v7 = SignalsReact.useSignalState(playButtonStore.getPendingResourceAttachment)

		React.useEffect(function()
			if v7 == nil then
				return
			end

			local resourceAttachmentUri = chatTypes.getResourceAttachmentUri(v7)

			if v5.findComposerResourceAttachmentIndexByUri(resourceAttachmentUri) == nil then
				v5.addComposerResourceAttachment(v7)
			end

			playButtonStore.setPendingResourceAttachment(nil)
		end, { v7, v5.addComposerResourceAttachment, v5.findComposerResourceAttachmentIndexByUri })
	end

	if v then
		local ref = React.useRef(nil)

		React.useEffect(function()
			if data.captureToAttach == nil or ref.current == data.captureToAttach then
				return
			end

			ref.current = data.captureToAttach
			local clone = table.clone(v5.composerImages)

			if #clone >= 2 then
				table.remove(clone, 1)
			end

			table.insert(clone, { capture = data.captureToAttach })
			v5.setComposerImages(clone)

			if data.onCaptureAttached ~= nil then
				data.onCaptureAttached()
			end
		end, {
			data.captureToAttach,
			data.onCaptureAttached,
			v5.composerImages,
			v5.setComposerImages
		})
	end

	local onOpenChat = noop

	if FFlagBuildExperienceAnalytics then
		local state, setState = React.useState(nil)

		onOpenChat = React.useCallback(function(p: string)
			v5.setComposerText(p)
			setState(p)
		end, { v5.setComposerText })

		React.useEffect(function()
			if state == nil then
				return
			end

			v5.setComposerText(state)

			if v5.sendMessage() then
				setState(nil)
			end
		end, { state, v5.sendMessage, v5.setComposerText })
	end

	React.useEffect(function()
		if v2 and v3 then
			onClose()
		end
	end, { v2, v3, onClose })

	React.useEffect(function()
		if v2 then
			creatorAgentResumeStore.setActiveTarget({
				universeId = universeId,
				sessionId = data.sessionId
			})

			return function()
				creatorAgentResumeStore.setActiveTarget(nil)
			end
		end

		creatorAgentResumeStore.setActiveTarget(nil)
	end, { creatorAgentResumeStore, v2, universeId, data.sessionId })
	local creatorCreditRecovery

	if FFlagBuildExperienceModelPicker then
		creatorCreditRecovery = useChatSheetFundingRecovery(v5, modelPicker, universeId, placeId, data.sessionId)
	end

	local v7 = {}
	v7.isOpen = v2
	v7.creatorCreditRecovery = creatorCreditRecovery
	v7.onClose = onClose
	v7.snapPoints = data.snapPoints
	v7.defaultSnapPointIndex = data.defaultSnapPointIndex
	v7.messages = v5.messages
	v7.localToolActions = v5.localToolActions
	local answerForm

	if FFlagBuildExperienceAnswerForm then
		answerForm = v5.answerForm
	end

	v7.answerForm = answerForm
	local onSubmitAnswerText

	if FFlagBuildExperienceAnswerForm then
		onSubmitAnswerText = v5.submitAnswerText
	end

	v7.onSubmitAnswerText = onSubmitAnswerText
	v7.clockBinding = v5.clockBinding
	v7.onPlaytest = v6.onPlaytest
	v7.isPlaytestLoading = v6.isPlaytestLoading
	v7.isHistoryLoading = v5.isHistoryLoading or v4
	v7.scrollingFrameRef = v5.setScrollingFrame
	v7.anchorScrollToInstance = v5.anchorScrollToInstance
	v7.modelPicker = modelPicker
	v7.composerText = v5.composerText
	v7.composerErrorText = v5.composerErrorText
	v7.onComposerChanged = v5.setComposerText
	v7.composerImages = v5.composerImages
	v7.onComposerImagesChanged = v5.setComposerImages
	v7.onRetryComposerImage = v5.retryComposerImage
	v7.composerResourceAttachments = v5.composerResourceAttachments
	v7.onRemoveComposerResourceAttachment = v5.removeComposerResourceAttachmentAtIndex
	v7.isComposerSendBlocked = v5.isComposerSendBlocked
	v7.textBoxRef = v5.textBoxRef
	v7.isAssistantResponding = v5.isAssistantResponding
	v7.canStopAssistantResponse = v5.canStopAssistantResponse
	v7.canSendWhileResponding = v5.canSendWhileResponding
	v7.isChatReadOnly = isChatReadOnly
	v7.chatPermissions = chatPermissions
	v7.onSend = v5.sendMessage
	v7.onStop = v5.stopAssistantResponse
	v7.onOpenChat = onOpenChat
	v7.topBarPillMenuTarget = data.topBarPillMenuTarget
	return v7
end

return useChatSheetViewModel
