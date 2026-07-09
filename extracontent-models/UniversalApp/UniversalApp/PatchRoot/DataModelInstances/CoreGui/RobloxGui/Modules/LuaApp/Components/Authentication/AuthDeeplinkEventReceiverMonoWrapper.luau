local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local ResetAppState = require(Modules.LuaApp.Thunks.Authentication.ResetAppState)
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AuthDeeplinkEventReceiver = require(CorePackages.Workspace.Packages.AuthCommon).EventReceivers.AuthDeeplinkEventReceiver

return function() -- line: 13
	-- upvalues: React (copy), AuthDeeplinkEventReceiver (copy), LaunchApp (copy), ResetAppState (copy)
	return React.createElement(AuthDeeplinkEventReceiver, {
		monoDeps = {
			LaunchApp = LaunchApp,
			ResetAppState = ResetAppState
		}
	})
end
