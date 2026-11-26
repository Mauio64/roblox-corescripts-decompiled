local InventorySearchConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/InventorySearchConstants")

local function getInventorySearchKey(p2)
	return InventorySearchConstants.KeyPrefix .. p2
end

return getInventorySearchKey
