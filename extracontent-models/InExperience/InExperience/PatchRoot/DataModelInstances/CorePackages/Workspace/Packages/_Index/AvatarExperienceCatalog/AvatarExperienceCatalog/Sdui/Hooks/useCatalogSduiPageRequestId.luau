local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local CatalogSduiPageContext = require(AvatarExperienceCatalog.Sdui.CatalogSduiPageContext)
local GetCatalogPageRequestIdStore = require(AvatarExperienceCatalog.Stores.GetCatalogPageRequestIdStore)

local function useCatalogSduiPageRequestId()
	local v = React.useContext(CatalogSduiPageContext)
	local identifier

	if v then
		identifier = v.identifier
	else
		identifier = nil
	end

	local catalogPageRequestIdStore = GetCatalogPageRequestIdStore(false)
	local v2 = useSignalState(catalogPageRequestIdStore.getPageRequestIdMap)[identifier or ""]

	React.useEffect(function()
		if identifier ~= nil then
			catalogPageRequestIdStore.getOrCreatePageRequestId(identifier)
		end
	end, { identifier, catalogPageRequestIdStore })

	return identifier, v2
end

return useCatalogSduiPageRequestId
