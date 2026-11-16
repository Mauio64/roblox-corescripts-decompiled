local GetFFlagLuaEnableShowUpsellMethod = require(script.Parent.GetFFlagLuaEnableShowUpsellMethod)
local GetFFlagLuaAppPushSystemUpsellDevOverride = require(script.Parent.GetFFlagLuaAppPushSystemUpsellDevOverride)

game:DefineFastFlag("LuaAppEnablePushUpsellOnFirstTime", false)
return function()
	return GetFFlagLuaEnableShowUpsellMethod() and game:GetFastFlag("LuaAppEnablePushUpsellOnFirstTime")
		or GetFFlagLuaAppPushSystemUpsellDevOverride()
end
