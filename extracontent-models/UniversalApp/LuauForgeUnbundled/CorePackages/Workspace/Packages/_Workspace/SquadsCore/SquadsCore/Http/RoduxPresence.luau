local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").RODUX_KEY

return (require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LuaSocialLibrariesDeps").RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
