local module = require("@luauforge/bundled/dRx")
local module2 = require("@luauforge/bundled/fDB")
local module3 = require("@luauforge/bundled/dzP")
require("@luauforge/bundled/dPs")

return function(p2, p3)
	module3.isType(p2, "string", "UpdateOutfit thunk expects outfitId to be a string")
	return function(object)
		local outfitInfo = object:getState().AvatarExperience.AvatarEditor.OutfitInfos[p2]
		local v5 = (outfitInfo and outfitInfo.updateCounter or 0) + 1

		local isEditable = if outfitInfo then outfitInfo.isEditable or nil else nil
		local outfitType = outfitInfo and outfitInfo.outfitType or nil
		object:dispatch(module(p2, isEditable, outfitType))
		object:dispatch(module2(p2, v5, nil, p3))
	end
end
