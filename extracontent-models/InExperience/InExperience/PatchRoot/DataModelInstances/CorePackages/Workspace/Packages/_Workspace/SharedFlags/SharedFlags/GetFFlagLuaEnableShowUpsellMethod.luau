local GetFFlagLuaAppEnableAndroidPushUpsell = require(script.Parent.GetFFlagLuaAppEnableAndroidPushUpsell)

game:DefineFastFlag("LuaEnableShowUpsellMethod2", false)

return function()
	if GetFFlagLuaAppEnableAndroidPushUpsell() then
		return game:GetFastFlag("LuaEnableShowUpsellMethod2")
	end

	return game:GetFastFlag("LuaEnableShowUpsellMethod2")
		and game:GetEngineFeature("PermissionsProtocolShouldShowUpsellIOSEnabled")
end
