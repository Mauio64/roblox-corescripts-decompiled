local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)

return function(p1, p2) -- line: 13
	-- upvalues: FullView (copy), SetFullView (copy)
	return function(p3) -- line: 14
		-- upvalues: p2 (copy), FullView (copy), SetFullView (copy), p1 (copy)
		if p3:getState().AvatarExperience.Common.FullView[p2] == FullView.SceneFullView then
			p3:dispatch(SetFullView(p1, p2, FullView.None))
		end
	end
end
