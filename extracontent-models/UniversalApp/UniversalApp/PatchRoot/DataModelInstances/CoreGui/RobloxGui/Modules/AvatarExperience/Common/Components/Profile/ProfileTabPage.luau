local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local ProfilePlatformNavigator = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfilePlatformNavigator)
local ProfileTabPageContainer = require(Modules.AvatarExperience.Common.Components.Profile.ProfileTabPageContainer)
local v7 = React.PureComponent:extend("ProfileTabPage")

function v7.render(p1) -- line: 20
	-- upvalues: React (copy), ProfileTabPageContainer (copy)
	return React.createElement(ProfileTabPageContainer, p1.props)
end

v7.router = ProfilePlatformNavigator.router

return v7
