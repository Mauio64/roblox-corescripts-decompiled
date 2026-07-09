local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function handleReceiveSuccess(p1) -- line: 7
	-- upvalues: PromptState (copy)
	p1.setPromptState(PromptState.ReceiveSuccess)
end

return handleReceiveSuccess
