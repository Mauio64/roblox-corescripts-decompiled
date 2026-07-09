local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local function selectBodyColor3s(p1) -- line: 4
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.values(p1.AvatarExperience.AvatarEditor.Character.BodyColor3s)
end

return selectBodyColor3s
