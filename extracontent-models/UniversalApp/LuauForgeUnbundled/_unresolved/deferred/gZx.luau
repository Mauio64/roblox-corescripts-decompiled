local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext

local useTTINavigationTracking = require("@luauforge/bundled/fEs").useTTINavigationTracking
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module4 = require("@luauforge/deferred/gVs")
local module5 = require("@luauforge/deferred/gZy")

local module6 = require("@luauforge/deferred/has")
local module7 = require("@luauforge/bundled/fzG")
local module8 = require("@luauforge/bundled/gJr")
local module9 = require("@luauforge/bundled/dPN")
local module10 = require("@luauforge/bundled/dXh")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module11 = require("@luauforge/bundled/fDf")
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.loadtime")

local intervalPerformanceTracker = require("@luauforge/bundled/fDl").IntervalPerformanceTracker
local module12 = require("@luauforge/bundled/fCe")

local module13 = require("@luauforge/deferred/gUI")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local module15 = require("@luauforge/bundled/dPR")
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper

local module16 = require("@luauforge/deferred/gLm")
local extended = Roact.Component:extend("AvatarExperienceRootContainer")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local useUnifiedEventListener = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").useUnifiedEventListener.useUnifiedEventListener
local providerContainer = RoactUtils.Components.ProviderContainer

local axCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Context.AXCatalogStoreContext
local getCatalogStores = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Stores.getCatalogStores

local module17 = require("@luauforge/bundled/fCn")
local avatarEditorStores = module17.Context.AvatarEditorStores

local module18 = require("@luauforge/deferred/hht")

local module19 = require("@luauforge/deferred/hhv")
local createAvatarEditorStores = module17.Stores.createAvatarEditorStores
local animatedVisibilityProvider = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.AnimatedVisibilityProvider

local module20 = require("@luauforge/bundled/ecq")

local module21 = require("@luauforge/deferred/hkU")

local module22 = require("@luauforge/deferred/hkV")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local v5 = game:DefineFastInt("AvatarExperienceFPSDuration", 6)

local fFlagAXAvatarEditorStoresContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarEditorStoresContext
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local v6 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/gNB") else nil

local provider = if fFlagAXAvatarFoldersEnabled then v6.Context.FoldersStoreContext.Provider else nil

local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local fFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll

local defineFastFlag = game:DefineFastFlag("AXGamepadNoHarmExposureLogging", false)
local defineFastFlag2 = game:DefineFastFlag("AXUseFlagLinkedUserLayerExposure", false)
local defineFastFlag3 = game:DefineFastFlag("AXAllViewsSecondaryExposure", false)

local fFlagAXDurablesSupportExposureLogging = AvatarExperienceFlags.FFlagAXDurablesSupportExposureLogging
local fStringAXDurablesSupportExposureLayer = AvatarExperienceFlags.FStringAXDurablesSupportExposureLayer

local fFlagAXSlotsDesignUpdatesExposureLogging = AvatarExperienceFlags.FFlagAXSlotsDesignUpdatesExposureLogging

local defineFastFlag4 = game:DefineFastFlag("AXAllViewsDefaultExposureLogging", false)

local fFlagFixNavigateToCatalogMetric = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixNavigateToCatalogMetric

local defineFastFlag5 = game:DefineFastFlag("AXTopLevelErrorCounterV2", false)

local function fn(): nil
	useUnifiedEventListener()
	return nil
end

local function fn2(): nil
	useTTINavigationTracking("NavigateTo_" .. appPage.AvatarExperienceRoot)
	return nil
end

function extended:init()
	self.namedRefs = RoactGamepad.createRefCache()
	self.startAXLatencyTimer = os.clock()
	self.isNavigating = false

	self:trackTopLevelPageFPS((module4(self.props.navigation, false)))

	if fFlagAXAvatarEditorStoresContext then
		self.avatarEditorStores = createAvatarEditorStores()
		self.avatarEditorStores.categoryInventoryStores = module18()

		if fFlagAXEditorEnableThumbnailLatencyStore then
			self.avatarEditorStores.thumbnailLatencyStores = module19()
		end
	end

	self.catalogStores = getCatalogStores()
