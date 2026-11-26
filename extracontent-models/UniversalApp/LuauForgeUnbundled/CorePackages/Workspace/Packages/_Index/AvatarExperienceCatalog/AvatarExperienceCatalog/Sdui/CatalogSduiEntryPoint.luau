local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").Enums.AvatarScreen
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SduiSharedUtilities")
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local fetchCatalogPage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/fetchCatalogPage")
local useComponentBreakpointSize = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Hooks/useComponentBreakpointSize")
local getCatalogConfigKey = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogConfigKey")
local CatalogSduiPageContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiPageContext")
local GetCatalogPageRequestIdStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetCatalogPageRequestIdStore")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXSduiFeedPublishesBreakpoint = AvatarExperienceFlags.FFlagAXSduiFeedPublishesBreakpoint
local fFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter
local fFlagAXSduiFeedMaintainScrollOnSeeAll = AvatarExperienceFlags.FFlagAXSduiFeedMaintainScrollOnSeeAll
local fFlagAXSduiPageVariantRequestId = AvatarExperienceFlags.FFlagAXSduiPageVariantRequestId
local fFlagAXSduiPublishRequestIdWithResponse = AvatarExperienceFlags.FFlagAXSduiPublishRequestIdWithResponse
local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagAXScrollTelemetryIntegration2

local function CatalogSduiEntryPoint(props, p2)
	local v7

	if fFlagAXSduiFeedPublishesBreakpoint or fFlagAXMarketplaceBreakpointMismatchCounter then
		v7 = props.breakpointOptions
	end

	local v8, v9 = useComponentBreakpointSize(nil, v7)

	local v10 = React.useMemo(function()
		return sduiLoadTimer.createLoadTimer(avatarScreen.Catalog)
	end, {})

	if props.loadTimer then
		v10 = props.loadTimer
	end

	local v11 = if props.appPage then props.appPage else avatarScreen.Catalog

	local v12 = GetCatalogPageRequestIdStore(false)
	local v13 = useSignalState(v12.getPageRequestIdMap)[props.identifier]

	local useMemo = React.useMemo
	local function fn()
		local v14 = {
			identifier = props.identifier,
			scrollPerformanceIntervalName = 0,
			onScroll = 0,
			requestImpressionsSignal = 0,
			scrollPositionRef = 0,
			scrollRestoreRef = 0
		}

		local v15 = if fFlagAXScrollTelemetryIntegration2 then props.scrollPerformanceIntervalName else nil
		v14.scrollPerformanceIntervalName = v15

		v14.onScroll = props.onScroll
		v14.requestImpressionsSignal = props.requestImpressionsSignal
		local v16 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then props.scrollPositionRef else nil
		v14.scrollPositionRef = v16
		local v17 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then props.scrollRestoreRef else nil
		v14.scrollRestoreRef = v17
		return v14
	end

	local identifier = props.identifier
	local scrollPerformanceIntervalName = if fFlagAXScrollTelemetryIntegration2 then props.scrollPerformanceIntervalName else nil
	local onScroll = props.onScroll
	local requestImpressionsSignal = props.requestImpressionsSignal
	local scrollPositionRef = if fFlagAXSduiFeedMaintainScrollOnSeeAll then props.scrollPositionRef else nil
	local v15 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then props.scrollRestoreRef else nil
	local v16 = useMemo(fn, {
		identifier,
		scrollPerformanceIntervalName,
		onScroll,
		requestImpressionsSignal,
		scrollPositionRef,
		v15
	})

	React.useEffect(function()
		if fFlagAXSduiPublishRequestIdWithResponse then
			v12.activatePageVariant(props.identifier, v8)
		end

		local v17

		if fFlagAXSduiPublishRequestIdWithResponse then
			v17 = v12.getPageVariantRequestIdToSend(props.identifier, v8)
		elseif fFlagAXSduiPageVariantRequestId then
			v17 = v12.activatePageVariant(props.identifier, v8)
		else
			v17 = v12.getOrCreatePageRequestId(props.identifier)
		end

		fetchCatalogPage({ requestId = v17, context = props.context, screenSize = v8 }, v10)
	end, { v10, v8, props.context, props.identifier, v13, v12 })

	local v17 = React.useCallback(function()
		if fFlagAXSduiPageVariantRequestId then
			v12.resetPageVariantRequestId(props.identifier, v8)
		else
			v12.resetPageRequestId(props.identifier)
		end

		local v18 = if fFlagAXSduiPageVariantRequestId then v12.activatePageVariant(props.identifier, v8) else v12.getOrCreatePageRequestId(props.identifier)
		fetchCatalogPage({ requestId = v18, context = props.context, screenSize = v8 }, v10, {
			forceRefresh = true
		})
	end, { v10, v8, props.context, props.identifier, v12 })

	return React.createElement(
		CatalogSduiPageContext.Provider,
		{ value = v16 },
		React.createElement(sduiFeatureEntryPoint, {
			configKey = getCatalogConfigKey(props.context, v8),
			identifier = props.identifier,
			appPage = v11,
			loadTimer = v10,
			Size = props.Size,
			AutomaticSize = props.AutomaticSize,
			Position = props.Position,
			onAbsoluteSizeChange = v9,
			onRetry = v17,
			shouldDisplayLoading = props.shouldDisplayLoading,
			shouldDisplayError = props.shouldDisplayError,
			loadingSlot = props.loadingSlot,
			errorSlot = props.errorSlot,
			ref = p2
		})
	)
end

return React.forwardRef(CatalogSduiEntryPoint)
