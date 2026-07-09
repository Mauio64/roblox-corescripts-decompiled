local GetFFlagLuaEnableShowUpsellMethod = require(script.Parent.GetFFlagLuaEnableShowUpsellMethod)
local GetFFlagLuaAppPushSystemUpsellDevOverride = require(script.Parent.GetFFlagLuaAppPushSystemUpsellDevOverride)

game:DefineFastFlag("EnablePushNotificationsUpsellModal6", false)

return function() -- line: 5
	-- upvalues: GetFFlagLuaEnableShowUpsellMethod (copy), GetFFlagLuaAppPushSystemUpsellDevOverride (copy)
	return GetFFlagLuaEnableShowUpsellMethod() and game:GetFastFlag("EnablePushNotificationsUpsellModal6") or GetFFlagLuaAppPushSystemUpsellDevOverride()
end
