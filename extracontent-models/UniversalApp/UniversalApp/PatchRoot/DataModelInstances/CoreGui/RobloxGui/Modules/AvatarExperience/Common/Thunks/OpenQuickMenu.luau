local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView

return function(p1, p2) -- line: 14
	-- upvalues: FullView (copy), AvatarScreen (copy)
	return function(p3) -- line: 15
		-- upvalues: FullView (copy), p2 (copy), AvatarScreen (copy), p1 (copy)
		for _, v8 in p3:getState().AvatarExperience.Common.FullView do
			if v8 == FullView.SceneFullView then
				return
			end
		end

		p2.navigate(AvatarScreen.AvatarExperienceQuickMenu, {
			onOverlayClosed = p1
		})
	end
end
