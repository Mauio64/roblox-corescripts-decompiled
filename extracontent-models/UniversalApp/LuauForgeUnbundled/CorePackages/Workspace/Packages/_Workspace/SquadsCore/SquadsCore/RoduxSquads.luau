local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")

local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").RODUX_KEY

return RoduxSquads.config({
	keyPath = RODUX_KEY .. ".Squad"
})
