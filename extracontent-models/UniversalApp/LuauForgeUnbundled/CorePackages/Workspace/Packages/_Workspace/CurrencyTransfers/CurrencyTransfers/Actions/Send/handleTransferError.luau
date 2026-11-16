require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/ErrorTransferModel")

local function handleTransferError(p2, p3)
	local setPromptState = p2.setPromptState
	local setErrorTransferModel = p2.setErrorTransferModel

	if p3 then
		setErrorTransferModel(p3)
	else
		setErrorTransferModel(nil)
	end

	setPromptState(PromptState.TransferError)
end

return handleTransferError
