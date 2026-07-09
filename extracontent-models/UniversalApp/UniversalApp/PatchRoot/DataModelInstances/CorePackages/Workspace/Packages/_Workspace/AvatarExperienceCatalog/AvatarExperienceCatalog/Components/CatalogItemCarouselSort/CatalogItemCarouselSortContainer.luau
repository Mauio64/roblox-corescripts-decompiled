local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local CatalogItemCarouselSortView = require(script.Parent.CatalogItemCarouselSortView)
local useCatalogItemCarouselSortViewModel = require(script.Parent.useCatalogItemCarouselSortViewModel)

local function CatalogItemCarouselSortContainer(p1, p2) -- line: 19
	-- upvalues: useCatalogItemCarouselSortViewModel (copy), React (copy), CatalogItemCarouselSortView (copy)
	local v8 = useCatalogItemCarouselSortViewModel(p1, p2)

	return React.createElement(CatalogItemCarouselSortView, v8)
end

return React.forwardRef(CatalogItemCarouselSortContainer)
