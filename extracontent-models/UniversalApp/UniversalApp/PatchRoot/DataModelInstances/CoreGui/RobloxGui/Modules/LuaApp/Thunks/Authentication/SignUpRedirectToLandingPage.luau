local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local ClearSignUpInfo = require(Modules.LuaApp.Actions.Authentication.ClearSignUpInfo)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)

return function(_) -- line: 8
	-- upvalues: ClearSignUpInfo (copy), ResetNavigationHistory (copy), AppPage (copy)
	return function(p2) -- line: 9
		-- upvalues: ClearSignUpInfo (copy), ResetNavigationHistory (copy), AppPage (copy)
		p2:dispatch(ClearSignUpInfo())
		p2:dispatch(ResetNavigationHistory({{
			name = AppPage.Landing
		}}))
	end
end
