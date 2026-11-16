local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local function useOpenQuickMenuCallback(onOverlayClosed)
	local v5 = useNavigation()
	return (React.useCallback(function()
		if v5 then
			v5.navigate(avatarScreen.AvatarExperienceQuickMenu, {
				onOverlayClosed = onOverlayClosed
			})
		end
	end, { onOverlayClosed, v5 }))
end

return useOpenQuickMenuCallback
