local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function selectHasAvatarData(p1) -- line: 8
	return p1.AvatarExperience.AvatarEditor.HasAvatarData
end

return selectHasAvatarData
