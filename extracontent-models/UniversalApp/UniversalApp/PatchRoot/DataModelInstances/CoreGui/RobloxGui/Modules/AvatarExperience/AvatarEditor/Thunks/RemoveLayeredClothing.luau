local Modules = game:GetService("CoreGui").RobloxGui.Modules
local hasLayeredHair = require(Modules.AvatarExperience.LayeredClothingSort.Selectors.hasLayeredHair)
local RemoveLayeredClothing = require(Modules.AvatarExperience.AvatarEditor.Actions.RemoveLayeredClothing)

return function() -- line: 12
	-- upvalues: hasLayeredHair (copy), RemoveLayeredClothing (copy)
	return function(p1) -- line: 13
		-- upvalues: hasLayeredHair (copy), RemoveLayeredClothing (copy)
		local v5 = hasLayeredHair(p1:getState())

		p1:dispatch(RemoveLayeredClothing(v5))
	end
end
