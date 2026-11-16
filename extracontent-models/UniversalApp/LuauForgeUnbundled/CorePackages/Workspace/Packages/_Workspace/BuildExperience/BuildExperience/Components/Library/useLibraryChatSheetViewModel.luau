local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local useChatPlaytestFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatPlaytestFooter")
local useChatSessionCore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/ChatSheetView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useChatSheetViewModel")
local GetAssistantBuildStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore")
local GetCreatorAgentResumeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetCreatorAgentResumeStore")
local GetLibraryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetLibraryStore")
local getCurrentExperienceProject = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getCurrentExperienceProject")
local useLibraryChatComposer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/useLibraryChatComposer")
local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")

local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local useBuildModelSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildModelSelection")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")

local useChatSheetFundingRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useChatSheetFundingRecovery")

local function noop() end

local function useLibraryChatSheetViewModel(data)
	local onClose = data.onClose or noop
	local v5 = data.isOpen == nil or data.isOpen
	local v6 = SignalsReact.useSignalState(GetAssistantBuildStore().getIsDisabled)
	local v7 = GetCreatorAgentResumeStore()
	local v8 = getCurrentExperienceProject()
	local universeId = data.universeId or v8.universeId
	local v9, v10, v11

	if FFlagBuildCheckGamePermissions then
		v9, v10 = useGamePermissions({ universeId = universeId })

		v11 = not v9.canEditOnBuild
	else
		v11 = false
		v10 = false
	end

	local v12 = useChatSessionCore({
		universeId = universeId,
		placeId = data.placeId or v8.placeId,
		sessionId = data.sessionId,
		autoFocusComposer = false,
		hydrateHistoryWhen = v5,
		sendMessageWhen = not v11,
		isLibraryChat = true,
		onPromptFailure = GetLibraryStore().reportPromptFailure
	})

	local v13 = useChatPlaytestFooter(v12, "ChatSheetPlaytestCta")
	local v14

	if FFlagBuildExperienceModelPicker then
		v14 = useBuildModelSelection(
			universeId,
			data.modelSelectionDraftId,
			data.modelPicker,
			v12.modelSessionModels,
			v12.hasPreparedModelSession,
			v12.internalTesting
		)
	end

	local v15 = useLibraryChatComposer(v12, v5, v11, v14)

	React.useEffect(function()
		if v5 and v6 then
			onClose()
		end
	end, { v5, v6, onClose })

	React.useEffect(function()
		if v5 then
			v7.setActiveTarget({ universeId = universeId, sessionId = data.sessionId })

			return function()
				v7.setActiveTarget(nil)
			end
		end

		v7.setActiveTarget(nil)
	end, { v7, v5, universeId, data.sessionId })

	local composerResourceAttachments = v12.composerResourceAttachments
	local removeComposerResourceAttachmentAtIndex = v12.removeComposerResourceAttachmentAtIndex
	local v16 = React.useCallback(function(p2)
		local composerResourceAttachment = composerResourceAttachments[p2]
		removeComposerResourceAttachmentAtIndex(p2)

		if composerResourceAttachment ~= nil then
			GetLibraryStore().reportChipEvent("Removed", {
				chatTypes.getResourceAttachmentUri(composerResourceAttachment)
			})
		end
	end, { composerResourceAttachments, removeComposerResourceAttachmentAtIndex })
	local v17 = React.useCallback(function(p2)
		local composerResourceAttachment = composerResourceAttachments[p2]

		if composerResourceAttachment ~= nil then
			GetLibraryStore().reportChipEvent("Activated", {
				chatTypes.getResourceAttachmentUri(composerResourceAttachment)
			})
		end
	end, { composerResourceAttachments })
	local sendMessage = v12.sendMessage
	local v18 = React.useCallback(function(p2)
		local v19 = {}

		for k, composerResourceAttachment in composerResourceAttachments do
			table.insert(v19, chatTypes.getResourceAttachmentUri(composerResourceAttachment))
		end

		local v20 = sendMessage(p2)

		if v20 and #v19 > 0 then
			GetLibraryStore().reportChipEvent("Sent", v19)
		end

		return v20
	end, { composerResourceAttachments, sendMessage })

	local v19 = if FFlagBuildExperienceModelPicker then useChatSheetFundingRecovery(v12, v14, universeId, data.placeId or v8.placeId, data.sessionId) else nil

	local v20 = {}
	v20.isOpen = v5
	v20.creatorCreditRecovery = v19
	v20.onClose = onClose
	v20.sheetComponent = Foundation.Sheet
	v20.snapPoints = data.snapPoints
	v20.defaultSnapPointIndex = data.defaultSnapPointIndex
	v20.messages = v12.messages
	v20.localToolActions = v12.localToolActions
	local v21 = if FFlagBuildExperienceAnswerForm then v12.answerForm else nil
	v20.answerForm = v21
	local v22 = if FFlagBuildExperienceAnswerForm then v12.submitAnswerText else nil
	v20.onSubmitAnswerText = v22
	v20.clockBinding = v12.clockBinding
	v20.onPlaytest = v13.onPlaytest
	v20.isPlaytestLoading = v13.isPlaytestLoading
	v20.isHistoryLoading = v12.isHistoryLoading or v10
	v20.scrollingFrameRef = v12.setScrollingFrame
	v20.anchorScrollToInstance = v12.anchorScrollToInstance
	v20.modelPicker = v14
	v20.composerText = v12.composerText
	v20.composerErrorText = v12.composerErrorText
	v20.onComposerChanged = v12.setComposerText
	v20.composerImages = v12.composerImages
	v20.onComposerImagesChanged = v12.setComposerImages
	v20.onRetryComposerImage = v12.retryComposerImage
	v20.composerResourceAttachments = v12.composerResourceAttachments
	v20.onRemoveComposerResourceAttachment = v16
	v20.onActivateComposerResourceAttachment = v17
	v20.isComposerSendBlocked = v15
	v20.tracksExternalComposerText = true
	v20.textBoxRef = v12.textBoxRef
	v20.isAssistantResponding = v12.isAssistantResponding
	v20.canStopAssistantResponse = v12.canStopAssistantResponse
	v20.canSendWhileResponding = v12.canSendWhileResponding
	v20.allowsComposerTypingWhileResponding = true
	v20.isChatReadOnly = v11
	v20.chatPermissions = v9
	v20.reservesHandleSpace = true
	v20.onSend = v18
	v20.onStop = v12.stopAssistantResponse
	v20.onOpenChat = noop
	return v20
end

return useLibraryChatSheetViewModel
