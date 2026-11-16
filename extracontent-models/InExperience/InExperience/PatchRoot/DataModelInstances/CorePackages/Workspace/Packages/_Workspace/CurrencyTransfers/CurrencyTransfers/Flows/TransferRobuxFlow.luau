local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local TransferRobuxApp = require(CurrencyTransfers.Components.TransferRobuxApp)
local createTransferStore = require(CurrencyTransfers.Stores.createTransferStore)
local initiateTransfer = require(CurrencyTransfers.Actions.Send.initiateTransfer)
local acceptTransfer = require(CurrencyTransfers.Actions.Receive.acceptTransfer)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)

local GetFFlagCurrencyTransferUseRoactNetworking = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseRoactNetworking)

local function normalizeTransferOrigination(transferOrigination: string) -- 1 equivalent call inferred from this helper
	local v = string.lower(transferOrigination)

	if v == "unknown" then
		return TransferOrigination.Unknown
	elseif v == "profile" then
		return TransferOrigination.Profile
	elseif v == "chat" then
		return TransferOrigination.Chat
	elseif v == "buyrobux" then
		return TransferOrigination.BuyRobux
	elseif v == "inexperience" then
		return TransferOrigination.InExperience
	end

	return TransferOrigination.Unknown
end

local function validateParams(p) -- 1 equivalent call inferred from this helper
	if p.direction ~= TransferDirection.Send and p.direction ~= TransferDirection.Receive then
		error(string.format(
			"[TransferRobuxFlow] Invalid direction: '%s'. Must be either TransferDirection.Send or TransferDirection.Receive.",
			(tostring(p.direction))
		))
	end
end

local function initializeTransferStore(data, data2)
	local v

	if GetFFlagCurrencyTransferUseRoactNetworking() then
		v = data2.networkImpl
	end

	data.setNetworkImpl(v)

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
		data.setTransferOrigination(normalizeTransferOrigination(data2.transferOrigination)) -- inferred equivalent call
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

local function renderTransferRobuxFlowImmediate(p)
	local transferStore = createTransferStore()
	initializeTransferStore(transferStore, p)
	return React.createElement(TransferRobuxApp, { transferStore = transferStore })
end

local function TransferRobuxFlowContainer(p)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	if ref.current == nil then
		ref.current = createTransferStore()
	end

	local current = ref.current

	if not ref2.current then
		ref2.current = true
		initializeTransferStore(current, p)
	end

	return React.createElement(TransferRobuxApp, { transferStore = current })
end

local function TransferRobuxFlow(p)
	validateParams(p) -- inferred equivalent call

	if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then
		return React.createElement(TransferRobuxFlowContainer, p)
	end

	return renderTransferRobuxFlowImmediate(p)
end

return TransferRobuxFlow
