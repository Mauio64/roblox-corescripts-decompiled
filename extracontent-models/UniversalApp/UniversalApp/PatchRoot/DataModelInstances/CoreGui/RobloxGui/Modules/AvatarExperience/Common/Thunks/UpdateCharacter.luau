local CorePackages = game:GetService("CorePackages")
local SetCurrentCharacter = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetCurrentCharacter

return function(p1) -- line: 5
	-- upvalues: SetCurrentCharacter (copy)
	return function(p2) -- line: 6
		-- upvalues: SetCurrentCharacter (copy), p1 (copy)
		p2:dispatch(SetCurrentCharacter(p1))
	end
end
