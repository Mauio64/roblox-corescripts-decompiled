local FFlagLuaAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppIaHomeSubTab")

return game:DefineFastFlag("SubTabHideChartsForNonArgo", false) and not FFlagLuaAppIaHomeSubTab
