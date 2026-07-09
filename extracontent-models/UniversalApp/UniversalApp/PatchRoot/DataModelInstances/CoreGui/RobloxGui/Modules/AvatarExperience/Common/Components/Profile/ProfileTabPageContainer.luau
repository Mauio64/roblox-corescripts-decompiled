local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local ProfileTabPageView = require(Modules.AvatarExperience.Common.Components.Profile.ProfileTabPageView)
local useProfileTabPageViewModel = require(Modules.AvatarExperience.Common.Components.Profile.useProfileTabPageViewModel)

local function ProfileTabPageContainer(p1) -- line: 12
	-- upvalues: useProfileTabPageViewModel (copy), React (copy), ProfileTabPageView (copy)
	local v9 = useProfileTabPageViewModel(p1)

	return React.createElement(ProfileTabPageView, v9)
end

return ProfileTabPageContainer
