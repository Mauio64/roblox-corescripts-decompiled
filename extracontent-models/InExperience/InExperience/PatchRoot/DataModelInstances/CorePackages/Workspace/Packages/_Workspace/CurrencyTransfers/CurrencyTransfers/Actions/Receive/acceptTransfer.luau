local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local SharedFlags = require(parent.SharedFlags)

require(CurrencyTransfers.Stores.createTransferStore)
local acceptTransferRequest = require(CurrencyTransfers.NetworkRequests.acceptTransferRequest)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Models.AcceptTransferModel)
require(CurrencyTransfers.Models.ErrorTransferModel)
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local handleReceiveSuccess = require(CurrencyTransfers.Actions.Receive.handleReceiveSuccess)
local handleReceiveError = require(CurrencyTransfers.Actions.Receive.handleReceiveError)
local handleReceiveBlock = require(CurrencyTransfers.Actions.Receive.handleReceiveBlock)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function acceptTransfer(data)
	local networkImpl = data.getNetworkImpl()
	local setPromptState = data.setPromptState
	local setRobuxTransfer = data.setRobuxTransfer
	local setIsAlreadyAccepted = data.setIsAlreadyAccepted

	local transferRequestId = data.getTransferRequestId(false)

	if transferRequestId then
		setPromptState(PromptState.ReceiveRequested)

		logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAcceptAttemptedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.accept_attempted)
		end

		return acceptTransferRequest({ transferRequestId = transferRequestId }, nil, networkImpl):andThen(function(p)
			setPromptState(PromptState.ReceiveStarted)

			if p and p.robuxTransfer then
				setRobuxTransfer(p.robuxTransfer)
				setIsAlreadyAccepted(p.isAlreadyAccepted == true)

				logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAcceptSucceededCounter)

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.accept_succeeded)
				end

				if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then
					data.triggerOnPromptDismissCommitted()
				end

				handleReceiveSuccess(data)
			else
				logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAcceptFailedCounter)

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.accept_failed)
				end

				handleReceiveError(data, nil)
			end
		end):catch(function(data2)
			logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAcceptFailedCounter)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.accept_failed)
			end

			if typeof(data2) ~= "table" or not data2.errorMessage then
				handleReceiveError(data, nil)
			elseif
				data2.failureReason == FailureReason.AmpRecourseAvailable
				and data2.ampRecourseActions
				and data2.ampFeatureCheck
			then
				handleReceiveBlock(
					data,
					data2.ampRecourseActions,
					data2.ampFeatureCheck,
					TransferRetryOrigin.AcceptTransfer
				)
			else
				handleReceiveError(data, data2)
			end
		end)
	end

	logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAcceptFailedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.accept_failed)
	end

	handleReceiveError(data, nil)
end

return acceptTransfer
