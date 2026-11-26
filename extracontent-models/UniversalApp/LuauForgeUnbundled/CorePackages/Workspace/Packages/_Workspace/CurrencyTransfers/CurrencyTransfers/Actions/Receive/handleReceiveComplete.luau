require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")

local function handleReceiveComplete(p2)
	local setPromptState = p2.setPromptState
	local triggerOnClose = p2.triggerOnClose
	setPromptState(PromptState.ReceiveComplete)
	triggerOnClose()
end

return handleReceiveComplete
