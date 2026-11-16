local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function handleReceiveSuccess(p)
	p.setPromptState(PromptState.ReceiveSuccess)
end

return handleReceiveSuccess
