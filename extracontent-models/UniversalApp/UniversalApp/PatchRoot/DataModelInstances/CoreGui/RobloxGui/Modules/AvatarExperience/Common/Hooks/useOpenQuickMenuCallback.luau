local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

local function useOpenQuickMenuCallback(p1: ((...any) -> ...any)?) -- line: 7
	-- upvalues: useNavigation (copy), React (copy), AvatarScreen (copy)
	local v7 = useNavigation()

	return (React.useCallback(function() -- line: 9
		-- upvalues: v7 (copy), AvatarScreen (copy), p1 (copy)
		if v7 then
			v7.navigate(AvatarScreen.AvatarExperienceQuickMenu, {
				onOverlayClosed = p1
			})
		end
	end, {
		p1,
		v7
	}))
end

return useOpenQuickMenuCallback
