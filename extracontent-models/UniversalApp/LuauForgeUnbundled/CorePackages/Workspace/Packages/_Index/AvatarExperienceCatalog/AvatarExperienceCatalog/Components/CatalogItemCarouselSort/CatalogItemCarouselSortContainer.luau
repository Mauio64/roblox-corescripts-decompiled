local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local CatalogItemCarouselSortView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemCarouselSort/CatalogItemCarouselSortView")
local useCatalogItemCarouselSortViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemCarouselSort/useCatalogItemCarouselSortViewModel")

local function CatalogItemCarouselSortContainer(p2, p3)
	local v5 = useCatalogItemCarouselSortViewModel(p2, p3)
	return React.createElement(CatalogItemCarouselSortView, v5)
end

return React.forwardRef(CatalogItemCarouselSortContainer)
