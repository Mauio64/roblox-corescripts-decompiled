local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local HttpService = game:GetService("HttpService")
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local TransferRobuxApp = require(CurrencyTransfers.Components.TransferRobuxApp)
local createTransferStore = require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)
local handleTransferError = require(CurrencyTransfers.Actions.Send.handleTransferError)
local handleTransferBlock = require(CurrencyTransfers.Actions.Send.handleTransferBlock)
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local ErrorTransferModel = require(CurrencyTransfers.Models.ErrorTransferModel)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)
local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function InExperienceTransferFlow(t1: {[any]: any}) -- line: 80
	-- upvalues: createTransferStore (copy), SharedFlags (copy), HttpService (copy), TransferDirection (copy), TransferOrigination (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), GetFFlagCurrencyTransferUseBackendTransferLimits (copy), ErrorTransferModel (copy), FailureReason (copy), AmpWizardTransferConstants (copy), handleTransferBlock (copy), TransferRetryOrigin (copy), handleTransferError (copy), React (copy), TransferRobuxApp (copy), PromptState (copy)
	local initiateResponse = t1.initiateResponse

	assert(type(initiateResponse) == "table", "[InExperienceTransferFlow] initiateResponse must be a table")

	local v25 = createTransferStore()

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		v25.setTransferClientSessionId(HttpService:GenerateGUID(false))
	end

	v25.setDirection(TransferDirection.Send)
	v25.setTransferOrigination(TransferOrigination.InExperience)
	logCurrencyTransferCounter(v25, CurrencyTransferTelemetry.CurrencyTransferFlowOpenedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(v25, RobuxTransferFlowEventName.in_experience_flow_open)
	end

	if t1.onClose then
		v25.setOnClose(t1.onClose)
	end

	if GetFFlagCurrencyTransferUseBackendTransferLimits() then
		if initiateResponse.minimumTransferAmount then
			v25.setMinimumTransferAmount(initiateResponse.minimumTransferAmount)
		end

		if initiateResponse.maximumTransferAmount then
			v25.setMaximumTransferAmount(initiateResponse.maximumTransferAmount)
		end
	end

	if initiateResponse.failureReason ~= nil then
		local v26 = ErrorTransferModel.format(initiateResponse)

		if v26.failureReason == FailureReason.AmpRecourseAvailable and v26.ampRecourseActions and v26.ampFeatureCheck then
			if not table.find(v26.ampRecourseActions, AmpWizardTransferConstants.RECOURSE_PLUS_SUBSCRIPTION) or v26.ampFeatureCheck ~= "CanInitiateRobuxTransfer" then
				handleTransferBlock(v25, v26.ampRecourseActions, v26.ampFeatureCheck, TransferRetryOrigin.ProcessTransfer)
			end
		else
			handleTransferError(v25, v26)
		end

		return React.createElement(TransferRobuxApp, {
			transferStore = v25
		})
	end

	assert(initiateResponse.transferRequestId, "[InExperienceTransferFlow] Missing initiateResponse.transferRequestId")

	local transferAmount = initiateResponse.robuxTransfer.transferAmount

	assert(type(transferAmount) == "number" and transferAmount > 0, "[InExperienceTransferFlow] transferAmount must be a positive number")
	v25.setTransferRequestId(initiateResponse.transferRequestId)
	v25.setRobuxBalanceAmount(initiateResponse.senderRobuxBalance)
	v25.setBalanceReceivedFromApi(true)
	v25.setUserRelationshipDetail(initiateResponse.userRelationshipDetail)
	v25.setRecipient(initiateResponse.robuxTransfer.recipient)
	v25.setSender(initiateResponse.robuxTransfer.sender)
	v25.setSelectedAmount(transferAmount)
	v25.setPromptState(PromptState.TransferConfirm)

	return React.createElement(TransferRobuxApp, {
		transferStore = v25
	})
end

return InExperienceTransferFlow
