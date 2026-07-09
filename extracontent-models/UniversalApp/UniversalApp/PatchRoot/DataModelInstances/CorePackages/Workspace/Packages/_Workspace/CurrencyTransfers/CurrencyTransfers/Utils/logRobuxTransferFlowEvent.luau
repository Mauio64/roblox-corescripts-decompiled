local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")

require(CurrencyTransfers.Stores.createTransferStore)

local buildRobuxTransferFlowPayload = require(CurrencyTransfers.Utils.buildRobuxTransferFlowPayload)
local sendRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.sendRobuxTransferFlowEvent)

local function logRobuxTransferFlowEvent(p1, s1: string, t1: {[any]: any}?) -- line: 12
	-- upvalues: buildRobuxTransferFlowPayload (copy), sendRobuxTransferFlowEvent (copy)
	local v8 = buildRobuxTransferFlowPayload(p1, s1)

	if t1 then
		for k, v in pairs(t1) do
			v8[k] = v
		end
	end

	sendRobuxTransferFlowEvent(v8)
end

return logRobuxTransferFlowEvent
