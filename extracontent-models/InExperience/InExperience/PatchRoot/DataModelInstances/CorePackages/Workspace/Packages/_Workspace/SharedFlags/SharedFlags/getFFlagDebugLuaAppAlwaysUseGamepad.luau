local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("SharedFlags").Parent
local AppCommonLib = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface

game:DefineFastFlag("DebugLuaAppAlwaysUseGamepad", false)

game:DefineFastInt("DebugLuaAppForceGamepad", 0)

return function()
	return game:GetFastFlag("DebugLuaAppAlwaysUseGamepad") and RunService:IsStudio() and isTenFootInterface()
		or game:GetFastInt("DebugLuaAppForceGamepad") > 0
end
