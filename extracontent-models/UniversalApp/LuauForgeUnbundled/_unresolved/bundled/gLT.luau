require("@luauforge/bundled/dPt")

local module = require("@luauforge/bundled/dRw")
local module2 = require("@luauforge/bundled/gLU")

require("@luauforge/bundled/dKT")
require("@luauforge/bundled/dPs")

return function(p2)
	return function(object)
		local v5 = tostring(p2)
		local outfitInfo = object:getState().AvatarExperience.AvatarEditor.OutfitInfos[v5]
		local v6 = { v5 }

		if outfitInfo then
			module2(
				{
					inventoryOutfitType = outfitInfo.inventoryType,
					outfitType = outfitInfo.outfitType,
					isEditable = outfitInfo.isEditable
				},
				v6
			)
		else
			module2({ allOutfitLists = true }, v6)
		end

		object:dispatch(module(p2))
	end
end
