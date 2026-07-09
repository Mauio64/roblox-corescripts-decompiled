local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local LoginV2Container = require(CorePackages.Workspace.Packages.LoginV2.Components).LoginV2Container

return function() -- line: 13
	-- upvalues: React (copy), LoginV2Container (copy), LaunchApp (copy), ResetAppState (copy), Logout (copy)
	return React.createElement(LoginV2Container, {
		monoDeps = {
			LaunchApp = LaunchApp,
			ResetAppState = ResetAppState,
			Logout = Logout
		}
	})
end