end

function extended:getProviders()
	local providers = {}

	if fFlagAXHideMenuOnScroll then
		table.insert(providers, { class = animatedVisibilityProvider })
	end

	if fFlagAXAvatarEditorStoresContext then
		table.insert(providers, {
			class = avatarEditorStores.Provider,
			props = { value = self.avatarEditorStores }
		})
	end

	table.insert(providers, {
		class = axCatalogStoreContext.Provider,
		props = { value = self.catalogStores }
	})

	if fFlagAXAvatarFoldersEnabled then
		table.insert(providers, { class = provider })
	end

	return providers
end

function extended:render()
	return Roact.createElement(module7.Consumer, {
		render = function(p2)
			return Roact.createElement(module8.Consumer, {
				render = function(p3)
					local isVisible = self.props.screenProps and self.props.screenProps.isVisible
						or p3 and p2 == avatarScreen.AvatarExperienceRoot and true
						or false

					local createElement = Roact.createElement
					local v8 = {
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Visible = isVisible
					}

					local v9 = {
						AvatarExperienceRoot = self:renderWithVisibility(isVisible),
						OnFocusExperimentExposureLogger = 0
					}
					local createElement2 = Roact.createElement
					local v11 = { ixpTests = {}, flagIXPTestLayers = 0 }
					local v12

					if
						defineFastFlag4
						or fFlagAXDurablesSupportExposureLogging
						or fFlagAXSlotsDesignUpdatesExposureLogging
					then
						v12 = { nil, nil }

						local avatarExperienceUAAllViews = if defineFastFlag4 then appUserLayers.AvatarExperienceUAAllViews else nil

						v12[1], v12[2] = avatarExperienceUAAllViews, if fFlagAXDurablesSupportExposureLogging then fStringAXDurablesSupportExposureLayer else nil
					end

					v11.flagIXPTestLayers = v12
					v9.OnFocusExperimentExposureLogger = createElement2(module13, v11)
					return createElement("Frame", v8, v9)
				end
			})
		end
	})
end

function extended:renderWithVisibility(p2)
	local navigation = self.props.navigation
	local v7 = module4(navigation, p2)

	local providers = self:getProviders()
	local createElement = Roact.createElement
	local provider2 = avatarRouteContext.Provider

	local createElement2 = Roact.createElement

	local createElement3 = Roact.createElement
	local provider3 = module16.Provider
	local v13 = { value = self.namedRefs }
	local v14 = {
		RootNavigator = Roact.createElement(module6, {
			navigation = navigation,
			avatarRoute = v7
		}),
		AlwaysMounted = Roact.createElement(module5, {
			navigation = navigation,
			avatarRoute = v7
		}),
		Analytics = Roact.createElement(fn),
		NavigationTTI = 0
	}

	local v15 = if fFlagFixNavigateToCatalogMetric then Roact.createElement(fn2) else nil
	v14.NavigationTTI = v15
	return createElement(provider2, { value = v7 }, {
		ProviderContainer = createElement2(providerContainer, { providers = providers }, {
			AvatarExperienceRootWithProviders = createElement3(provider3, v13, v14)
		})
	})
end

local function getPageErrorCounterMap(withinViewContext)
	local topLevelErrors = module9.Counter.TopLevelErrors
	return {
		[avatarScreen.Catalog] = topLevelErrors.CatalogViewError,
		[avatarScreen.CatalogSearch] = topLevelErrors.SearchViewError,
		[avatarScreen.AvatarEditor] = topLevelErrors.EditorViewError,
		[avatarScreen.ItemDetails] = withinViewContext and topLevelErrors.SearchItemDetailsViewError or topLevelErrors.CatalogItemDetailsViewError,
		[avatarScreen.SortAndFilters] = withinViewContext and topLevelErrors.SearchFiltersViewError or topLevelErrors.CatalogFiltersViewError
	}
