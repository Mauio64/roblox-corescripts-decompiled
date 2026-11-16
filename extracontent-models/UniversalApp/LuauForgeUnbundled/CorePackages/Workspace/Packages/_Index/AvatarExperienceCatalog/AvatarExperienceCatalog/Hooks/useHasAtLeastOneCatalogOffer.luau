local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState

local useAXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/useAXCatalogStoreContext")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createCatalogOffersBannerStore")

local signal = Signals.createSignal(nil)

local function useHasAtLeastOneCatalogOffer(): boolean
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore

	local v5 = if catalogOffersBannerStore == nil then signal else catalogOffersBannerStore.getPayload

	local v6 = useSignalState(v5)

	if v6 == nil then
		return false
	end

	local offers = v6.offers
	return offers ~= nil and #offers > 0
end

return useHasAtLeastOneCatalogOffer
