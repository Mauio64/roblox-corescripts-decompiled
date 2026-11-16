local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferRobuxInputSheet = require(CurrencyTransfers.Components.Send.TransferRobuxInputSheet)
local TransferRobuxConfirmSheet = require(CurrencyTransfers.Components.Send.TransferRobuxConfirmSheet)
local TransferRobuxErrorSheet = require(CurrencyTransfers.Components.Send.TransferRobuxErrorSheet)
local InsufficientBalanceSheet = require(CurrencyTransfers.Components.Send.InsufficientBalanceSheet)
local TransferRobuxSuccessToast = require(CurrencyTransfers.Components.Send.TransferRobuxSuccessToast)
local TransferRobuxSuccessModal = require(CurrencyTransfers.Components.Send.TransferRobuxSuccessModal)
local TransferBlockSheet = require(CurrencyTransfers.Components.Send.TransferBlockSheet)
local ReceiveRobuxSuccessToast = require(CurrencyTransfers.Components.Receive.ReceiveRobuxSuccessToast)
local ReceiveBlockSheet = require(CurrencyTransfers.Components.Receive.ReceiveBlockSheet)
local ReceiveErrorSheet = require(CurrencyTransfers.Components.Receive.ReceiveErrorSheet)

local GetFFlagCurrencyTransferSuccessModal = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferSuccessModal)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local function TransferRobuxContainer(_)
	local v = useTransferStore()
	local v2 = SignalsReact.useSignalState(v.getPromptState)

	if v2 == PromptState.TransferInput then
		return React.createElement(TransferRobuxInputSheet, {})
	end

	if v2 == PromptState.TransferInsufficientBalance then
		return React.createElement(InsufficientBalanceSheet, {})
	end

	if v2 == PromptState.TransferConfirm then
		return React.createElement(TransferRobuxConfirmSheet, {})
	end

	if v2 == PromptState.TransferSuccess then
		if GetFFlagCurrencyTransferSuccessModal() then
			return React.createElement(TransferRobuxSuccessModal, {})
		end

		return React.createElement(TransferRobuxSuccessToast, {})
	end

	if v2 == PromptState.TransferError then
		return React.createElement(TransferRobuxErrorSheet, {})
	end

	if v2 == PromptState.TransferBlocked then
		return React.createElement(TransferBlockSheet)
	end

	if v2 == PromptState.ReceiveSuccess then
		return React.createElement(ReceiveRobuxSuccessToast, {})
	end

	if v2 == PromptState.ReceiveBlocked then
		return React.createElement(ReceiveBlockSheet)
	end

	if v2 == PromptState.ReceiveError then
		return React.createElement(ReceiveErrorSheet, {})
	end

	return nil
end

return TransferRobuxContainer
