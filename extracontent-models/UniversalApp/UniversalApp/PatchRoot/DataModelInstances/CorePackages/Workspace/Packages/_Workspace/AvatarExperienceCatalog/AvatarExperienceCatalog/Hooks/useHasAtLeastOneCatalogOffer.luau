local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Signals = require(AvatarExperienceCatalogParent.Signals)
local useSignalState = require(AvatarExperienceCatalogParent.SignalsReact).useSignalState
local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)

require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local v6 = Signals.createSignal(nil)

local function useHasAtLeastOneCatalogOffer() -- line: 32
	-- upvalues: useAXCatalogStoreContext (copy), v6 (copy), useSignalState (copy)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore
	local v9 = if catalogOffersBannerStore == nil then v6 else catalogOffersBannerStore.getPayload
	local v10 = useSignalState(v9)

	if v10 == nil then
		return false
	end

	local offers = v10.offers

	return offers ~= nil and #offers > 0
end

return useHasAtLeastOneCatalogOffer
