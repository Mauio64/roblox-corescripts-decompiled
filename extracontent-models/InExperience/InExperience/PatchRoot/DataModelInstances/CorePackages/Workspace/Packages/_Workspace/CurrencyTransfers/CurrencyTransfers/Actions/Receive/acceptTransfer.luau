local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)

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

local function acceptTransfer(p1) -- line: 25
	-- upvalues: logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), handleReceiveError (copy), PromptState (copy), acceptTransferRequest (copy), handleReceiveSuccess (copy), FailureReason (copy), handleReceiveBlock (copy), TransferRetryOrigin (copy)
	local v17 = p1.getNetworkImpl()
	local setPromptState = p1.setPromptState
	local setRobuxTransfer = p1.setRobuxTransfer
	local setIsAlreadyAccepted = p1.setIsAlreadyAccepted
	local v21 = p1.getTransferRequestId(false)

	if not v21 then
		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferAcceptFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.accept_failed)
		end

		handleReceiveError(p1, nil)

		return
	end

	setPromptState(PromptState.ReceiveRequested)

	local t1 = {
		transferRequestId = v21
	}

	logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferAcceptAttemptedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.accept_attempted)
	end

	return acceptTransferRequest(t1, nil, v17):andThen(function(p2) -- line: 54
		-- upvalues: setPromptState (copy), PromptState (copy), setRobuxTransfer (copy), setIsAlreadyAccepted (copy), logCurrencyTransferCounter (copy), p1 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), handleReceiveSuccess (copy), handleReceiveError (copy)
		setPromptState(PromptState.ReceiveStarted)

		if p2 and p2.robuxTransfer then
			setRobuxTransfer(p2.robuxTransfer)
			setIsAlreadyAccepted(p2.isAlreadyAccepted == true)
			logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferAcceptSucceededCounter)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.accept_succeeded)
			end

			handleReceiveSuccess(p1)

			return
		end

		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferAcceptFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.accept_failed)
		end

		handleReceiveError(p1, nil)
	end):catch(function(p3) -- line: 76
		-- upvalues: logCurrencyTransferCounter (copy), p1 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), FailureReason (copy), handleReceiveBlock (copy), TransferRetryOrigin (copy), handleReceiveError (copy)
		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferAcceptFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.accept_failed)
		end

		if typeof(p3) == "table" and p3.errorMessage then
			if p3.failureReason == FailureReason.AmpRecourseAvailable and p3.ampRecourseActions and p3.ampFeatureCheck then
				handleReceiveBlock(p1, p3.ampRecourseActions, p3.ampFeatureCheck, TransferRetryOrigin.AcceptTransfer)

				return
			end

			handleReceiveError(p1, p3)

			return
		end

		handleReceiveError(p1, nil)
	end)
end

return acceptTransfer
