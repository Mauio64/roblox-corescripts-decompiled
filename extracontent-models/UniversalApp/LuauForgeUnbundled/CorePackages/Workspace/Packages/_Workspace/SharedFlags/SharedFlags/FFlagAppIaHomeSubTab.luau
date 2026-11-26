local FFlagEnableArgus = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableArgus")
local FFlagArgoEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagArgoEnableMoments")
local FFlagEnableSubTabOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableSubTabOverride")
local FFlagLuaAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppIaHomeSubTab")
local defineFastFlag = game:DefineFastFlag("SubTabAddMomentsFlagGating", false)

return FFlagLuaAppIaHomeSubTab or FFlagEnableSubTabOverride or defineFastFlag and FFlagEnableArgus and FFlagArgoEnableMoments
