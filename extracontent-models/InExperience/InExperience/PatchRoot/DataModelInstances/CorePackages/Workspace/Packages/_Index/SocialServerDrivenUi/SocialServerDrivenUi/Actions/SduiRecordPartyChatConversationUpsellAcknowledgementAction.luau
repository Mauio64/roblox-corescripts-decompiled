local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local AppChatNetworking = require(parent.AppChatNetworking)
local recordModalSequenceResponse = AppChatNetworking.http.RecordModalSequenceResponse
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local recordedModalActions = require(SocialServerDrivenUi.Common.recordedModalActions)

local function orNil(value) -- 4 equivalent calls inferred from this helper
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function SduiRecordPartyChatConversationUpsellAcknowledgementAction(p, _, data)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
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
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = `Invalid or missing modalAction: {tostring(modalAction)}`,
				propName = "modalAction"
			},
			data.appPage
		)
		return
	end

	local modalSequence = orNil(actionParams.modalSequence) -- inferred equivalent call

	if modalSequence == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = "Missing actionParam: modalSequence",
				propName = "modalSequence"
			},
			data.appPage
		)
		return
	end

	local modalVariant = orNil(actionParams.modalVariant) -- inferred equivalent call
	local conversationId = orNil(actionParams.conversationId) -- inferred equivalent call
	local friendId = orNil(actionParams.friendId) -- inferred equivalent call

	if conversationId == nil and friendId == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
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
	}):catch(function(p2)
		data.dependencies.logger.reportError(
			SduiErrorType.ActionNetworkRequestFailed,
			{
				name = SduiActionType.RecordPartyChatConversationUpsellAcknowledgement,
				message = `RecordModalSequenceResponse failed: {tostring(p2)}`
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
