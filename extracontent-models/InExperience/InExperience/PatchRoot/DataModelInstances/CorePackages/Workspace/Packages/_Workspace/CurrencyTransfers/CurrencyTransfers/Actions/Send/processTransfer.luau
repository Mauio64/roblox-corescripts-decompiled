local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local SharedFlags = require(parent.SharedFlags)

require(CurrencyTransfers.Stores.createTransferStore)
local processTransferRequest = require(CurrencyTransfers.NetworkRequests.processTransferRequest)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Models.ProcessTransferModel)
require(CurrencyTransfers.Models.ErrorTransferModel)
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local handleTransferSuccess = require(CurrencyTransfers.Actions.Send.handleTransferSuccess)
local handleTransferError = require(CurrencyTransfers.Actions.Send.handleTransferError)
local handleTransferBlock = require(CurrencyTransfers.Actions.Send.handleTransferBlock)
local TransferRetryOrigin = require(CurrencyTransfers.Enums.TransferRetryOrigin)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function processTransfer(data, robuxAmount: number)
	local networkImpl = data.getNetworkImpl()
	local setPromptState = data.setPromptState

	local transferRequestId = data.getTransferRequestId(false)

	if transferRequestId then
		setPromptState(PromptState.TransferProcessing)
		logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferProcessAttemptedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.process_attempted)
		end

		return processTransferRequest(
			{ transferRequestId = transferRequestId, robuxAmount = robuxAmount },
			nil,
			networkImpl
		):andThen(function(p)
			if p and p.success then
				logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferProcessSucceededCounter)

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.process_succeeded)
				end

				handleTransferSuccess(data)
			else
				logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferProcessFailedCounter)

				if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
					logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.process_failed)
				end

				handleTransferError(data)
			end
		end):catch(function(data2)
			logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferProcessFailedCounter)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.process_failed)
			end

			if typeof(data2) ~= "table" or not data2.errorMessage then
				handleTransferError(data, nil)
			elseif
				data2.failureReason == FailureReason.AmpRecourseAvailable
				and data2.ampRecourseActions
				and data2.ampFeatureCheck
			then
				handleTransferBlock(
					data,
					data2.ampRecourseActions,
					data2.ampFeatureCheck,
					TransferRetryOrigin.ProcessTransfer
				)
			else
				handleTransferError(data, data2)
			end
		end)
	end

	logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferProcessFailedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.process_failed)
	end

	handleTransferError(data)
end

return processTransfer
