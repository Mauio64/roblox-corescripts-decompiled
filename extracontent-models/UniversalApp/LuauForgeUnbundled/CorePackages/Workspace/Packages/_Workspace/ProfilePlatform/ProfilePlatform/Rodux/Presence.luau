local module = require("@luauforge/bundled/fbc")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants").RODUX_KEY

return (module.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
