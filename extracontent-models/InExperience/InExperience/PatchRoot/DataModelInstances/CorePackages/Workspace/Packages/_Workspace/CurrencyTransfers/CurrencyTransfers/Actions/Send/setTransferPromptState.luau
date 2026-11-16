local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Models.InitiateTransferModel)

local v = {
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

local function isValidPromptStateTransition(p, p2): boolean -- 1 equivalent call inferred from this helper
	local v2 = v[p]

	for _, v3 in ipairs(v2) do
		if v3 == p2 then
			return true
		end
	end

	return false
end

local function setTransferPromptState(p, p2)
	local setPromptState = p.setPromptState

	if isValidPromptStateTransition(p.getPromptState(false), p2) then -- inferred equivalent call
		setPromptState(p2)
	else
		setPromptState(PromptState.TransferError)
	end
end

return setTransferPromptState
