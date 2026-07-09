local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
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

local function TransferRobuxContainer(_: {[any]: any}) -- line: 30
	-- upvalues: useTransferStore (copy), SignalsReact (copy), PromptState (copy), React (copy), TransferRobuxInputSheet (copy), InsufficientBalanceSheet (copy), TransferRobuxConfirmSheet (copy), GetFFlagCurrencyTransferSuccessModal (copy), TransferRobuxSuccessModal (copy), TransferRobuxSuccessToast (copy), TransferRobuxErrorSheet (copy), TransferBlockSheet (copy), ReceiveRobuxSuccessToast (copy), ReceiveBlockSheet (copy), ReceiveErrorSheet (copy)
	local v20 = useTransferStore()
	local v21 = SignalsReact.useSignalState(v20.getPromptState)

	if v21 == PromptState.TransferInput then
		return React.createElement(TransferRobuxInputSheet, {})
	end

	if v21 == PromptState.TransferInsufficientBalance then
		return React.createElement(InsufficientBalanceSheet, {})
	end

	if v21 == PromptState.TransferConfirm then
		return React.createElement(TransferRobuxConfirmSheet, {})
	end

	if v21 == PromptState.TransferSuccess then
		if GetFFlagCurrencyTransferSuccessModal() then
			return React.createElement(TransferRobuxSuccessModal, {})
		end

		return React.createElement(TransferRobuxSuccessToast, {})
	end

	if v21 == PromptState.TransferError then
		return React.createElement(TransferRobuxErrorSheet, {})
	end

	if v21 == PromptState.TransferBlocked then
		return React.createElement(TransferBlockSheet)
	end

	if v21 == PromptState.ReceiveSuccess then
		return React.createElement(ReceiveRobuxSuccessToast, {})
	end

	if v21 == PromptState.ReceiveBlocked then
		return React.createElement(ReceiveBlockSheet)
	end

	if v21 == PromptState.ReceiveError then
		return React.createElement(ReceiveErrorSheet, {})
	end

	return nil
end

return TransferRobuxContainer
