local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants").RODUX_KEY
return require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/LuaSocialLibrariesDeps").RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
})
