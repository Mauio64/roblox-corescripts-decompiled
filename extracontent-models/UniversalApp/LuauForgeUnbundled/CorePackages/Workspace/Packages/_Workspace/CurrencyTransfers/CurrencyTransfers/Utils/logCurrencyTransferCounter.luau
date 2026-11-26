local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Stores/createTransferStore")

local function logCurrencyTransferCounter(p2, p3, items)
	local direction = p2.getDirection(false)
	local transferOrigination = p2.getTransferOrigination(false)

	local v5 = {
		direction = not direction and "unknown" or tostring(direction),
		transferOrigination = not transferOrigination and "unknown" or tostring(transferOrigination)
	}

	if items then
		for k, item in items do
			v5[k] = item
		end
	end

	LoggingProtocol.default:logRobloxTelemetryCounter(p3, 1, v5)
end

return logCurrencyTransferCounter
