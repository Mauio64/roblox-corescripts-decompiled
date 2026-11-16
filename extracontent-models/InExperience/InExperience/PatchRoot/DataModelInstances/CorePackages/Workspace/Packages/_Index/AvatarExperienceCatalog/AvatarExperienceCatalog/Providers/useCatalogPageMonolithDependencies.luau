local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(parent.React)

local CatalogPageMonolithDependenciesContext = require(script.Parent.CatalogPageMonolithDependenciesContext)

local function useCatalogPageMonolithDependencies()
	local v = React.useContext(CatalogPageMonolithDependenciesContext)
	assert(
		v,
		"useCatalogPageMonolithDependencies must be used within a CatalogPageMonolithDependenciesContext.Provider"
	)

	return v
end

return useCatalogPageMonolithDependencies
