local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local AXCatalogStoreContext = require(AvatarExperienceCatalog.Context.AXCatalogStoreContext)
local Stores = require(AvatarExperienceCatalog.Stores)

local function useAXCatalogStoreContext() -- line: 10
	-- upvalues: React (copy), AXCatalogStoreContext (copy), Stores (copy)
	local v7 = React.useContext(AXCatalogStoreContext)

	if not v7 then
		warn("useAXCatalogStoreContext must be used within an AXCatalogStoreContext provider")

		return Stores()
	end

	return v7
end

return useAXCatalogStoreContext
