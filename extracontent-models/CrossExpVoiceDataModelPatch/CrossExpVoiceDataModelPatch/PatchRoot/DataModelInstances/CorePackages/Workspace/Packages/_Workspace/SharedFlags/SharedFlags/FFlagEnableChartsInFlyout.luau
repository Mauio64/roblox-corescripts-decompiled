local FFlagAppIaHomeSubTab = require(script.Parent.FFlagAppIaHomeSubTab)
local defineFastFlag = game:DefineFastFlag("ChartsInFlyoutAddSubTabDependency", false)

return game:DefineFastFlag("EnableChartsInFlyout", false) and (not defineFastFlag or FFlagAppIaHomeSubTab)
