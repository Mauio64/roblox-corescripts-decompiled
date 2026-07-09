local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)

game:DefineFastFlag("LuaAppMobileMoreTilesPerRowIXP", false)

return {
	mobileShowMoreTilesPerRowIXPEnabled = function() -- line: 7
		return game:GetFastFlag("LuaAppMobileMoreTilesPerRowIXP")
	end,
	shouldHideGameStats = function(p1, p2) -- line: 14
		-- upvalues: AppPage (copy)
		if p1 and ((p1 == AppPage.Home or p1 == AppPage.Games or p1 == AppPage.GamesList) and p2) then
			return true
		end

		return false
	end
}
