local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local SharedFlags = require(parent.SharedFlags)

local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)

local FFlagCurrencyTransferNoFreeTransfersRemainingUpsell = require(CurrencyTransfers.Flags.FFlagCurrencyTransferNoFreeTransfersRemainingUpsell)
local FFlagShowRemainingTransfersForNonPlus = require(CurrencyTransfers.Flags.FFlagShowRemainingTransfersForNonPlus)

require(CurrencyTransfers.Stores.createTransferStore)
local initiateTransferRequest = require(CurrencyTransfers.NetworkRequests.initiateTransferRequest)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Models.InitiateTransferModel)
require(CurrencyTransfers.Models.ErrorTransferModel)
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local handleTransferError = require(CurrencyTransfers.Actions.Send.handleTransferError)
local handleTransferBlock = require(CurrencyTransfers.Actions.Send.handleTransferBlock)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function initiateTransfer(data)
	local networkImpl = data.getNetworkImpl()
	local setPromptState = data.setPromptState
	local setTransferRequestId = data.setTransferRequestId
	local setRobuxBalanceAmount = data.setRobuxBalanceAmount
	local setBalanceReceivedFromApi = data.setBalanceReceivedFromApi
	local setUserRelationshipDetail = data.setUserRelationshipDetail
	local setRecipient = data.setRecipient
	local setSender = data.setSender
	local setMinimumTransferAmount = data.setMinimumTransferAmount
	local setMaximumTransferAmount = data.setMaximumTransferAmount
	local setTransferBenefitSource = data.setTransferBenefitSource
	local setNumFreeTransfersRemaining = data.setNumFreeTransfersRemaining
	local recipientUserId = data.getRecipientUserId(false)
	setPromptState(PromptState.TransferRequested)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.initiate_attempted)
	end

	local v = { recipientId = recipientUserId }

	local transferOrigination = data.getTransferOrigination()

	if transferOrigination then
		v.transferOrigination = transferOrigination
	end

	initiateTransferRequest(v, nil, networkImpl):andThen(function(data2)
		setTransferPromptState(data, PromptState.TransferStarted)

		if data2 and data2.transferRequestId and data2.robuxTransfer then
			setTransferRequestId(data2.transferRequestId)
			setRobuxBalanceAmount(data2.senderRobuxBalance)
			setBalanceReceivedFromApi(true)
			setUserRelationshipDetail(data2.userRelationshipDetail)
			setRecipient(data2.robuxTransfer.recipient)
			setSender(data2.robuxTransfer.sender)

			if GetFFlagCurrencyTransferUseBackendTransferLimits() then
				if data2.minimumTransferAmount then
					setMinimumTransferAmount(data2.minimumTransferAmount)
				end

				if data2.maximumTransferAmount then
					setMaximumTransferAmount(data2.maximumTransferAmount)
				end
			end

			if FFlagShowRemainingTransfersForNonPlus then
				setTransferBenefitSource(data2.transferBenefitSource)
				setNumFreeTransfersRemaining(data2.numFreeTransfersRemaining)
			end

			setTransferPromptState(data, PromptState.TransferInput)
			logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferInitiateSucceededCounter)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.initiate_succeeded)
			end
		end
	end):catch(function(data2)
		logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferInitiateFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.initiate_failed)
		end

		if typeof(data2) ~= "table" or not data2.errorMessage then
			handleTransferError(data, nil)

			return
		end

		local v2 = FFlagCurrencyTransferNoFreeTransfersRemainingUpsell
			and data2.failureReason == FailureReason.NoFreeTransfersRemaining

		if
			(data2.failureReason == FailureReason.AmpRecourseAvailable or v2)
			and data2.ampRecourseActions
			and data2.ampFeatureCheck
		then
			handleTransferBlock(
				data,
				data2.ampRecourseActions,
				data2.ampFeatureCheck,
				TransferRetryOrigin.InitiateTransfer,
				v2
			)
		else
			handleTransferError(data, data2)
		end
	end)
end

return initiateTransfer
