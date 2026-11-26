local FFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaScrollAway")

local defineFastFlag = game:DefineFastFlag("AppIaScopedScrollAway", false)

return FFlagAppIaScrollAway and defineFastFlag
