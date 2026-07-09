local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local AppPage = require(Modules.LuaApp.AppPage)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)

return function(p1, p2) -- line: 8
	-- upvalues: ResetNavigationHistory (copy), AppPage (copy), SetCentralOverlay (copy), OverlayType (copy)
	p1:dispatch(ResetNavigationHistory({{
		name = AppPage.Landing
	}}))
	p1:dispatch(SetCentralOverlay(OverlayType.AccountAuthenticationFailureOverlay, {
		onActivated = p2
	}, {
		DisableBackButtonClose = true
	}))
end
