local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants").RODUX_KEY

return (require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/LuaSocialLibrariesDeps").RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
}))
