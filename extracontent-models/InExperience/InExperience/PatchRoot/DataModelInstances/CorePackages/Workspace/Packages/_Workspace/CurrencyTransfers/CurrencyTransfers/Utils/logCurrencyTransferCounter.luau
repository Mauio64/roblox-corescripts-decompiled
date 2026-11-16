local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
require(CurrencyTransfers.Stores.createTransferStore)

local function logCurrencyTransferCounter(p, p2, items)
	local direction = p.getDirection(false)
	local transferOrigination = p.getTransferOrigination(false)

	local v = {
		direction = not direction and "unknown" or tostring(direction),
		transferOrigination = not transferOrigination and "unknown" or tostring(transferOrigination)
	}

	if items then
		for k, item in items do
			v[k] = item
		end
	end

	LoggingProtocol.default:logRobloxTelemetryCounter(p2, 1, v)
end

return logCurrencyTransferCounter
