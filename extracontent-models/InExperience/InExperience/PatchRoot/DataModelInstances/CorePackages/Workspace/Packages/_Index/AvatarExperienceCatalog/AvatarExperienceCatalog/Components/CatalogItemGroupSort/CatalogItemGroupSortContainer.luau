local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)

local CatalogItemGroupSortView = require(script.Parent.CatalogItemGroupSortView)
local useCatalogItemGroupSortViewModel = require(script.Parent.useCatalogItemGroupSortViewModel)

local function CatalogItemGroupSortContainer(p, ref)
	local v = useCatalogItemGroupSortViewModel(p)
	local clone = table.clone(v)
	clone.ref = ref
	return React.createElement(CatalogItemGroupSortView, clone)
end

return React.forwardRef(CatalogItemGroupSortContainer)
