local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)

local function handleReceiveComplete(p1) -- line: 8
	-- upvalues: PromptState (copy)
	local setPromptState = p1.setPromptState
	local triggerOnClose = p1.triggerOnClose

	setPromptState(PromptState.ReceiveComplete)
	triggerOnClose()
end

return handleReceiveComplete
