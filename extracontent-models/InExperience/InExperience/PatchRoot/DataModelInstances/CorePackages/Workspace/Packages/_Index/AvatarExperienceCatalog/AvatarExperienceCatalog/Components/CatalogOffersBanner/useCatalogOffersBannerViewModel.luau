local HttpService = game:GetService("HttpService")

local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)
local marketplaceOffersBannerDisplay = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.marketplaceOffersBannerDisplay)
local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)
require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)
local catalogOffersBannerImpressionsStore = require(AvatarExperienceCatalog.Stores.catalogOffersBannerImpressionsStore)
local useCatalogOffersBannerDismissHydration = require(AvatarExperienceCatalog.Hooks.useCatalogOffersBannerDismissHydration)
local useCatalogOffersBannerOffersFetch = require(AvatarExperienceCatalog.Hooks.useCatalogOffersBannerOffersFetch)
local catalogOffersBannerAppStorage = require(AvatarExperienceCatalog.Utils.catalogOffersBannerAppStorage)

require(script.Parent.CatalogOffersBannerView)
local CatalogOffersBannerOfferModals = require(script.Parent.CatalogOffersBannerOfferModals)

local getMarketplaceOffersBannerOfferDisplayId = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId
local getMarketplaceOffersBannerOfferDisplayTitle = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle

local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogOffersAutoOpenFTUXSheet = AvatarExperienceFlags.FFlagAXCatalogOffersAutoOpenFTUXSheet
local FFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge

local function blendShiftFillForOpaqueGuiObject(shift_200, color3: Color3)
	local v = 1 - math.clamp(shift_200.Transparency, 0, 1)
	return Color3.new(
		shift_200.Color3.R * v + color3.R * (1 - v),
		shift_200.Color3.G * v + color3.G * (1 - v),
		shift_200.Color3.B * v + color3.B * (1 - v)
	)
end

local function useCatalogOffersBannerViewModel(props)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore

	local v = useNetworking()
	local v2 = useTokens()

	local state, setState = React.useState(nil)

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)

	local v3 = useLocalization({ okModalButton = "CommonUI.Controls.Action.OK" })

	local onCloseOffersModal = React.useCallback(function()
		setState4(false)
		setState3(false)
		setState2(nil)
	end, {})

	local onOfferBannerActivated = React.useCallback(function()
		if state and state.modal then
			catalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(getMarketplaceOffersBannerOfferDisplayId(state))
			setState2(state.modal)
			setState3(true)
		end
	end, { state })

	local onOpenTermsModal = React.useCallback(function()
		setState4(true)
	end, {})

	local onCloseTermsModal = React.useCallback(function()
		setState4(false)
	end, {})

	local v4 = useSignalState(catalogOffersBannerStore.getPayload)
	local v5 = useSignalState(catalogOffersBannerStore.getDismissed)

	React.useLayoutEffect(function()
		local v6

		if v4 ~= nil then
			v6 = catalogOffersBannerAppStorage.resolveVisibleOffer(v4)
		end

		setState(v6)
	end, { v4 })
	local v6

	if state then
		v6 = getMarketplaceOffersBannerOfferDisplayId(state)
	end

	React.useEffect(function()
		if state == nil or state.modal == nil or state2 ~= nil then
			return
		end

		local marketplaceOffersBannerOfferDisplayId = getMarketplaceOffersBannerOfferDisplayId(state)

		if
			FFlagAXCatalogOffersAutoOpenFTUXSheet
			and catalogOffersBannerAppStorage.shouldAutoOpenOfferSheetForCurrentOffer(marketplaceOffersBannerOfferDisplayId)
		then
			catalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(marketplaceOffersBannerOfferDisplayId)
			setState2(state.modal)
			setState3(true)
		end
	end, { state2, state, v6 })

	useCatalogOffersBannerDismissHydration(catalogOffersBannerStore, v4)

	useCatalogOffersBannerOffersFetch(catalogOffersBannerStore, v)
	local titleText

	if state == nil then
		titleText = nil
	else
		titleText = getMarketplaceOffersBannerOfferDisplayTitle(state)
	end

	React.useEffect(function()
		local onBannerVisibleChanged = props.onBannerVisibleChanged

		if onBannerVisibleChanged then
			onBannerVisibleChanged(titleText ~= nil and not v5)
		end
	end, { v5, titleText, props.onBannerVisibleChanged })

	React.useEffect(function()
		if
			not v5
			and state
			and titleText
			and state.offerId
			and not catalogOffersBannerImpressionsStore.hasSeenOfferId(state.offerId)
		then
			catalogOffersBannerImpressionsStore.addOfferId(state.offerId)
			sendUnifiedEventLog({
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_IMPRESSION,
				surface = UnifiedLoggingSurface.CATALOG,
				elementName = UnifiedLoggingElementNameEnums.CATALOG_OFFERS_BANNER,
				elementMetadata = HttpService:JSONEncode({ offerId = state.offerId })
			})
		end
	end, { v5, state, titleText })

	if v5 or v4 == nil or state == nil or titleText == nil then
		return { status = "hidden" }
	end

	local offerModalTapAreaEnabled = state.modal ~= nil
	local modals

	if state2 then
		modals = React.createElement(CatalogOffersBannerOfferModals, {
			modal = state2,
			offersModalOpen = state3,
			termsModalOpen = state4,
			okButtonText = v3.okModalButton,
			onCloseOffersModal = onCloseOffersModal,
			onOpenTermsModal = onOpenTermsModal,
			onCloseTermsModal = onCloseTermsModal
		})
	end

	local function fn()
		catalogOffersBannerAppStorage.writeDismissedForCurrentOffer(getMarketplaceOffersBannerOfferDisplayId(state))
		local visibleOffer = catalogOffersBannerAppStorage.resolveVisibleOffer(v4)
		setState(visibleOffer)

		if visibleOffer == nil then
			catalogOffersBannerStore.setDismissed(true)
		end
	end

	local backgroundStyle = FFlagAXUpdateOffersEndsUIWithBadge
		and {
			Color3 = blendShiftFillForOpaqueGuiObject(v2.Color.Shift.Shift_200, v2.Color.Surface.Surface_0.Color3),
			Transparency = 0
		}
		or nil

	local viewProps = {
		rootTags = FFlagAXUpdateOffersEndsUIWithBadge and "col auto-y size-full-0" or "col auto-y size-full-0 bg-shift-200",
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

	if not FFlagAXUpdateOffersEndsUIWithBadge then
		backgroundStyle = nil
	end

	viewProps.backgroundStyle = backgroundStyle
	viewProps.Size = props.Size
	viewProps.Position = props.Position
	viewProps.iconName = state.icon
	local expirationTimeInUTC

	if FFlagAXUpdateOffersEndsUIWithBadge then
		expirationTimeInUTC = state.expirationTimeInUTC
	end

	viewProps.expirationTimeInUTC = expirationTimeInUTC
	viewProps.iconEmphasisStyle = v2.Color.System.Emphasis
	viewProps.titleContentEmphasisStyle = v2.Color.Content.Emphasis
	viewProps.titleText = titleText
	viewProps.onCloseActivated = fn
	viewProps.offerModalTapAreaEnabled = offerModalTapAreaEnabled

	if not offerModalTapAreaEnabled then
		onOfferBannerActivated = nil
	end

	viewProps.onOfferBannerActivated = onOfferBannerActivated
	return { status = "visible", viewProps = viewProps, modals = modals }
end

return useCatalogOffersBannerViewModel
