local FFlagEnableArgus = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableArgus")
local FFlagArgoEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagArgoEnableMoments")
local defineFastFlag = game:DefineFastFlag("SubTabAddMomentsFlagGating", false)

return game:DefineFastFlag("LuaAppIaHomeSubTab", false) or defineFastFlag and FFlagEnableArgus and FFlagArgoEnableMoments
