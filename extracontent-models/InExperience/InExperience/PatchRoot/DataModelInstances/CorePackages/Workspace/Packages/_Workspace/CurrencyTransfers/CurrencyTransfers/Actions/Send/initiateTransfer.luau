local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)

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

local function initiateTransfer(p1) -- line: 26
	-- upvalues: PromptState (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), initiateTransferRequest (copy), setTransferPromptState (copy), GetFFlagCurrencyTransferUseBackendTransferLimits (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), FailureReason (copy), handleTransferBlock (copy), TransferRetryOrigin (copy), handleTransferError (copy)
	local v18 = p1.getNetworkImpl()
	local setPromptState = p1.setPromptState
	local setTransferRequestId = p1.setTransferRequestId
	local setRobuxBalanceAmount = p1.setRobuxBalanceAmount
	local setBalanceReceivedFromApi = p1.setBalanceReceivedFromApi
	local setUserRelationshipDetail = p1.setUserRelationshipDetail
	local setRecipient = p1.setRecipient
	local setSender = p1.setSender
	local setMinimumTransferAmount = p1.setMinimumTransferAmount
	local setMaximumTransferAmount = p1.setMaximumTransferAmount
	local v28 = p1.getRecipientUserId(false)

	setPromptState(PromptState.TransferRequested)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.initiate_attempted)
	end

	local t1 = {
		recipientId = v28
	}
	local v30 = p1.getTransferOrigination()

	if v30 then
		t1.transferOrigination = v30
	end

	initiateTransferRequest(t1, nil, v18):andThen(function(p2) -- line: 51
		-- upvalues: setTransferPromptState (copy), p1 (copy), PromptState (copy), setTransferRequestId (copy), setRobuxBalanceAmount (copy), setBalanceReceivedFromApi (copy), setUserRelationshipDetail (copy), setRecipient (copy), setSender (copy), GetFFlagCurrencyTransferUseBackendTransferLimits (copy), setMinimumTransferAmount (copy), setMaximumTransferAmount (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy)
		setTransferPromptState(p1, PromptState.TransferStarted)

		if p2 and (p2.transferRequestId and p2.robuxTransfer) then
			setTransferRequestId(p2.transferRequestId)
			setRobuxBalanceAmount(p2.senderRobuxBalance)
			setBalanceReceivedFromApi(true)
			setUserRelationshipDetail(p2.userRelationshipDetail)
			setRecipient(p2.robuxTransfer.recipient)
			setSender(p2.robuxTransfer.sender)

			if GetFFlagCurrencyTransferUseBackendTransferLimits() then
				if p2.minimumTransferAmount then
					setMinimumTransferAmount(p2.minimumTransferAmount)
				end

				if p2.maximumTransferAmount then
					setMaximumTransferAmount(p2.maximumTransferAmount)
				end
			end

			setTransferPromptState(p1, PromptState.TransferInput)
			logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferInitiateSucceededCounter)

			if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
				logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.initiate_succeeded)
			end
		end
	end):catch(function(p3) -- line: 79
		-- upvalues: logCurrencyTransferCounter (copy), p1 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), FailureReason (copy), handleTransferBlock (copy), TransferRetryOrigin (copy), handleTransferError (copy)
		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferInitiateFailedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.initiate_failed)
		end

		if typeof(p3) == "table" and p3.errorMessage then
			if p3.failureReason == FailureReason.AmpRecourseAvailable and p3.ampRecourseActions and p3.ampFeatureCheck then
				handleTransferBlock(p1, p3.ampRecourseActions, p3.ampFeatureCheck, TransferRetryOrigin.InitiateTransfer)

				return
			end

			handleTransferError(p1, p3)

			return
		end

		handleTransferError(p1, nil)
	end)
end

return initiateTransfer
