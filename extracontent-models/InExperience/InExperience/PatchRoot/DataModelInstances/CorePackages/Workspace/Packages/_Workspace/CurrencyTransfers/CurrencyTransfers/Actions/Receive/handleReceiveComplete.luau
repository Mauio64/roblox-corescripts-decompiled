local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function handleReceiveComplete(p)
	local setPromptState = p.setPromptState
	local triggerOnClose = p.triggerOnClose
	setPromptState(PromptState.ReceiveComplete)
	triggerOnClose()
end

return handleReceiveComplete
