require("@luauforge/bundled/dMd")

local module = require("@luauforge/bundled/dOg")
local module2 = require("@luauforge/bundled/gho")

require("@luauforge/bundled/dHK")
require("@luauforge/bundled/dMc")

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
