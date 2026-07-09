local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local HttpService = game:GetService("HttpService")
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
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

local function normalizeTransferOrigination(s1: string) -- line: 32
	-- upvalues: TransferOrigination (copy)
	local v19 = string.lower(s1)

	if v19 == "unknown" then
		return TransferOrigination.Unknown
	end

	if v19 == "profile" then
		return TransferOrigination.Profile
	end

	if v19 == "chat" then
		return TransferOrigination.Chat
	end

	if v19 == "buyrobux" then
		return TransferOrigination.BuyRobux
	end

	if v19 == "inexperience" then
		return TransferOrigination.InExperience
	end

	return TransferOrigination.Unknown
end
local function validateParams(t1: {[any]: any}) -- line: 52
	-- upvalues: TransferDirection (copy)
	if t1.direction ~= TransferDirection.Send and t1.direction ~= TransferDirection.Receive then
		error(string.format("[TransferRobuxFlow] Invalid direction: '%s'. Must be either TransferDirection.Send or TransferDirection.Receive.", (tostring(t1.direction))))
	end
end

function TransferRobuxFlow(t2: {[any]: any}) -- line: 64
	-- upvalues: TransferDirection (copy), createTransferStore (copy), SharedFlags (copy), HttpService (copy), TransferOrigination (copy), initiateTransfer (copy), acceptTransfer (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), React (copy), TransferRobuxApp (copy)
	if t2.direction ~= TransferDirection.Send and t2.direction ~= TransferDirection.Receive then
		error(string.format("[TransferRobuxFlow] Invalid direction: '%s'. Must be either TransferDirection.Send or TransferDirection.Receive.", (tostring(t2.direction))))
	end

	local v22 = createTransferStore()

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		v22.setTransferClientSessionId(HttpService:GenerateGUID(false))
	end

	v22.setOnClose(t2.onClose)
	v22.setDirection(t2.direction)

	if t2.transferOrigination then
		local setTransferOrigination = v22.setTransferOrigination
		local transferOrigination = t2.transferOrigination
		local v25 = string.lower(transferOrigination)

		setTransferOrigination(if v25 ~= "unknown" then if v25 ~= "profile" then if v25 ~= "chat" then if v25 ~= "buyrobux" then if v25 ~= "inexperience" then TransferOrigination.Unknown else TransferOrigination.InExperience else TransferOrigination.BuyRobux else TransferOrigination.Chat else TransferOrigination.Profile else TransferOrigination.Unknown)
	end

	if t2.direction == TransferDirection.Send then
		if t2.recipientUserId then
			v22.setRecipientUserId(t2.recipientUserId)
		end

		initiateTransfer(v22)
	elseif t2.direction == TransferDirection.Receive then
		if t2.transferId then
			v22.setTransferRequestId(t2.transferId)
		end

		acceptTransfer(v22)
	end

	logCurrencyTransferCounter(v22, CurrencyTransferTelemetry.CurrencyTransferFlowOpenedCounter)

	if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
		logRobuxTransferFlowEvent(v22, RobuxTransferFlowEventName.in_app_flow_open)
	end

	return (React.createElement(TransferRobuxApp, {
		transferStore = v22
	}))
end

return TransferRobuxFlow
