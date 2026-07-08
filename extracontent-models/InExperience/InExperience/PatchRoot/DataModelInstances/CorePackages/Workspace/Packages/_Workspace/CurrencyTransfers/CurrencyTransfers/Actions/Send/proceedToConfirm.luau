local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)

require(CurrencyTransfers.Models.InitiateTransferModel)

local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)

local function proceedToConfirm(p1, n1: number) -- line: 10
	-- upvalues: setTransferPromptState (copy), PromptState (copy)
	p1.setSelectedAmount(n1)
	setTransferPromptState(p1, PromptState.TransferConfirm)
end

return proceedToConfirm
