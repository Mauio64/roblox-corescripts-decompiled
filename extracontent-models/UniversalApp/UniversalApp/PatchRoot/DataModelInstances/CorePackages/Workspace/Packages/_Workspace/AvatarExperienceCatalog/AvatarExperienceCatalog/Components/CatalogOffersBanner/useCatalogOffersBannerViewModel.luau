local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local SignalsReact = require(AvatarExperienceCatalogParent.SignalsReact)
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local useNetworking = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Hooks.useNetworking
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)

local marketplaceOffersBannerDisplay = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.marketplaceOffersBannerDisplay)
local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)

require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local useCatalogOffersBannerDismissHydration = require(AvatarExperienceCatalog.Hooks.useCatalogOffersBannerDismissHydration)
local useCatalogOffersBannerOffersFetch = require(AvatarExperienceCatalog.Hooks.useCatalogOffersBannerOffersFetch)
local catalogOffersBannerAppStorage = require(AvatarExperienceCatalog.Utils.catalogOffersBannerAppStorage)

require(script.Parent.CatalogOffersBannerView)

local CatalogOffersBannerOfferModals = require(script.Parent.CatalogOffersBannerOfferModals)
local getMarketplaceOffersBannerOfferDisplayId = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId
local getMarketplaceOffersBannerOfferDisplayTitle = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local FFlagAXCatalogOffersAutoOpenFTUXSheet = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogOffersAutoOpenFTUXSheet

local function useCatalogOffersBannerViewModel(t1: {[any]: any}) -- line: 68
	-- upvalues: useAXCatalogStoreContext (copy), useNetworking (copy), useTokens (copy), React (copy), useLocalization (copy), catalogOffersBannerAppStorage (copy), getMarketplaceOffersBannerOfferDisplayId (copy), useSignalState (copy), FFlagAXCatalogOffersAutoOpenFTUXSheet (copy), useCatalogOffersBannerDismissHydration (copy), useCatalogOffersBannerOffersFetch (copy), getMarketplaceOffersBannerOfferDisplayTitle (copy), CatalogOffersBannerOfferModals (copy)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore
	local v22 = useNetworking()
	local v23 = useTokens()
	local v24, v25 = React.useState(nil)
	local v26, v27 = React.useState(nil)
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(false)
	local v32 = useLocalization({
		okModalButton = "CommonUI.Controls.Action.OK"
	})
	local v33 = React.useCallback(function() -- line: 90
		-- upvalues: v31 (copy), v29 (copy), v27 (copy)
		v31(false)
		v29(false)
		v27(nil)
	end, {})
	local v34 = React.useCallback(function() -- line: 96
		-- upvalues: v24 (copy), catalogOffersBannerAppStorage (copy), getMarketplaceOffersBannerOfferDisplayId (copy), v27 (copy), v29 (copy)
		if v24 and v24.modal then
			catalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(getMarketplaceOffersBannerOfferDisplayId(v24))
			v27(v24.modal)
			v29(true)
		end
	end, { v24 })
	local v35 = React.useCallback(function() -- line: 104
		-- upvalues: v31 (copy)
		v31(true)
	end, {})
	local v36 = React.useCallback(function() -- line: 108
		-- upvalues: v31 (copy)
		v31(false)
	end, {})
	local v37 = useSignalState(catalogOffersBannerStore.getPayload)
	local v38 = useSignalState(catalogOffersBannerStore.getDismissed)

	React.useLayoutEffect(function() -- line: 115
		-- upvalues: v37 (copy), catalogOffersBannerAppStorage (copy), v25 (copy)
		local v43 = if v37 ~= nil then catalogOffersBannerAppStorage.resolveVisibleOffer(v37) else nil

		v25(v43)
	end, { v37 })

	local v39 = if not v24 then nil else getMarketplaceOffersBannerOfferDisplayId(v24)

	React.useEffect(function() -- line: 123
		-- upvalues: v24 (copy), v26 (copy), getMarketplaceOffersBannerOfferDisplayId (copy), FFlagAXCatalogOffersAutoOpenFTUXSheet (copy), catalogOffersBannerAppStorage (copy), v27 (copy), v29 (copy)
		if v24 == nil or v24.modal == nil then
			return
		end

		if v26 ~= nil then
			return
		end

		local v44 = getMarketplaceOffersBannerOfferDisplayId(v24)

		if FFlagAXCatalogOffersAutoOpenFTUXSheet and catalogOffersBannerAppStorage.shouldAutoOpenOfferSheetForCurrentOffer(v44) then
			catalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(v44)
			v27(v24.modal)
			v29(true)
		end
	end, {
		v26,
		v24,
		v39
	})
	useCatalogOffersBannerDismissHydration(catalogOffersBannerStore, v37)
	useCatalogOffersBannerOffersFetch(catalogOffersBannerStore, v22)

	local v40 = if v24 == nil then nil else getMarketplaceOffersBannerOfferDisplayTitle(v24)

	React.useEffect(function() -- line: 147
		-- upvalues: t1 (copy), v40 (copy), v38 (copy)
		local onBannerVisibleChanged = t1.onBannerVisibleChanged

		if onBannerVisibleChanged then
			onBannerVisibleChanged(v40 ~= nil and not v38)
		end
	end, {
		v38,
		v40,
		t1.onBannerVisibleChanged
	})

	if v38 or (v37 == nil or v24 == nil or v40 == nil) then
		return {
			status = "hidden"
		}
	end

	local v41 = v24.modal ~= nil
	local v42 = if not v26 then nil else React.createElement(CatalogOffersBannerOfferModals, {
		modal = v26,
		offersModalOpen = v28,
		termsModalOpen = v30,
		okButtonText = v32.okModalButton,
		onCloseOffersModal = v33,
		onOpenTermsModal = v35,
		onCloseTermsModal = v36
	})

	return {
		status = "visible",
		viewProps = {
			rootTags = "col auto-y size-full-0 bg-shift-200",
			Size = t1.Size,
			Position = t1.Position,
			iconName = v24.icon,
			iconEmphasisStyle = v23.Color.System.Emphasis,
			titleContentEmphasisStyle = v23.Color.Content.Emphasis,
			titleText = v40,
			onCloseActivated = function() -- line: 172
				-- upvalues: catalogOffersBannerAppStorage (copy), getMarketplaceOffersBannerOfferDisplayId (copy), v24 (copy), v37 (copy), v25 (copy), catalogOffersBannerStore (copy)
				catalogOffersBannerAppStorage.writeDismissedForCurrentOffer(getMarketplaceOffersBannerOfferDisplayId(v24))

				local v46 = catalogOffersBannerAppStorage.resolveVisibleOffer(v37)

				v25(v46)

				if v46 == nil then
					catalogOffersBannerStore.setDismissed(true)
				end
			end,
			offerModalTapAreaEnabled = v41,
			onOfferBannerActivated = if not v41 then nil else v34
		},
		modals = v42
	}
end

return useCatalogOffersBannerViewModel
