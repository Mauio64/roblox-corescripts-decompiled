local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)

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

local function processTransfer(p1, n1: number) -- line: 24
	-- upvalues: logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), handleTransferError (copy), PromptState (copy), processTransferRequest (copy), handleTransferSuccess (copy), FailureReason (copy), handleTransferBlock (copy), TransferRetryOrigin (copy)
	local v18 = p1.getNetworkImpl()
	local setPromptState = p1.setPromptState
	local v20 = p1.getTransferRequestId(false)

	if not v20 then
		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferProcessFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.process_failed)
		end

		handleTransferError(p1)

		return
	end

	setPromptState(PromptState.TransferProcessing)
	logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferProcessAttemptedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.process_attempted)
	end

	local t1 = {
		transferRequestId = v20,
		robuxAmount = n1
	}

	return processTransferRequest(t1, nil, v18):andThen(function(p2) -- line: 53
		-- upvalues: logCurrencyTransferCounter (copy), p1 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), handleTransferSuccess (copy), handleTransferError (copy)
		if p2 and p2.success then
			logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferProcessSucceededCounter)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.process_succeeded)
			end

			handleTransferSuccess(p1)

			return
		end

		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferProcessFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.process_failed)
		end

		handleTransferError(p1)
	end):catch(function(p3) -- line: 74
		-- upvalues: logCurrencyTransferCounter (copy), p1 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), FailureReason (copy), handleTransferBlock (copy), TransferRetryOrigin (copy), handleTransferError (copy)
		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferProcessFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.process_failed)
		end

		if typeof(p3) == "table" and p3.errorMessage then
			if p3.failureReason == FailureReason.AmpRecourseAvailable and p3.ampRecourseActions and p3.ampFeatureCheck then
				handleTransferBlock(p1, p3.ampRecourseActions, p3.ampFeatureCheck, TransferRetryOrigin.ProcessTransfer)

				return
			end

			handleTransferError(p1, p3)

			return
		end

		handleTransferError(p1, nil)
	end)
end

return processTransfer
