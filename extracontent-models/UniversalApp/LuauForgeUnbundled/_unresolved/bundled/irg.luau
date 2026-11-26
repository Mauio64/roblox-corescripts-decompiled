local actionHandlers = require("@luauforge/bundled/irf").ActionHandlers
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local v5 = actionHandlers.create()

require("@luauforge/bundled/ciE").Handlers.registerLocalUserIdSignalsActionHandlers(v5)

require("@luauforge/bundled/irh").registerDiscoverySignalsActionHandlers(v5)

if SharedFlags.FFlagUseSignalsForStartup then
	require("@luauforge/bundled/irn")(v5)
end

if SharedFlags.FFlagUseSignalsForSiteMessage and not SharedFlags.FFlagSignalsNavP3Final then
	require("@luauforge/bundled/iro")(v5)
end

if require("@luauforge/bundled/irp") then
	require("@luauforge/bundled/irq")(v5)
end

return v5
