local actionHandlers = require("@luauforge/bundled/iix").ActionHandlers
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local v5 = actionHandlers.create()

require("@luauforge/bundled/cgr").Handlers.registerLocalUserIdSignalsActionHandlers(v5)

require("@luauforge/bundled/iiz").registerDiscoverySignalsActionHandlers(v5)

if SharedFlags.FFlagUseSignalsForStartup then
	require("@luauforge/bundled/iiF")(v5)
end

if SharedFlags.FFlagUseSignalsForSiteMessage and not SharedFlags.FFlagSignalsNavP3Final then
	require("@luauforge/bundled/iiG")(v5)
end

if require("@luauforge/bundled/iiH") then
	require("@luauforge/bundled/iiI")(v5)
end

return v5
