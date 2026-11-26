local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local CatalogItemGroupSortView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemGroupSort/CatalogItemGroupSortView")
local useCatalogItemGroupSortViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemGroupSort/useCatalogItemGroupSortViewModel")

local function CatalogItemGroupSortContainer(p2, ref)
	local v5 = useCatalogItemGroupSortViewModel(p2)
	local clone = table.clone(v5)
	clone.ref = ref
	return React.createElement(CatalogItemGroupSortView, clone)
end

return React.forwardRef(CatalogItemGroupSortContainer)
