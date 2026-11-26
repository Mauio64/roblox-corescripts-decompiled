local createFaeFeatureAccessStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetFaeFeatureAccessStore/createFaeFeatureAccessStore")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetFaeFeatureAccessStore/useFaeFeatureAccess")

local faeFeatureAccessStore = createFaeFeatureAccessStore()

return {
	getFaeFeatureAccessStore = function()
		return faeFeatureAccessStore
	end,
	useFaeFeatureAccess = function()
		return module2(faeFeatureAccessStore)
	end
}
