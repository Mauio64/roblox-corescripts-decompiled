local GetFFlagLuaEnableShowUpsellMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaEnableShowUpsellMethod")
local GetFFlagLuaAppPushSystemUpsellDevOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppPushSystemUpsellDevOverride")

game:DefineFastFlag("EnablePushNotificationsUpsellModal6", false)
return function()
	return GetFFlagLuaEnableShowUpsellMethod() and game:GetFastFlag("EnablePushNotificationsUpsellModal6") or GetFFlagLuaAppPushSystemUpsellDevOverride()
end
