require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")
local buildRobuxTransferFlowPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/buildRobuxTransferFlowPayload")
local sendRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/sendRobuxTransferFlowEvent")

local function logRobuxTransferFlowEvent(p2, p3, items)
	local v5 = buildRobuxTransferFlowPayload(p2, p3)

	if items then
		for k, item in pairs(items) do
			v5[k] = item
		end
	end

	sendRobuxTransferFlowEvent(v5)
end

return logRobuxTransferFlowEvent