end

local function trackTopLevelErrorCounters(p2, catalogAnalytics, message, p3)
	local name = p2.current.name
	local v7 = getPageErrorCounterMap(module10.isWithinViewContext(p2, avatarScreen.CatalogSearch))[name]
		or module9.Counter.TopLevelErrors.UnknownViewError

	task.spawn(function()
		if not defineFastFlag5 then
			catalogAnalytics.sendAXCounter(v7)

			return
		end

		sendAXCounterV2(v7, (module22(message, p3, name, p2.opaque.name)))
	end)
end

local function getPageLatencyCountersMap(withinViewContext)
	local topLevelLatency = module9.Counter.TopLevelLatency
	return {
		[avatarScreen.Catalog] = topLevelLatency.CatalogViewLatency,
		[avatarScreen.CatalogSearch] = topLevelLatency.SearchViewLatency,
		[avatarScreen.AvatarEditor] = topLevelLatency.EditorViewLatency,
		[avatarScreen.ItemDetails] = withinViewContext and topLevelLatency.SearchItemDetailsViewLatency or topLevelLatency.CatalogItemDetailsViewLatency,
		[avatarScreen.SortAndFilters] = withinViewContext and topLevelLatency.SearchFiltersViewLatency or topLevelLatency.CatalogFiltersViewLatency
	}
end

function extended:trackTopLevelPageLatency()
	local v7 = module4(self.props.navigation, false)
	local appAnalytics = self.props.appAnalytics
	local name = v7.current.name
	local v8 = getPageLatencyCountersMap(module10.isWithinViewContext(v7, avatarScreen.CatalogSearch))[name]
		or module9.Counter.TopLevelLatency.UnknownViewLatency
	local v9 = (os.clock() - self.startAXLatencyTimer) * 1000
	logger:info("Avatar experirence load time: {} ms", v9)

	local v10 = v8 .. "_" .. module12.getDeviceType()
	appAnalytics.Diag:reportStats(v10, v9)

	self.props.catalogAnalytics.sendAXStat(module9.Counter.TopLevelLatency.Name, v9, {
		Page = v8
	})

	self.startAXLatencyTimer = nil
end

function extended:trackTopLevelPageFPS(p3)
	local v7 = module21(p3.current.name, p3)

	if not v5 or v5 <= 0 then
		v5 = 1
	end

	intervalPerformanceTracker:startTracking(v7, v5, nil, true, true)
end

function extended.componentDidCatch(p2, message, p3)
	trackTopLevelErrorCounters(module4(p2.props.navigation, false), p2.props.catalogAnalytics, message, p3)

	error(message)
end

function extended:didMount()
	self:trackTopLevelPageLatency()

	if defineFastFlag then
		if defineFastFlag2 then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.AvatarExperienceUAAllViews)
		else
			module15.logLayerExposure(appUserLayers.AvatarExperienceUAAllViews)
		end
	end

	if defineFastFlag3 then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure("AvatarExperience.UA.AllViews.Secondary")
	end
end

function extended:willUpdate(p2)
	local v7 = module4(p2.navigation, false)

	if v7.current.name ~= module4(self.props.navigation, false).current.name then
		self.startAXLatencyTimer = os.clock()
		self.isNavigating = true
		self:trackTopLevelPageFPS(v7)
	end
end

function extended:didUpdate(p2)
	local v7 = module4(self.props.navigation, false)
	local name = module4(p2.navigation, false).current.name
	local name2 = v7.current.name

	if self.isNavigating and name2 ~= name then
		self:trackTopLevelPageLatency()
		self.isNavigating = false
	end
end

local v7 = roactServices.connect({
	catalogAnalytics = module11,
	appAnalytics = module20
})(extended)

v7.router = module6.router
return v7
