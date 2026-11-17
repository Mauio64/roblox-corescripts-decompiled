local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local SharedFlags = require(parent.SharedFlags)

require(CurrencyTransfers.Stores.createTransferStore)
local getTransferRequestByIdRequest = require(CurrencyTransfers.NetworkRequests.getTransferRequestByIdRequest)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Enums.TransferRetryOrigin)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local function handleTransferBlock(data, p, p2: string?, p3, flag: boolean?)
	local setPromptState = data.setPromptState
	local setAmpRecourseActions = data.setAmpRecourseActions
	local setAmpFeatureCheck = data.setAmpFeatureCheck
	local setTransferRetryOrigin = data.setTransferRetryOrigin
	local setFreeTransfersExhausted = data.setFreeTransfersExhausted
	local setRecipient = data.setRecipient
	local getRecipient = data.getRecipient
	local getTransferRequestId = data.getTransferRequestId

	local function applyBlockState()
		logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAmpRecourseRequiredCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.amp_recourse_required)
		end

		if p then
			setAmpRecourseActions(p)
		end

		if p2 then
			setAmpFeatureCheck(p2)
		end

		if p3 then
			setTransferRetryOrigin(p3)
		end

		setFreeTransfersExhausted(flag == true)
		setPromptState(PromptState.TransferBlocked)
	end

	if getRecipient(false) then
		applyBlockState()
		return
	end

	local transferRequestId = getTransferRequestId(false)

	if transferRequestId then
		getTransferRequestByIdRequest({ transferRequestId = transferRequestId }, nil, data.getNetworkImpl()):andThen(function(p4)
			if p4 and p4.transfer and p4.transfer.recipient then
				setRecipient(p4.transfer.recipient)
			end

			applyBlockState()
		end):catch(function()
			applyBlockState()
		end)
	else
		applyBlockState()
	end
end

return handleTransferBlock
