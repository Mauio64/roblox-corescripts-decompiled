local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LaunchApp = require(Modules.LuaApp.Thunks.Authentication.LaunchApp)
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AccountRecoveryContainer = require(CorePackages.Workspace.Packages.AccountRecovery).Components.AccountRecoveryContainer

return function() -- line: 12
	-- upvalues: React (copy), AccountRecoveryContainer (copy), LaunchApp (copy)
	return React.createElement(AccountRecoveryContainer, {
		monoDeps = {
			LaunchApp = LaunchApp
		}
	})
end
