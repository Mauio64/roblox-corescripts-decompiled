local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
require(parent.Foundation)
local fetchCatalogPage = require(script.Parent.fetchCatalogPage)
local useComponentBreakpointSize = require(script.Parent.Hooks.useComponentBreakpointSize)
local getCatalogConfigKey = require(script.Parent.Utils.getCatalogConfigKey)
local CatalogSduiPageContext = require(script.Parent.CatalogSduiPageContext)
local GetCatalogPageRequestIdStore = require(AvatarExperienceCatalog.Stores.GetCatalogPageRequestIdStore)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiFeedPublishesBreakpoint = AvatarExperienceFlags.FFlagAXSduiFeedPublishesBreakpoint
local FFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter
local FFlagAXSduiFeedMaintainScrollOnSeeAll = AvatarExperienceFlags.FFlagAXSduiFeedMaintainScrollOnSeeAll
local FFlagAXSduiPageVariantRequestId = AvatarExperienceFlags.FFlagAXSduiPageVariantRequestId
local FFlagAXSduiPublishRequestIdWithResponse = AvatarExperienceFlags.FFlagAXSduiPublishRequestIdWithResponse
local SharedFlags = require(parent.SharedFlags)
local FFlagAXScrollTelemetryIntegration2 = SharedFlags.FFlagAXScrollTelemetryIntegration2

local function CatalogSduiEntryPoint(props, ref)
	local v

	if FFlagAXSduiFeedPublishesBreakpoint or FFlagAXMarketplaceBreakpointMismatchCounter then
		v = props.breakpointOptions
	end

	local screenSize, onAbsoluteSizeChange = useComponentBreakpointSize(nil, v)

	local loadTimer = React.useMemo(function()
		return SduiLoadTimer.createLoadTimer(AvatarScreen.Catalog)
	end, {})

	if props.loadTimer then
		loadTimer = props.loadTimer
	end

	local appPage

	if props.appPage then
		appPage = props.appPage
	else
		appPage = AvatarScreen.Catalog
	end

	local catalogPageRequestIdStore = GetCatalogPageRequestIdStore(false)
	local v2 = useSignalState(catalogPageRequestIdStore.getPageRequestIdMap)[props.identifier]

	local useMemo = React.useMemo
	local function fn()
		local v3 = {
			identifier = props.identifier,
			scrollPerformanceIntervalName = 0,
			onScroll = 0,
			requestImpressionsSignal = 0,
			scrollPositionRef = 0,
			scrollRestoreRef = 0
		}
		local scrollPerformanceIntervalName

		if FFlagAXScrollTelemetryIntegration2 then
			scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
		end

		v3.scrollPerformanceIntervalName = scrollPerformanceIntervalName

		v3.onScroll = props.onScroll
		v3.requestImpressionsSignal = props.requestImpressionsSignal
		local scrollPositionRef

		if FFlagAXSduiFeedMaintainScrollOnSeeAll then
			scrollPositionRef = props.scrollPositionRef
		end

		v3.scrollPositionRef = scrollPositionRef
		local scrollRestoreRef

		if FFlagAXSduiFeedMaintainScrollOnSeeAll then
			scrollRestoreRef = props.scrollRestoreRef
		end

		v3.scrollRestoreRef = scrollRestoreRef
		return v3
	end

	local identifier = props.identifier
	local scrollPerformanceIntervalName

	if FFlagAXScrollTelemetryIntegration2 then
		scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
	end

	local onScroll = props.onScroll
	local requestImpressionsSignal = props.requestImpressionsSignal
	local scrollPositionRef

	if FFlagAXSduiFeedMaintainScrollOnSeeAll then
		scrollPositionRef = props.scrollPositionRef
	end

	local v3

	if FFlagAXSduiFeedMaintainScrollOnSeeAll then
		v3 = props.scrollRestoreRef
	end

	local v4 = useMemo(fn, {
		identifier,
		scrollPerformanceIntervalName,
		onScroll,
		requestImpressionsSignal,
		scrollPositionRef,
		v3
	})

	React.useEffect(function()
		if FFlagAXSduiPublishRequestIdWithResponse then
			catalogPageRequestIdStore.activatePageVariant(props.identifier, screenSize)
		end

		local requestId

		if FFlagAXSduiPublishRequestIdWithResponse then
			requestId = catalogPageRequestIdStore.getPageVariantRequestIdToSend(props.identifier, screenSize)
		elseif FFlagAXSduiPageVariantRequestId then
			requestId = catalogPageRequestIdStore.activatePageVariant(props.identifier, screenSize)
		else
			requestId = catalogPageRequestIdStore.getOrCreatePageRequestId(props.identifier)
		end

		fetchCatalogPage({ requestId = requestId, context = props.context, screenSize = screenSize }, loadTimer)
	end, { loadTimer, screenSize, props.context, props.identifier, v2, catalogPageRequestIdStore })

	local onRetry = React.useCallback(function()
		if FFlagAXSduiPageVariantRequestId then
			catalogPageRequestIdStore.resetPageVariantRequestId(props.identifier, screenSize)
		else
			catalogPageRequestIdStore.resetPageRequestId(props.identifier)
		end

		local requestId

		if FFlagAXSduiPageVariantRequestId then
			requestId = catalogPageRequestIdStore.activatePageVariant(props.identifier, screenSize)
		else
			requestId = catalogPageRequestIdStore.getOrCreatePageRequestId(props.identifier)
		end

		fetchCatalogPage({ requestId = requestId, context = props.context, screenSize = screenSize }, loadTimer, {
			forceRefresh = true
		})
	end, { loadTimer, screenSize, props.context, props.identifier, catalogPageRequestIdStore })

	return React.createElement(
		CatalogSduiPageContext.Provider,
		{ value = v4 },
		React.createElement(SduiFeatureEntryPoint, {
			configKey = getCatalogConfigKey(props.context, screenSize),
			identifier = props.identifier,
			appPage = appPage,
			loadTimer = loadTimer,
			Size = props.Size,
			AutomaticSize = props.AutomaticSize,
			Position = props.Position,
			onAbsoluteSizeChange = onAbsoluteSizeChange,
			onRetry = onRetry,
			shouldDisplayLoading = props.shouldDisplayLoading,
			shouldDisplayError = props.shouldDisplayError,
			loadingSlot = props.loadingSlot,
			errorSlot = props.errorSlot,
			ref = ref
		})
	)
end

return React.forwardRef(CatalogSduiEntryPoint)
