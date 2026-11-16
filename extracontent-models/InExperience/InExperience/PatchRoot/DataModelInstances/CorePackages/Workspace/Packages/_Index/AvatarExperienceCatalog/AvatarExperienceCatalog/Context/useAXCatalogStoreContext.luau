local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local AXCatalogStoreContext = require(AvatarExperienceCatalog.Context.AXCatalogStoreContext)

local Stores = require(AvatarExperienceCatalog.Stores)

local function useAXCatalogStoreContext()
	local v = React.useContext(AXCatalogStoreContext)

	if v then
		return v
	end

	warn("useAXCatalogStoreContext must be used within an AXCatalogStoreContext provider")
	return Stores()
end

return useAXCatalogStoreContext
