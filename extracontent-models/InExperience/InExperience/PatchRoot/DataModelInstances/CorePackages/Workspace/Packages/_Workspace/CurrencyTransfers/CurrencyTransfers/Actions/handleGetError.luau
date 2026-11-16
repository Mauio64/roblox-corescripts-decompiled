local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
require(CurrencyTransfers.Stores.createTransferStore)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferDirection = require(CurrencyTransfers.Enums.TransferDirection)
require(CurrencyTransfers.Models.ErrorTransferModel)

local function handleGetError(data, p)
	local setPromptState = data.setPromptState
	local setErrorTransferModel = data.setErrorTransferModel
	local getDirection = data.getDirection

	if p then
		setErrorTransferModel(p)
	else
		setErrorTransferModel(nil)
	end

	if getDirection(false) == TransferDirection.Receive then
		setPromptState(PromptState.ReceiveError)
	else
		setPromptState(PromptState.TransferError)
	end
end

return handleGetError
