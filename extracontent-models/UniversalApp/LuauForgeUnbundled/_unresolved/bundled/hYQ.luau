local module = require("@luauforge/bundled/dNZ")
local module2 = require("@luauforge/bundled/fvg")
local module3 = require("@luauforge/bundled/fvh")
local module4 = require("@luauforge/bundled/gho")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local fFlagAXRefetchInventoryOnUpdate = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate

return function(p2, p3, p4)
	return function(object)
		local equippedAssets = object:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
		p2 = tostring(p2)
		p3 = tostring(p3)

		if module3.isAssetEquipped(p3, p2, equippedAssets) then
			object:dispatch(module2(p2, p3, p4))
		end

		object:dispatch(module(p2, p3))

		if fFlagAXRefetchInventoryOnUpdate then
			module4({ assetTypeIdString = p2 }, { p3 })
		end
	end
end
