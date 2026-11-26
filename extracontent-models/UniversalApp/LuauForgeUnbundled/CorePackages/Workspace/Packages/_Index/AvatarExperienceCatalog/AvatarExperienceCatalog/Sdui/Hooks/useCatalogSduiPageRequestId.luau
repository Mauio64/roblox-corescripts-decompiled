local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState

local CatalogSduiPageContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiPageContext")
local GetCatalogPageRequestIdStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetCatalogPageRequestIdStore")

local function useCatalogSduiPageRequestId()
	local v5 = React.useContext(CatalogSduiPageContext)
	local identifier = if v5 then v5.identifier else nil
	local v6 = GetCatalogPageRequestIdStore(false)
	local v7 = useSignalState(v6.getPageRequestIdMap)[identifier or ""]

	React.useEffect(function()
		if identifier ~= nil then
			v6.getOrCreatePageRequestId(identifier)
		end
	end, { identifier, v6 })

	return identifier, v7
end

return useCatalogSduiPageRequestId
