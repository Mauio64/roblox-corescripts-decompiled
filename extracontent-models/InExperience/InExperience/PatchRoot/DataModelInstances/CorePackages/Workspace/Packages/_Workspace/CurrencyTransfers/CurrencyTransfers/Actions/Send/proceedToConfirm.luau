local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Models.InitiateTransferModel)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)

local function proceedToConfirm(p, p2: number)
	p.setSelectedAmount(p2)
	setTransferPromptState(p, PromptState.TransferConfirm)
end

return proceedToConfirm
