require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/InitiateTransferModel")

local v5 = {
	[PromptState.TransferRequested] = { PromptState.TransferStarted },
	[PromptState.TransferStarted] = { PromptState.TransferInput },
	[PromptState.TransferInput] = { PromptState.TransferConfirm, PromptState.TransferInsufficientBalance },
	[PromptState.TransferInsufficientBalance] = { PromptState.TransferInput, PromptState.TransferConfirm },
	[PromptState.TransferConfirm] = {
		PromptState.TransferInput,
		PromptState.TransferProcessing,
		PromptState.TransferConfirm,
		PromptState.TransferInsufficientBalance
	},
	[PromptState.TransferProcessing] = { PromptState.TransferSuccess }
}

local function isValidPromptStateTransition(p2, p3): boolean
	local v6 = v5[p2]

	for i, v7 in ipairs(v6) do
		if v7 == p3 then
			return true
		end
	end

	return false
end

local function setTransferPromptState(p2, p3)
	local setPromptState = p2.setPromptState
	local v6 = v5[p2.getPromptState(false)]
	local flag = true
	local flag2

	for i, v7 in ipairs(v6) do
		if v7 == p3 then
			flag2 = true
			flag = false
			break
		end
	end

	if flag then
		flag2 = false
	end

	if flag2 then
		setPromptState(p3)
	else
		setPromptState(PromptState.TransferError)
	end
end

return setTransferPromptState
