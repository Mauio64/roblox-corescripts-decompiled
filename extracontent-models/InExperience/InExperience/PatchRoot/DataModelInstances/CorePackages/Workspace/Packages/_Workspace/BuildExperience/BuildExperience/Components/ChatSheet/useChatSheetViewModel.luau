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

local FFlagBuildExperienceChatSheetDesktopAutoFocus = require(BuildExperience.Flags.FFlagBuildExperienceChatSheetDesktopAutoFocus)
local Responsive = require(parent.Responsive)
require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)
local GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
require(script.Parent.ChatSheetView)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local FFlagBuildExperienceInstanceSelection = SharedFlags.FFlagBuildExperienceInstanceSelection

local FFlagBuildExperienceInGameCaptureToChat = SharedFlags.FFlagBuildExperienceInGameCaptureToChat
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local useGamePermissions = require(BuildExperience.useGamePermissions)

local useChatSheetFundingRecovery = require(BuildExperience.Components.ChatSheet.useChatSheetFundingRecovery)

local function noop() end

local function useChatSheetViewModel(data)
	local onClose = data.onClose or noop
	local v = data.isOpen == nil or data.isOpen
	local assistantBuildStore = GetAssistantBuildStore()
	local v2 = SignalsReact.useSignalState(assistantBuildStore.getIsDisabled)
	local creatorAgentResumeStore = GetCreatorAgentResumeStore()
	local currentExperienceProject = getCurrentExperienceProject()
	local universeId = data.universeId or currentExperienceProject.universeId
	local placeId = data.placeId or currentExperienceProject.placeId
	local chatPermissions, v3, isChatReadOnly

	if FFlagBuildCheckGamePermissions then
		chatPermissions, v3 = useGamePermissions({ universeId = universeId })

		isChatReadOnly = not chatPermissions.canEditOnBuild
	else
		isChatReadOnly = false
		v3 = false
	end

	local autoFocusComposer = data.autoFocusComposer == true

	if FFlagBuildExperienceChatSheetDesktopAutoFocus then
		local v4 = Responsive.usePreferredInput() == Responsive.Input.Pointer
		autoFocusComposer = autoFocusComposer or v4
	end

	local v4 = useChatSessionCore({
		universeId = universeId,
		placeId = placeId,
		sessionId = data.sessionId,
		autoFocusComposer = autoFocusComposer,
		focusComposerWhen = v,
		hydrateHistoryWhen = v,
		sendMessageWhen = not isChatReadOnly
	})
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

	if FFlagBuildExperienceMonetizationNativeUI then
		local sessionId = data.sessionId
		local setPrefilledComposerText = v4.setPrefilledComposerText
		local sendMessage = v4.sendMessage
		local v5

		if FFlagBuildExperienceDeveloperProductContext then
			v5 = v4
		end

		useBuildPromptDraft(universeId, sessionId, setPrefilledComposerText, sendMessage, v and not v2, v5)
	end

	local v5 = useChatPlaytestFooter(v4, "ChatSheetPlaytestCta")

	if FFlagBuildExperienceInstanceSelection then
		local playButtonStore = GetPlayButtonStore()

		local v6 = SignalsReact.useSignalState(playButtonStore.getPendingResourceAttachment)

		React.useEffect(function()
			if v6 == nil then
				return
			end

			local resourceAttachmentUri = chatTypes.getResourceAttachmentUri(v6)

			if v4.findComposerResourceAttachmentIndexByUri(resourceAttachmentUri) == nil then
				v4.addComposerResourceAttachment(v6)
			end

			playButtonStore.setPendingResourceAttachment(nil)
		end, { v6, v4.addComposerResourceAttachment, v4.findComposerResourceAttachmentIndexByUri })
	end

	if FFlagBuildExperienceInGameCaptureToChat then
		local ref = React.useRef(nil)

		React.useEffect(function()
			if data.captureToAttach == nil or ref.current == data.captureToAttach then
				return
			end

			ref.current = data.captureToAttach
			local clone = table.clone(v4.composerImages)

			if #clone >= 2 then
				table.remove(clone, 1)
			end

			table.insert(clone, { capture = data.captureToAttach })
			v4.setComposerImages(clone)

			if data.onCaptureAttached ~= nil then
				data.onCaptureAttached()
			end
		end, {
			data.captureToAttach,
			data.onCaptureAttached,
			v4.composerImages,
			v4.setComposerImages
		})
	end

	local onOpenChat = noop

	if FFlagBuildExperienceAnalytics then
		local state, setState = React.useState(nil)

		onOpenChat = React.useCallback(function(p: string)
			v4.setComposerText(p)
			setState(p)
		end, { v4.setComposerText })

		React.useEffect(function()
			if state == nil then
				return
			end

			v4.setComposerText(state)

			if v4.sendMessage() then
				setState(nil)
			end
		end, { state, v4.sendMessage, v4.setComposerText })
	end

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
	local creatorCreditRecovery

	if FFlagBuildExperienceModelPicker then
		creatorCreditRecovery = useChatSheetFundingRecovery(v4, modelPicker, universeId, placeId, data.sessionId)
	end

	local v6 = {}
	v6.isOpen = v
	v6.creatorCreditRecovery = creatorCreditRecovery
	v6.onClose = onClose
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
	v6.onRemoveComposerResourceAttachment = v4.removeComposerResourceAttachmentAtIndex
	v6.isComposerSendBlocked = v4.isComposerSendBlocked
	v6.textBoxRef = v4.textBoxRef
	v6.isAssistantResponding = v4.isAssistantResponding
	v6.canStopAssistantResponse = v4.canStopAssistantResponse
	v6.canSendWhileResponding = v4.canSendWhileResponding
	v6.isChatReadOnly = isChatReadOnly
	v6.chatPermissions = chatPermissions
	v6.onSend = v4.sendMessage
	v6.onStop = v4.stopAssistantResponse
	v6.onOpenChat = onOpenChat
	v6.topBarPillMenuTarget = data.topBarPillMenuTarget
	return v6
end

return useChatSheetViewModel
