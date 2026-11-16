local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").RODUX_KEY

return (require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserBlockingRodux").config({
	keyPath = RODUX_KEY .. ".UserBlocking"
}))
