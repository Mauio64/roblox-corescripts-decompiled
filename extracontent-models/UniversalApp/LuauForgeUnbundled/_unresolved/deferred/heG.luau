local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local module = require("@luauforge/bundled/gSD")

return function(p2, p3)
	return function(object)
		if object:getState().AvatarExperience.Common.FullView[p3] == fullView.SceneFullView then
			object:dispatch(module(p2, p3, fullView.None))
		end
	end
end
