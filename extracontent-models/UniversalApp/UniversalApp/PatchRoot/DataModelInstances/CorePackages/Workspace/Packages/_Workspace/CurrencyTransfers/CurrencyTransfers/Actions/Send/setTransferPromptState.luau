local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)

require(CurrencyTransfers.Models.InitiateTransferModel)

local t1 = {
	[PromptState.TransferRequested] = { PromptState.TransferStarted },
	[PromptState.TransferStarted] = { PromptState.TransferInput },
	[PromptState.TransferInput] = {
		PromptState.TransferConfirm,
		PromptState.TransferInsufficientBalance
	},
	[PromptState.TransferInsufficientBalance] = {
		PromptState.TransferInput,
		PromptState.TransferConfirm
	},
	[PromptState.TransferConfirm] = {
		PromptState.TransferInput,
		PromptState.TransferProcessing,
		PromptState.TransferConfirm,
		PromptState.TransferInsufficientBalance
	},
	[PromptState.TransferProcessing] = { PromptState.TransferSuccess }
}

local function isValidPromptStateTransition(p1, p2) -- line: 26
	-- upvalues: t1 (copy)
	local v8 = t1[p1]

	for _, v in ipairs(v8) do
		if v == p2 then
			return true
		end
	end

	return false
end
local function setTransferPromptState(p3, p4) -- line: 36
	-- upvalues: t1 (copy), PromptState (copy)
	local setPromptState = p3.setPromptState
	local v14 = t1[p3.getPromptState(false)]
	local g18 = nil
	local v17 = nil

	for _, v in ipairs(v14) do
		if v == p4 then
			v17 = true
			g18 = true
		end

		if g18 then
			break
		end
	end

	if not g18 then
		v17 = false
	end

	g18 = false

	if not v17 then
		setPromptState(PromptState.TransferError)

		return
	end

	setPromptState(p4)
end

return setTransferPromptState
