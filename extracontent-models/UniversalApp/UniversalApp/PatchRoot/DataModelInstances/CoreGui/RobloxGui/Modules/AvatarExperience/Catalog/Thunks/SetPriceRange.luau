local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetPriceRange = require(Modules.AvatarExperience.Catalog.Actions.SetPriceRange)

return function(p1, p2, p3) -- line: 5
	-- upvalues: SetPriceRange (copy)
	return function(p4) -- line: 6
		-- upvalues: SetPriceRange (copy), p1 (copy), p2 (copy), p3 (copy)
		p4:dispatch(SetPriceRange(p1, p2))
		p3.applyPriceFilter(p1, p2)
	end
end
