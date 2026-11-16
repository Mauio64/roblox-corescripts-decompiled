local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)
require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local signal = Signals.createSignal(nil)

local function useHasAtLeastOneCatalogOffer(): boolean
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore
	local v

	if catalogOffersBannerStore == nil then
		v = signal
	else
		v = catalogOffersBannerStore.getPayload
	end

	local v2 = useSignalState(v)

	if v2 == nil then
		return false
	end

	local offers = v2.offers
	return offers ~= nil and #offers > 0
end

return useHasAtLeastOneCatalogOffer
