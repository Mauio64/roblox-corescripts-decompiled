local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Utils = require(Modules.AvatarExperience.Common.Utils)

return function(p1) -- line: 8
	-- upvalues: Utils (copy)
	return Utils.getEquippedToolId(p1) ~= nil
end
