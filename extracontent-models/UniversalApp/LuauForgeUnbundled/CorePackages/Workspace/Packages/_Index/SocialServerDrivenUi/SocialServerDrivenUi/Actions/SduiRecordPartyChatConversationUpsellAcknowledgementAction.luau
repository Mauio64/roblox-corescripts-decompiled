local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local recordModalSequenceResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/AppChatNetworking").http.RecordModalSequenceResponse
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiSharedUtilities").getSduiApiStore
local recordedModalActions = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Common/recordedModalActions")

local function orNil(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function SduiRecordPartyChatConversationUpsellAcknowledgementAction(p2, p3, data)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	local modalAction = actionParams.modalAction
	local recordedModalAction = recordedModalActions.toRecordedModalAction(modalAction)

	if recordedModalAction == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = `Invalid or missing modalAction: {tostring(modalAction)}`,
				propName = "modalAction"
			},
			data.appPage
		)
		return
	end

	local modalSequence = actionParams.modalSequence

	if typeof(modalSequence) ~= "string" or modalSequence == "" then
		modalSequence = nil
	end

	if modalSequence == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = "Missing actionParam: modalSequence",
				propName = "modalSequence"
			},
			data.appPage
		)
		return
	end

	local modalVariant = actionParams.modalVariant

	if typeof(modalVariant) ~= "string" or modalVariant == "" then
		modalVariant = nil
	end

	local conversationId = actionParams.conversationId

	if typeof(conversationId) ~= "string" or conversationId == "" then
		conversationId = nil
	end

	local friendId = actionParams.friendId

	if typeof(friendId) ~= "string" or friendId == "" then
		friendId = nil
	end

	if conversationId == nil and friendId == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = "Missing actionParam: one of conversationId or friendId is required",
				propName = "conversationId"
			},
			data.appPage
		)
		return
	end

	if conversationId ~= nil then
		friendId = nil
	end

	recordModalSequenceResponse(nil, {
		actionType = recordedModalAction,
		modalSequence = modalSequence,
		modalVariant = modalVariant,
		conversationId = conversationId,
		friendId = friendId
	}):catch(function(p4)
		data.dependencies.logger.reportError(
			sduiErrorType.ActionNetworkRequestFailed,
			{
				name = sduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = `RecordModalSequenceResponse failed: {tostring(p4)}`
			},
			data.appPage
		)
	end)

	local clearConfigEntries = modalAction == recordedModalActions.ModalAction.Close
		and data.configKey ~= nil
		and getSduiApiStore().clearConfigEntries

	if clearConfigEntries then
		clearConfigEntries(data.configKey)
	end
end

return SduiRecordPartyChatConversationUpsellAcknowledgementAction
