local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)

local CatalogItemCarouselSortView = require(script.Parent.CatalogItemCarouselSortView)
local useCatalogItemCarouselSortViewModel = require(script.Parent.useCatalogItemCarouselSortViewModel)

local function CatalogItemCarouselSortContainer(p, p2)
	local v = useCatalogItemCarouselSortViewModel(p, p2)
	return React.createElement(CatalogItemCarouselSortView, v)
end

return React.forwardRef(CatalogItemCarouselSortContainer)
