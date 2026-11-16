local GetFFlagLuaEnableShowUpsellMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaEnableShowUpsellMethod")
local GetFFlagLuaAppPushSystemUpsellDevOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppPushSystemUpsellDevOverride")

game:DefineFastFlag("LuaAppEnablePushUpsellOnFirstTime", false)
return function()
	return GetFFlagLuaEnableShowUpsellMethod() and game:GetFastFlag("LuaAppEnablePushUpsellOnFirstTime") or GetFFlagLuaAppPushSystemUpsellDevOverride()
end
