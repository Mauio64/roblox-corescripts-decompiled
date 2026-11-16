local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local getTransferRequestByIdRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/getTransferRequestByIdRequest")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local function handleTransferBlock(data, p2, p3, p4)
	local setPromptState = data.setPromptState
	local setAmpRecourseActions = data.setAmpRecourseActions
	local setAmpFeatureCheck = data.setAmpFeatureCheck
	local setTransferRetryOrigin = data.setTransferRetryOrigin
	local setRecipient = data.setRecipient
	local getRecipient = data.getRecipient
	local getTransferRequestId = data.getTransferRequestId

	local function applyBlockState()
		logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferAmpRecourseRequiredCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.amp_recourse_required)
		end

		if p2 then
			setAmpRecourseActions(p2)
		end

		if p3 then
			setAmpFeatureCheck(p3)
		end

		if p4 then
			setTransferRetryOrigin(p4)
		end

		setPromptState(PromptState.TransferBlocked)
	end

	if getRecipient(false) then
		applyBlockState()
		return
	end

	local transferRequestId = getTransferRequestId(false)

	if transferRequestId then
		getTransferRequestByIdRequest({ transferRequestId = transferRequestId }, nil, data.getNetworkImpl()):andThen(function(p5)
			if p5 and p5.transfer and p5.transfer.recipient then
				setRecipient(p5.transfer.recipient)
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
