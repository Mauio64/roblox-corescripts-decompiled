local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local MultiPageSignupContainer = require(CorePackages.Workspace.Packages.MultiPageSignup).Components.MultiPageSignupContainer

return function() -- line: 14
	-- upvalues: React (copy), MultiPageSignupContainer (copy), LaunchApp (copy), ResetAppState (copy), Logout (copy)
	return React.createElement(MultiPageSignupContainer, {
		monoDeps = {
			LaunchApp = LaunchApp,
			ResetAppState = ResetAppState,
			Logout = Logout
		}
	})
end
