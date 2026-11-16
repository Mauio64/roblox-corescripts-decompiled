local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

local TransferRobuxApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/TransferRobuxApp")
local createTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")

local GetFFlagCurrencyTransferUseBackendTransferLimits = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferUseBackendTransferLimits")
local handleTransferError = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferError")
local handleTransferBlock = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferBlock")
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/FailureReason")
local ErrorTransferModel = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ErrorTransferModel")
local TransferRetryOrigin = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferRetryOrigin")
local AmpWizardTransferConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/AmpWizardTransferConstants")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local function InExperienceTransferFlow(p2)
	local initiateResponse = p2.initiateResponse
	assert(type(initiateResponse) == "table", "[InExperienceTransferFlow] initiateResponse must be a table")

	local v5 = createTransferStore()

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		v5.setTransferClientSessionId(HttpService:GenerateGUID(false))
	end

	v5.setDirection(TransferDirection.Send)
	v5.setTransferOrigination(TransferOrigination.InExperience)

	logCurrencyTransferCounter(v5, CurrencyTransferTelemetry.CurrencyTransferFlowOpenedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(v5, RobuxTransferFlowEventName.in_experience_flow_open)
	end

	if p2.onClose then
		v5.setOnClose(p2.onClose)
	end

	if GetFFlagCurrencyTransferUseBackendTransferLimits() then
		if initiateResponse.minimumTransferAmount then
			v5.setMinimumTransferAmount(initiateResponse.minimumTransferAmount)
		end

		if initiateResponse.maximumTransferAmount then
			v5.setMaximumTransferAmount(initiateResponse.maximumTransferAmount)
		end
	end

	if initiateResponse.failureReason == nil then
		assert(
			initiateResponse.transferRequestId,
			"[InExperienceTransferFlow] Missing initiateResponse.transferRequestId"
		)
		local transferAmount = initiateResponse.robuxTransfer.transferAmount

		local v6 = type(transferAmount) == "number" and transferAmount > 0
		assert(v6, "[InExperienceTransferFlow] transferAmount must be a positive number")

		v5.setTransferRequestId(initiateResponse.transferRequestId)
		v5.setRobuxBalanceAmount(initiateResponse.senderRobuxBalance)
		v5.setBalanceReceivedFromApi(true)
		v5.setUserRelationshipDetail(initiateResponse.userRelationshipDetail)
		v5.setRecipient(initiateResponse.robuxTransfer.recipient)
		v5.setSender(initiateResponse.robuxTransfer.sender)
		v5.setSelectedAmount(transferAmount)

		v5.setPromptState(PromptState.TransferConfirm)

		return React.createElement(TransferRobuxApp, { transferStore = v5 })
	else
		local formatted = ErrorTransferModel.format(initiateResponse)

		if
			formatted.failureReason == FailureReason.AmpRecourseAvailable
			and formatted.ampRecourseActions
			and formatted.ampFeatureCheck
		then
			if
				not table.find(formatted.ampRecourseActions, AmpWizardTransferConstants.RECOURSE_PLUS_SUBSCRIPTION)
				or formatted.ampFeatureCheck ~= "CanInitiateRobuxTransfer"
			then
				handleTransferBlock(
					v5,
					formatted.ampRecourseActions,
					formatted.ampFeatureCheck,
					TransferRetryOrigin.ProcessTransfer
				)
			end
		else
			handleTransferError(v5, formatted)
		end

		return React.createElement(TransferRobuxApp, { transferStore = v5 })
	end
end

return InExperienceTransferFlow
