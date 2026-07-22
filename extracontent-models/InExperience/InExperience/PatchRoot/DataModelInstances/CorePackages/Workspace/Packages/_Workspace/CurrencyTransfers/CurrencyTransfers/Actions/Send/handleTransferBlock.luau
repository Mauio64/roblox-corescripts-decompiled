local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)

require(CurrencyTransfers.Stores.createTransferStore)

local getTransferRequestByIdRequest = require(CurrencyTransfers.NetworkRequests.getTransferRequestByIdRequest)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

require(CurrencyTransfers.Enums.TransferRetryOrigin)

local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function handleTransferBlock(p1, t1: {[any]: any}?, s1: string?, p2) -- line: 17
	-- upvalues: logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), PromptState (copy), getTransferRequestByIdRequest (copy)
	local setPromptState = p1.setPromptState
	local setAmpRecourseActions = p1.setAmpRecourseActions
	local setAmpFeatureCheck = p1.setAmpFeatureCheck
	local setTransferRetryOrigin = p1.setTransferRetryOrigin
	local setRecipient = p1.setRecipient
	local getRecipient = p1.getRecipient
	local getTransferRequestId = p1.getTransferRequestId

	local function applyBlockState() -- line: 31
		-- upvalues: logCurrencyTransferCounter (copy), p1 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), t1 (copy), setAmpRecourseActions (copy), s1 (copy), setAmpFeatureCheck (copy), p2 (copy), setTransferRetryOrigin (copy), setPromptState (copy), PromptState (copy)
		logCurrencyTransferCounter(p1, CurrencyTransferTelemetry.CurrencyTransferAmpRecourseRequiredCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(p1, RobuxTransferFlowEventName.amp_recourse_required)
		end

		if t1 then
			setAmpRecourseActions(t1)
		end

		if s1 then
			setAmpFeatureCheck(s1)
		end

		if p2 then
			setTransferRetryOrigin(p2)
		end

		setPromptState(PromptState.TransferBlocked)
	end

	if getRecipient(false) then
		applyBlockState()

		return
	end

	local v23 = getTransferRequestId(false)

	if not v23 then
		applyBlockState()

		return
	end

	getTransferRequestByIdRequest({
		transferRequestId = v23
	}, nil, p1.getNetworkImpl()):andThen(function(p3) -- line: 60
		-- upvalues: setRecipient (copy), applyBlockState (copy)
		if p3 and (p3.transfer and p3.transfer.recipient) then
			setRecipient(p3.transfer.recipient)
		end

		applyBlockState()
	end):catch(function() -- line: 66
		-- upvalues: applyBlockState (copy)
		applyBlockState()
	end)
end

return handleTransferBlock
