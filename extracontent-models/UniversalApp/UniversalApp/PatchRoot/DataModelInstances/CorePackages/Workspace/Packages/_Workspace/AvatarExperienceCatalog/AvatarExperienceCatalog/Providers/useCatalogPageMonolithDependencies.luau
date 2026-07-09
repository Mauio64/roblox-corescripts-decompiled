local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local CatalogPageMonolithDependenciesContext = require(script.Parent.CatalogPageMonolithDependenciesContext)

local function useCatalogPageMonolithDependencies() -- line: 8
	-- upvalues: React (copy), CatalogPageMonolithDependenciesContext (copy)
	local v5 = React.useContext(CatalogPageMonolithDependenciesContext)

	assert(v5, "useCatalogPageMonolithDependencies must be used within a CatalogPageMonolithDependenciesContext.Provider")

	return v5
end

return useCatalogPageMonolithDependencies
