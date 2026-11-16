local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/LuaSocialLibrariesDeps")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/Constants").RODUX_KEY

return LuaSocialLibrariesDeps.RoduxUsers.config({
	keyPath = RODUX_KEY .. ".Users"
})
