local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local LoggingProtocol = require(CurrencyTransfersParent.LoggingProtocol)

require(CurrencyTransfers.Stores.createTransferStore)

local function logCurrencyTransferCounter(p1, p2, t1: {[any]: any}?) -- line: 9
	-- upvalues: LoggingProtocol (copy)
	local v8 = p1.getDirection(false)
	local v9 = p1.getTransferOrigination(false)
	local t2 = {
		direction = not v8 and "unknown" or tostring(v8),
		transferOrigination = not v9 and "unknown" or tostring(v9)
	}

	if t1 then
		for v11, v12 in t1 do
			t2[v11] = v12
		end
	end

	LoggingProtocol.default:logRobloxTelemetryCounter(p2, 1, t2)
end

return logCurrencyTransferCounter
