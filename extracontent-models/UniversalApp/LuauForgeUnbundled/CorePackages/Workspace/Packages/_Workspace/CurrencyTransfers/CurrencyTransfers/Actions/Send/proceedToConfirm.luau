require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Models/InitiateTransferModel")
local setTransferPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/setTransferPromptState")

local function proceedToConfirm(p2, p3)
	p2.setSelectedAmount(p3)
	setTransferPromptState(p2, PromptState.TransferConfirm)
end

return proceedToConfirm
