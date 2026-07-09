local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local CatalogItemGroupSortView = require(script.Parent.CatalogItemGroupSortView)
local useCatalogItemGroupSortViewModel = require(script.Parent.useCatalogItemGroupSortViewModel)

local function CatalogItemGroupSortContainer(p1, p2) -- line: 21
	-- upvalues: useCatalogItemGroupSortViewModel (copy), React (copy), CatalogItemGroupSortView (copy)
	local v8 = useCatalogItemGroupSortViewModel(p1)
	local v9 = table.clone(v8)

	v9.ref = p2

	return React.createElement(CatalogItemGroupSortView, v9)
end

return React.forwardRef(CatalogItemGroupSortContainer)
