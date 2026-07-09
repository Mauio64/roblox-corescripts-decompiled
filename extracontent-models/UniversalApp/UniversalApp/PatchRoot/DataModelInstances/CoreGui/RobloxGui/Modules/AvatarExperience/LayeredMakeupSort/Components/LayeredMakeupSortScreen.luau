local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local LayeredMakeupSortPage = require(Modules.AvatarExperience.LayeredMakeupSort.Components.LayeredMakeupSortPage)
local useLayeredMakeupSortPageViewModel = require(Modules.AvatarExperience.LayeredMakeupSort.Hooks.useLayeredMakeupSortPageViewModel)

local function LayeredMakeupSortScreen(p1) -- line: 13
	-- upvalues: useLayeredMakeupSortPageViewModel (copy), React (copy), LayeredMakeupSortPage (ref)
	local v9 = useLayeredMakeupSortPageViewModel(p1)

	return React.createElement(LayeredMakeupSortPage, v9)
end

LayeredMakeupSortPage = withStackVisibilityWrapper(LayeredMakeupSortPage)

return LayeredMakeupSortScreen
