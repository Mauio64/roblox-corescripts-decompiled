local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local CatalogPageMonolithDependenciesContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/CatalogPageMonolithDependenciesContext")

local function useCatalogPageMonolithDependencies()
	local v5 = React.useContext(CatalogPageMonolithDependenciesContext)
	assert(
		v5,
		"useCatalogPageMonolithDependencies must be used within a CatalogPageMonolithDependenciesContext.Provider"
	)

	return v5
end

return useCatalogPageMonolithDependencies
