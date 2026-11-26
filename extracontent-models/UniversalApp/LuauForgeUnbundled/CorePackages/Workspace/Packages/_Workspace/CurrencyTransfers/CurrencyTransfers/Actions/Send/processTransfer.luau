local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local processTransferRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/processTransferRequest")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ProcessTransferModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ErrorTransferModel")
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/FailureReason")
local handleTransferSuccess = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferSuccess")
local handleTransferError = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferError")
local handleTransferBlock = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferBlock")
local TransferRetryOrigin = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local function processTransfer(data, p2)
	local networkImpl = data.getNetworkImpl()
	local setPromptState = data.setPromptState

	local transferRequestId = data.getTransferRequestId(false)

	if transferRequestId then
		setPromptState(PromptState.TransferProcessing)
		logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferProcessAttemptedCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.process_attempted)
		end

		return processTransferRequest({ transferRequestId = transferRequestId, robuxAmount = p2 }, nil, networkImpl):andThen(function(p3)
			if p3 and p3.success then
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
				handleTransferBlock(data, data2.ampRecourseActions, data2.ampFeatureCheck, TransferRetryOrigin.ProcessTransfer)
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
