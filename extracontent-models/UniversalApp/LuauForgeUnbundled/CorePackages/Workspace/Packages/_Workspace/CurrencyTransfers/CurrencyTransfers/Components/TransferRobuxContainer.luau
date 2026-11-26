local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferRobuxInputSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/TransferRobuxInputSheet")
local TransferRobuxConfirmSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/TransferRobuxConfirmSheet")
local TransferRobuxErrorSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/TransferRobuxErrorSheet")
local InsufficientBalanceSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/InsufficientBalanceSheet")
local TransferRobuxSuccessToast = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/TransferRobuxSuccessToast")
local TransferRobuxSuccessModal = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/TransferRobuxSuccessModal")
local TransferBlockSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Send/TransferBlockSheet")
local ReceiveRobuxSuccessToast = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Receive/ReceiveRobuxSuccessToast")
local ReceiveBlockSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Receive/ReceiveBlockSheet")
local ReceiveErrorSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Receive/ReceiveErrorSheet")

local GetFFlagCurrencyTransferSuccessModal = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferSuccessModal")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local function TransferRobuxContainer(p2)
	local v5 = useTransferStore()
	local v6 = SignalsReact.useSignalState(v5.getPromptState)

	if v6 == PromptState.TransferInput then
		return React.createElement(TransferRobuxInputSheet, {})
	end

	if v6 == PromptState.TransferInsufficientBalance then
		return React.createElement(InsufficientBalanceSheet, {})
	end

	if v6 == PromptState.TransferConfirm then
		return React.createElement(TransferRobuxConfirmSheet, {})
	end

	if v6 == PromptState.TransferSuccess then
		if GetFFlagCurrencyTransferSuccessModal() then
			return React.createElement(TransferRobuxSuccessModal, {})
		end

		return React.createElement(TransferRobuxSuccessToast, {})
	end

	if v6 == PromptState.TransferError then
		return React.createElement(TransferRobuxErrorSheet, {})
	end

	if v6 == PromptState.TransferBlocked then
		return React.createElement(TransferBlockSheet)
	end

	if v6 == PromptState.ReceiveSuccess then
		return React.createElement(ReceiveRobuxSuccessToast, {})
	end

	if v6 == PromptState.ReceiveBlocked then
		return React.createElement(ReceiveBlockSheet)
	end

	if v6 == PromptState.ReceiveError then
		return React.createElement(ReceiveErrorSheet, {})
	end

	return nil
end

return TransferRobuxContainer
