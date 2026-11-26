local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Rodux")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createAXShoppingCartStore")

local fFlagAXMISSaveWearFix = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXMISSaveWearFix

return Rodux.makeActionCreator("PurchaseItemsSuccess", function(data)
	local v5 = {
		equippableAssets = data.equippableAssets,
		items = data.items,
		replaceAllEquippedAssets = data.replaceAllEquippedAssets,
		shouldClearEquippedMakeup = data.shouldClearEquippedMakeup,
		bodyColor3s = data.bodyColor3s,
		bodyScales = data.bodyScales,
		bodyPartColorRangeIds = data.bodyPartColorRangeIds,
		makeupAssetsOnHumanoid = 0
	}
	local v6 = if fFlagAXMISSaveWearFix then data.makeupAssetsOnHumanoid else nil
	v5.makeupAssetsOnHumanoid = v6
	return v5
end)
