local set = {}
local CatalogOffersBannerImpressionsStore = {}

function CatalogOffersBannerImpressionsStore.hasSeenOfferId(p: string): boolean
	return set[p] == true
end

function CatalogOffersBannerImpressionsStore.addOfferId(p: string)
	set[p] = true
end

function CatalogOffersBannerImpressionsStore.clearOfferIds()
	set = {}
end

return CatalogOffersBannerImpressionsStore
