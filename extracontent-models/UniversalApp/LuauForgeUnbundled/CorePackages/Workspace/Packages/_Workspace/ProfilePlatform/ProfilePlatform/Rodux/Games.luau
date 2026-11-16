local module = require("@luauforge/bundled/eUd")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants").RODUX_KEY

return (module.RoduxGames.config({
	keyPath = RODUX_KEY .. ".Games"
}))
