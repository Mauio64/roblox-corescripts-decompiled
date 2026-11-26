local module = require("@luauforge/bundled/dFu")

game:DefineFastFlag("LuaAppMobileMoreTilesPerRowIXP", false)

return {
	mobileShowMoreTilesPerRowIXPEnabled = function()
		return game:GetFastFlag("LuaAppMobileMoreTilesPerRowIXP")
	end,
	shouldHideGameStats = function(p2, p3): boolean
		if p2 and (p2 == module.Home or p2 == module.Games or p2 == module.GamesList) and p3 then
			return true
		end

		return false
	end
}
