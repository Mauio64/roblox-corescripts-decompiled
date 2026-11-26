local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local acceptTransferRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/NetworkRequests/acceptTransferRequest")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/AcceptTransferModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ErrorTransferModel")
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/FailureReason")
local handleReceiveSuccess = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/handleReceiveSuccess")
local handleReceiveError = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/handleReceiveError")
local handleReceiveBlock = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/handleReceiveBlock")
local TransferRetryOrigin = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

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

		return acceptTransferRequest({ transferRequestId = transferRequestId }, nil, networkImpl):andThen(function(p2)
			setPromptState(PromptState.ReceiveStarted)

			if p2 and p2.robuxTransfer then
				setRobuxTransfer(p2.robuxTransfer)
				setIsAlreadyAccepted(p2.isAlreadyAccepted == true)

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
				handleReceiveBlock(data, data2.ampRecourseActions, data2.ampFeatureCheck, TransferRetryOrigin.AcceptTransfer)
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
