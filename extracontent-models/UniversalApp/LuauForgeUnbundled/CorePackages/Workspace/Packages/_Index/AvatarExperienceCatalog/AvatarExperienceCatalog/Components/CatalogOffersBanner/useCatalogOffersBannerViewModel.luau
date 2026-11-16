local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local useNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Hooks.useNetworking
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
local marketplaceOffersBannerDisplay = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/marketplaceOffersBannerDisplay")
local useAXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/useAXCatalogStoreContext")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createCatalogOffersBannerStore")
local catalogOffersBannerImpressionsStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/catalogOffersBannerImpressionsStore")
local useCatalogOffersBannerDismissHydration = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useCatalogOffersBannerDismissHydration")
local useCatalogOffersBannerOffersFetch = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useCatalogOffersBannerOffersFetch")
local catalogOffersBannerAppStorage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/catalogOffersBannerAppStorage")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/CatalogOffersBannerView")
local CatalogOffersBannerOfferModals = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/CatalogOffersBannerOfferModals")

local getMarketplaceOffersBannerOfferDisplayId = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId
local getMarketplaceOffersBannerOfferDisplayTitle = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle

local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXCatalogOffersAutoOpenFTUXSheet = AvatarExperienceFlags.FFlagAXCatalogOffersAutoOpenFTUXSheet
local fFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge

local function blendShiftFillForOpaqueGuiObject(shift_200, color3)
	local v5 = 1 - math.clamp(shift_200.Transparency, 0, 1)
	return Color3.new(
		shift_200.Color3.R * v5 + color3.R * (1 - v5),
		shift_200.Color3.G * v5 + color3.G * (1 - v5),
		shift_200.Color3.B * v5 + color3.B * (1 - v5)
	)
end

local function useCatalogOffersBannerViewModel(props)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore

	local v5 = useNetworking()
	local v6 = useTokens()

	local state, setState = React.useState(nil)

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)

	local v7 = useLocalization({ okModalButton = "CommonUI.Controls.Action.OK" })

	local v8 = React.useCallback(function()
		setState4(false)
		setState3(false)
		setState2(nil)
	end, {})

	local v9 = React.useCallback(function()
		if state and state.modal then
			catalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(getMarketplaceOffersBannerOfferDisplayId(state))
			setState2(state.modal)
			setState3(true)
		end
	end, { state })

	local v10 = React.useCallback(function()
		setState4(true)
	end, {})

	local v11 = React.useCallback(function()
		setState4(false)
	end, {})

	local v12 = useSignalState(catalogOffersBannerStore.getPayload)
	local v13 = useSignalState(catalogOffersBannerStore.getDismissed)

	React.useLayoutEffect(function()
		local v14 = if v12 ~= nil then catalogOffersBannerAppStorage.resolveVisibleOffer(v12) else nil
		setState(v14)
	end, { v12 })

	local v14 = if state then getMarketplaceOffersBannerOfferDisplayId(state) else nil
	React.useEffect(function()
		if state == nil or state.modal == nil or state2 ~= nil then
			return
		end

		local marketplaceOffersBannerOfferDisplayId = getMarketplaceOffersBannerOfferDisplayId(state)

		if
			fFlagAXCatalogOffersAutoOpenFTUXSheet
			and catalogOffersBannerAppStorage.shouldAutoOpenOfferSheetForCurrentOffer(marketplaceOffersBannerOfferDisplayId)
		then
			catalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(marketplaceOffersBannerOfferDisplayId)
			setState2(state.modal)
			setState3(true)
		end
	end, { state2, state, v14 })

	useCatalogOffersBannerDismissHydration(catalogOffersBannerStore, v12)

	useCatalogOffersBannerOffersFetch(catalogOffersBannerStore, v5)

	local v15 = if state ~= nil then getMarketplaceOffersBannerOfferDisplayTitle(state) else nil

	React.useEffect(function()
		local onBannerVisibleChanged = props.onBannerVisibleChanged

		if onBannerVisibleChanged then
			onBannerVisibleChanged(v15 ~= nil and not v13)
		end
	end, { v13, v15, props.onBannerVisibleChanged })

	React.useEffect(function()
		if not v13 and state and v15 and state.offerId and not catalogOffersBannerImpressionsStore.hasSeenOfferId(state.offerId) then
			catalogOffersBannerImpressionsStore.addOfferId(state.offerId)
			sendUnifiedEventLog({
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
				surface = unifiedLoggingSurface.CATALOG,
				elementName = unifiedLoggingElementNameEnums.CATALOG_OFFERS_BANNER,
				elementMetadata = HttpService:JSONEncode({ offerId = state.offerId })
			})
		end
	end, { v13, state, v15 })

	if v13 or v12 == nil or state == nil or v15 == nil then
		return { status = "hidden" }
	end

	local v16 = state.modal ~= nil
	local v17

	if state2 then
		v17 = React.createElement(CatalogOffersBannerOfferModals, {
			modal = state2,
			offersModalOpen = state3,
			termsModalOpen = state4,
			okButtonText = v7.okModalButton,
			onCloseOffersModal = v8,
			onOpenTermsModal = v10,
			onCloseTermsModal = v11
		})
	end

	local function fn()
		catalogOffersBannerAppStorage.writeDismissedForCurrentOffer(getMarketplaceOffersBannerOfferDisplayId(state))
		local visibleOffer = catalogOffersBannerAppStorage.resolveVisibleOffer(v12)
		setState(visibleOffer)

		if visibleOffer == nil then
			catalogOffersBannerStore.setDismissed(true)
		end
	end

	local v18 = fFlagAXUpdateOffersEndsUIWithBadge
		and {
			Color3 = blendShiftFillForOpaqueGuiObject(
				v6.Color.Shift.Shift_200,
				v6.Color.Surface.Surface_0.Color3
			),
			Transparency = 0
		}
		or nil

	local v20 = {
		rootTags = fFlagAXUpdateOffersEndsUIWithBadge and "col auto-y size-full-0" or "col auto-y size-full-0 bg-shift-200",
		backgroundStyle = nil,
		Size = 0,
		Position = 0,
		iconName = 0,
		expirationTimeInUTC = 0,
		iconEmphasisStyle = 0,
		titleContentEmphasisStyle = 0,
		titleText = 0,
		onCloseActivated = 0,
		offerModalTapAreaEnabled = 0,
		onOfferBannerActivated = 0
	}

	if not fFlagAXUpdateOffersEndsUIWithBadge then
		v18 = nil
	end

	v20.backgroundStyle = v18
	v20.Size = props.Size
	v20.Position = props.Position
	v20.iconName = state.icon
	local v21 = if fFlagAXUpdateOffersEndsUIWithBadge then state.expirationTimeInUTC else nil
	v20.expirationTimeInUTC = v21
	v20.iconEmphasisStyle = v6.Color.System.Emphasis
	v20.titleContentEmphasisStyle = v6.Color.Content.Emphasis
	v20.titleText = v15
	v20.onCloseActivated = fn
	v20.offerModalTapAreaEnabled = v16

	if not v16 then
		v9 = nil
	end

	v20.onOfferBannerActivated = v9
	return { status = "visible", viewProps = v20, modals = v17 }
end

return useCatalogOffersBannerViewModel
