require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local useBuildModelSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildModelSelection")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local useChatPlaytestFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatPlaytestFooter")
local useBuildPromptDraft = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildPromptDraft")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")

local FFlagBuildExperienceDeveloperProductContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDeveloperProductContext")
local useChatSessionCore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPortal")
local GetAssistantBuildStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore")
local GetCreatorAgentResumeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetCreatorAgentResumeStore")
local GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore")
local getCurrentExperienceProject = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getCurrentExperienceProject")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/ChatSheetView")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local fFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local fFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceInstanceSelection
	and SharedFlags.FFlagBuildExperienceChatResourceAttachments
local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")
local v5 = SharedFlags.FFlagBuildExperienceInGameCaptureToChat and FFlagBuildExperienceChatImageAttachments

local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")

local useChatSheetFundingRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useChatSheetFundingRecovery")

local function noop() end

local function useChatSheetViewModel(data)
	local onClose = data.onClose or noop
	local v6 = data.isOpen == nil or data.isOpen
	local v7 = GetAssistantBuildStore()
	local v8 = SignalsReact.useSignalState(v7.getIsDisabled)
	local v9 = GetCreatorAgentResumeStore()
	local v10 = getCurrentExperienceProject()
	local universeId = data.universeId or v10.universeId
	local placeId = data.placeId or v10.placeId
	local v11, v12, v13

	if FFlagBuildCheckGamePermissions then
		v11, v12 = useGamePermissions({ universeId = universeId })

		v13 = not v11.canEditOnBuild
	else
		v13 = false
		v12 = false
	end

	local v14 = useChatSessionCore({
		universeId = universeId,
		placeId = placeId,
		sessionId = data.sessionId,
		autoFocusComposer = data.autoFocusComposer == true,
		focusComposerWhen = v6,
		hydrateHistoryWhen = v6,
		sendMessageWhen = not v13
	})
	local v15

	if FFlagBuildExperienceModelPicker then
		v15 = useBuildModelSelection(
			universeId,
			data.modelSelectionDraftId,
			data.modelPicker,
			v14.modelSessionModels,
			v14.hasPreparedModelSession,
			v14.internalTesting
		)
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		useBuildPromptDraft(
			universeId,
			data.sessionId,
			v14.setPrefilledComposerText,
			v14.sendMessage,
			v6 and not v8,
			if FFlagBuildExperienceDeveloperProductContext then v14 else nil
		)
	end

	local v16 = useChatPlaytestFooter(v14, "ChatSheetPlaytestCta")

	if fFlagBuildExperienceChatResourceAttachments then
		local v17 = GetPlayButtonStore()

		local v18 = SignalsReact.useSignalState(v17.getPendingResourceAttachment)

		React.useEffect(function()
			if v18 == nil then
				return
			end

			local resourceAttachmentUri = chatTypes.getResourceAttachmentUri(v18)

			if v14.findComposerResourceAttachmentIndexByUri(resourceAttachmentUri) == nil then
				v14.addComposerResourceAttachment(v18)
			end

			v17.setPendingResourceAttachment(nil)
		end, { v18, v14.addComposerResourceAttachment, v14.findComposerResourceAttachmentIndexByUri })
	end

	if v5 then
		local ref = React.useRef(nil)

		React.useEffect(function()
			if data.captureToAttach == nil or ref.current == data.captureToAttach then
				return
			end

			ref.current = data.captureToAttach
			local clone = table.clone(v14.composerImages)

			if #clone >= 2 then
				table.remove(clone, 1)
			end

			table.insert(clone, { capture = data.captureToAttach })
			v14.setComposerImages(clone)

			if data.onCaptureAttached ~= nil then
				data.onCaptureAttached()
			end
		end, {
			data.captureToAttach,
			data.onCaptureAttached,
			v14.composerImages,
			v14.setComposerImages
		})
	end

	local v17 = noop

	if fFlagBuildExperienceAnalytics then
		local state, setState = React.useState(nil)

		v17 = React.useCallback(function(p2)
			v14.setComposerText(p2)
			setState(p2)
		end, { v14.setComposerText })

		React.useEffect(function()
			if state == nil then
				return
			end

			v14.setComposerText(state)

			if v14.sendMessage() then
				setState(nil)
			end
		end, { state, v14.sendMessage, v14.setComposerText })
	end

	React.useEffect(function()
		if v6 and v8 then
			onClose()
		end
	end, { v6, v8, onClose })

	React.useEffect(function()
		if v6 then
			v9.setActiveTarget({ universeId = universeId, sessionId = data.sessionId })

			return function()
				v9.setActiveTarget(nil)
			end
		end

		v9.setActiveTarget(nil)
	end, { v9, v6, universeId, data.sessionId })

	local v18 = if FFlagBuildExperienceModelPicker then useChatSheetFundingRecovery(v14, v15, universeId, placeId, data.sessionId) else nil

	local v19 = {}
	v19.isOpen = v6
	v19.creatorCreditRecovery = v18
	v19.onClose = onClose
	v19.snapPoints = data.snapPoints
	v19.defaultSnapPointIndex = data.defaultSnapPointIndex
	v19.messages = v14.messages
	v19.localToolActions = v14.localToolActions
	local v20 = if FFlagBuildExperienceAnswerForm then v14.answerForm else nil
	v19.answerForm = v20
	local v21 = if FFlagBuildExperienceAnswerForm then v14.submitAnswerText else nil
	v19.onSubmitAnswerText = v21
	v19.clockBinding = v14.clockBinding
	v19.onPlaytest = v16.onPlaytest
	v19.isPlaytestLoading = v16.isPlaytestLoading
	v19.isHistoryLoading = v14.isHistoryLoading or v12
	v19.scrollingFrameRef = v14.setScrollingFrame
	v19.anchorScrollToInstance = v14.anchorScrollToInstance
	v19.modelPicker = v15
	v19.composerText = v14.composerText
	v19.composerErrorText = v14.composerErrorText
	v19.onComposerChanged = v14.setComposerText
	v19.composerImages = v14.composerImages
	v19.onComposerImagesChanged = v14.setComposerImages
	v19.onRetryComposerImage = v14.retryComposerImage
	v19.composerResourceAttachments = v14.composerResourceAttachments
	v19.onRemoveComposerResourceAttachment = v14.removeComposerResourceAttachmentAtIndex
	v19.isComposerSendBlocked = v14.isComposerSendBlocked
	v19.textBoxRef = v14.textBoxRef
	v19.isAssistantResponding = v14.isAssistantResponding
	v19.canStopAssistantResponse = v14.canStopAssistantResponse
	v19.canSendWhileResponding = v14.canSendWhileResponding
	v19.isChatReadOnly = v13
	v19.chatPermissions = v11
	v19.onSend = v14.sendMessage
	v19.onStop = v14.stopAssistantResponse
	v19.onOpenChat = v17
	v19.topBarPillMenuTarget = data.topBarPillMenuTarget
	return v19
end

return useChatSheetViewModel
