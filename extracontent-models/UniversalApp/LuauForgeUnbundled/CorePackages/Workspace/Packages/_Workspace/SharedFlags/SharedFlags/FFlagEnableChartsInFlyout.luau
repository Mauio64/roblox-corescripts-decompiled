local FFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagAppIaHomeSubTab")
local defineFastFlag = game:DefineFastFlag("ChartsInFlyoutAddSubTabDependency", false)

return game:DefineFastFlag("EnableChartsInFlyout", false) and (not defineFastFlag or FFlagAppIaHomeSubTab)
