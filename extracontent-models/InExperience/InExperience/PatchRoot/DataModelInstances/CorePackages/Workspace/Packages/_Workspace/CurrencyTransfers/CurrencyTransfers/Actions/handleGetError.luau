local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)

require(CurrencyTransfers.Models.ErrorTransferModel)

local function handleGetError(p1, p2) -- line: 11
	-- upvalues: TransferDirection (copy), PromptState (copy)
	local setPromptState = p1.setPromptState
	local setErrorTransferModel = p1.setErrorTransferModel
	local getDirection = p1.getDirection

	if p2 then
		setErrorTransferModel(p2)
	else
		setErrorTransferModel(nil)
	end

	if getDirection(false) == TransferDirection.Receive then
		setPromptState(PromptState.ReceiveError)

		return
	end

	setPromptState(PromptState.TransferError)
end

return handleGetError
