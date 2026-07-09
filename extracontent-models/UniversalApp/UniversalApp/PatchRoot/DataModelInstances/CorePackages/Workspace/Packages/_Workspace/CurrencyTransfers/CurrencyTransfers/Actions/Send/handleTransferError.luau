local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)

require(CurrencyTransfers.Models.ErrorTransferModel)

local function handleTransferError(p1, p2) -- line: 10
	-- upvalues: PromptState (copy)
	local setPromptState = p1.setPromptState
	local setErrorTransferModel = p1.setErrorTransferModel

	if p2 then
		setErrorTransferModel(p2)
	else
		setErrorTransferModel(nil)
	end

	setPromptState(PromptState.TransferError)
end

return handleTransferError
