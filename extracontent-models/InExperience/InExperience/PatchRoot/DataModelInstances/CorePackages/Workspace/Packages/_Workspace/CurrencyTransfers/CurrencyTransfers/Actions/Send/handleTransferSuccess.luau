local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function handleTransferSuccess(p)
	p.setPromptState(PromptState.TransferSuccess)
end

return handleTransferSuccess
