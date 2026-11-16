local actionHandlers = require("@luauforge/bundled/iiC").ActionHandlers
local module = require("@luauforge/bundled/iiD")
local setPlayabilityStatus = require("@luauforge/bundled/iiE").PlayabilityStatus.SetPlayabilityStatus

local function registerDiscoverySignalsActionHandlers(p2)
	actionHandlers.register(p2, setPlayabilityStatus.name, function(p3): boolean
		local v5 = {}

		for k, v6 in p3.playabilityStatus do
			v5[tostring(k)] = {
				isPlayable = v6.isPlayable,
				playabilityStatus = v6.playabilityStatus
			}
		end

		module.Game.getPlayabilityStore(false).updatePlayabilities(v5)
		return false
	end)
end

return registerDiscoverySignalsActionHandlers
