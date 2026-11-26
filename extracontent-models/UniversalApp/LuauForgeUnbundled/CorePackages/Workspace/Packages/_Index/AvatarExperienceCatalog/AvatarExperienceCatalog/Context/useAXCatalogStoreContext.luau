local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local AXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/AXCatalogStoreContext")

local Stores = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores")

local function useAXCatalogStoreContext()
	local v5 = React.useContext(AXCatalogStoreContext)

	if v5 then
		return v5
	end

	warn("useAXCatalogStoreContext must be used within an AXCatalogStoreContext provider")
	return Stores()
end

return useAXCatalogStoreContext
