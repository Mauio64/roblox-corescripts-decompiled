local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAvatarSwitcherPageProps = require(Modules.AvatarExperience.AvatarSwitcher.useAvatarSwitcherPageProps)
local AvatarSwitcherPage = require(Modules.AvatarExperience.AvatarSwitcher.AvatarSwitcherPage)

local function AvatarSwitcherPageContainer() -- line: 14
	-- upvalues: useAvatarSwitcherPageProps (copy), React (copy), AvatarSwitcherPage (copy)
	local v7 = useAvatarSwitcherPageProps()

	return React.createElement(AvatarSwitcherPage, v7)
end

return (require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(AvatarSwitcherPageContainer))
