local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

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

local function InExperienceTransferFlow(p)
	local initiateResponse = p.initiateResponse
	assert(type(initiateResponse) == "table", "[InExperienceTransferFlow] initiateResponse must be a table")

	local transferStore = createTransferStore()

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		transferStore.setTransferClientSessionId(HttpService:GenerateGUID(false))
	end

	transferStore.setDirection(TransferDirection.Send)
	transferStore.setTransferOrigination(TransferOrigination.InExperience)

	logCurrencyTransferCounter(transferStore, CurrencyTransferTelemetry.CurrencyTransferFlowOpenedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(transferStore, RobuxTransferFlowEventName.in_experience_flow_open)
	end

	if p.onClose then
		transferStore.setOnClose(p.onClose)
	end

	if GetFFlagCurrencyTransferUseBackendTransferLimits() then
		if initiateResponse.minimumTransferAmount then
			transferStore.setMinimumTransferAmount(initiateResponse.minimumTransferAmount)
		end

		if initiateResponse.maximumTransferAmount then
			transferStore.setMaximumTransferAmount(initiateResponse.maximumTransferAmount)
		end
	end

	if initiateResponse.failureReason == nil then
		assert(
			initiateResponse.transferRequestId,
			"[InExperienceTransferFlow] Missing initiateResponse.transferRequestId"
		)
		local transferAmount = initiateResponse.robuxTransfer.transferAmount

		local v = type(transferAmount) == "number" and transferAmount > 0
		assert(v, "[InExperienceTransferFlow] transferAmount must be a positive number")

		transferStore.setTransferRequestId(initiateResponse.transferRequestId)
		transferStore.setRobuxBalanceAmount(initiateResponse.senderRobuxBalance)
		transferStore.setBalanceReceivedFromApi(true)
		transferStore.setUserRelationshipDetail(initiateResponse.userRelationshipDetail)
		transferStore.setRecipient(initiateResponse.robuxTransfer.recipient)
		transferStore.setSender(initiateResponse.robuxTransfer.sender)
		transferStore.setSelectedAmount(transferAmount)

		transferStore.setPromptState(PromptState.TransferConfirm)

		return React.createElement(TransferRobuxApp, { transferStore = transferStore })
	else
		local formatted = ErrorTransferModel.format(initiateResponse)

		if
			formatted.failureReason == FailureReason.AmpRecourseAvailable
			and formatted.ampRecourseActions
			and formatted.ampFeatureCheck
		then
			if
				not table.find(formatted.ampRecourseActions, AmpWizardTransferConstants.RECOURSE_PLUS_SUBSCRIPTION)
				or formatted.ampFeatureCheck ~= "CanInitiateRobuxTransfer"
			then
				handleTransferBlock(
					transferStore,
					formatted.ampRecourseActions,
					formatted.ampFeatureCheck,
					TransferRetryOrigin.ProcessTransfer
				)
			end
		else
			handleTransferError(transferStore, formatted)
		end

		return React.createElement(TransferRobuxApp, { transferStore = transferStore })
	end
end

return InExperienceTransferFlow
