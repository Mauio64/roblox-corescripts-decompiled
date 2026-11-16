local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)
local buildRobuxTransferFlowPayload = require(CurrencyTransfers.Utils.buildRobuxTransferFlowPayload)
local sendRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.sendRobuxTransferFlowEvent)

local function logRobuxTransferFlowEvent(p, p2: string, items)
	local robuxTransferFlowPayload = buildRobuxTransferFlowPayload(p, p2)

	if items then
		for k, item in pairs(items) do
			robuxTransferFlowPayload[k] = item
		end
	end

	sendRobuxTransferFlowEvent(robuxTransferFlowPayload)
end

return logRobuxTransferFlowEvent
