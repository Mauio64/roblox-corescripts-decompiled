local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")

local TransferRobuxApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/TransferRobuxApp")
local createTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local initiateTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/initiateTransfer")
local acceptTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/acceptTransfer")
local TransferDirection = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local GetFFlagCurrencyTransferUseRoactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferUseRoactNetworking")

local function normalizeTransferOrigination(value)
	local v5 = string.lower(value)

	if v5 == "unknown" then
		return TransferOrigination.Unknown
	elseif v5 == "profile" then
		return TransferOrigination.Profile
	elseif v5 == "chat" then
		return TransferOrigination.Chat
	elseif v5 == "buyrobux" then
		return TransferOrigination.BuyRobux
	elseif v5 == "inexperience" then
		return TransferOrigination.InExperience
	end

	return TransferOrigination.Unknown
end

local function validateParams(p2)
	if p2.direction ~= TransferDirection.Send and p2.direction ~= TransferDirection.Receive then
		error(string.format(
			"[TransferRobuxFlow] Invalid direction: '%s'. Must be either TransferDirection.Send or TransferDirection.Receive.",
			(tostring(p2.direction))
		))
	end
end

local function initializeTransferStore(data, data2)
	local v5 = if GetFFlagCurrencyTransferUseRoactNetworking() then data2.networkImpl else nil
	data.setNetworkImpl(v5)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		data.setTransferClientSessionId(HttpService:GenerateGUID(false))
	end

	data.setOnClose(data2.onClose)

	if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then
		data.setOnPromptOptimisticHide(data2.onPromptOptimisticHide)
		data.setOnPromptDismissCommitted(data2.onPromptDismissCommitted)
	end

	data.setDirection(data2.direction)

	if data2.transferOrigination then
		local setTransferOrigination = data.setTransferOrigination
		local transferOrigination = data2.transferOrigination
		local v6 = string.lower(transferOrigination)
		local v7

		if v6 == "unknown" then
			v7 = TransferOrigination.Unknown
		elseif v6 == "profile" then
			v7 = TransferOrigination.Profile
		elseif v6 == "chat" then
			v7 = TransferOrigination.Chat
		elseif v6 == "buyrobux" then
			v7 = TransferOrigination.BuyRobux
		else
			v7 = if v6 == "inexperience" then TransferOrigination.InExperience else TransferOrigination.Unknown
		end

		setTransferOrigination(v7)
	end

	if data2.direction == TransferDirection.Send then
		if data2.recipientUserId then
			data.setRecipientUserId(data2.recipientUserId)
		end

		initiateTransfer(data)
	elseif data2.direction == TransferDirection.Receive then
		if data2.transferId then
			data.setTransferRequestId(data2.transferId)
		end

		acceptTransfer(data)
	end

	logCurrencyTransferCounter(data, CurrencyTransferTelemetry.CurrencyTransferFlowOpenedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(data, RobuxTransferFlowEventName.in_app_flow_open)
	end
end

local function renderTransferRobuxFlowImmediate(p2)
	local v5 = createTransferStore()
	initializeTransferStore(v5, p2)
	return React.createElement(TransferRobuxApp, { transferStore = v5 })
end

local function TransferRobuxFlowContainer(p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	if ref.current == nil then
		ref.current = createTransferStore()
	end

	local current = ref.current

	if not ref2.current then
		ref2.current = true
		initializeTransferStore(current, p2)
	end

	return React.createElement(TransferRobuxApp, { transferStore = current })
end

local function TransferRobuxFlow(p2)
	if p2.direction ~= TransferDirection.Send and p2.direction ~= TransferDirection.Receive then
		error(string.format(
			"[TransferRobuxFlow] Invalid direction: '%s'. Must be either TransferDirection.Send or TransferDirection.Receive.",
			(tostring(p2.direction))
		))
	end

	if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then
		return React.createElement(TransferRobuxFlowContainer, p2)
	end

	return renderTransferRobuxFlowImmediate(p2)
end

return TransferRobuxFlow
