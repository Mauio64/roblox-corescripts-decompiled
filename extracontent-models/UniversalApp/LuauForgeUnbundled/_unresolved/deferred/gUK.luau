local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

return function(onOverlayClosed, p2)
	return function(object)
		for k, v5 in object:getState().AvatarExperience.Common.FullView do
			if v5 == fullView.SceneFullView then
				return
			end
		end

		p2.navigate(avatarScreen.AvatarExperienceQuickMenu, {
			onOverlayClosed = onOverlayClosed
		})
	end
end
