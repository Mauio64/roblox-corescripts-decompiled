local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
require(CurrencyTransfers.Models.ErrorTransferModel)

local function handleTransferError(p, p2)
	local setPromptState = p.setPromptState
	local setErrorTransferModel = p.setErrorTransferModel

	if p2 then
		setErrorTransferModel(p2)
	else
		setErrorTransferModel(nil)
	end

	setPromptState(PromptState.TransferError)
end

return handleTransferError
