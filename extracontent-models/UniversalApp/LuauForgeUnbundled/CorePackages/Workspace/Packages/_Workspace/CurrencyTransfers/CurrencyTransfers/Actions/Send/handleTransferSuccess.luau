require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")

local function handleTransferSuccess(p2)
	p2.setPromptState(PromptState.TransferSuccess)
end

return handleTransferSuccess
