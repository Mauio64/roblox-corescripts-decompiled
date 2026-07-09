local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function handleTransferSuccess(p1) -- line: 7
	-- upvalues: PromptState (copy)
	p1.setPromptState(PromptState.TransferSuccess)
end

return handleTransferSuccess
