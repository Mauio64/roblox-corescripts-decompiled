local RunService = game:GetService("RunService")

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/AppCommonLib").isTenFootInterface

game:DefineFastFlag("DebugLuaAppAlwaysUseGamepad", false)

game:DefineFastInt("DebugLuaAppForceGamepad", 0)

return function()
	return game:GetFastFlag("DebugLuaAppAlwaysUseGamepad")
		and RunService:IsStudio()
		and isTenFootInterface()
		or game:GetFastInt("DebugLuaAppForceGamepad") > 0
end
