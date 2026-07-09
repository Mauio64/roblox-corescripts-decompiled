local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperiencePhotobooth = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local makeAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.makeAvatarRoute)
local AvatarExperienceAlwaysMounted = require(Modules.AvatarExperience.Common.Components.AvatarExperienceAlwaysMounted)
local AvatarExperienceRootNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceRootNavigator)
local CurrentTabContext = require(Modules.LuaApp.Navigation.CurrentTabContext)
local SwitchNavigatorVisibleContext = require(Modules.LuaApp.Navigation.SwitchNavigatorVisibleContext)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local v20 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.loadtime")
local IntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).IntervalPerformanceTracker
local Utils = require(Modules.AvatarExperience.Common.Utils)
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local NamedRefsContext = require(Modules.AvatarExperience.Common.Context.NamedRefsContext)
local v28 = Roact.Component:extend("AvatarExperienceRootContainer")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useUnifiedEventListener = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventListener.useUnifiedEventListener
local ProviderContainer = RoactUtils.Components.ProviderContainer
local AXCatalogStoreContext = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Context.AXCatalogStoreContext
local getCatalogStores = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Stores.getCatalogStores
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarEditorStores = AvatarExperienceSlotBasedEditor.Context.AvatarEditorStores
local createInventoryStoresFromCategories = require(Modules.AvatarExperience.SlotBasedEditor.Utils.createInventoryStoresFromCategories)
local createAvatarEditorStores = AvatarExperienceSlotBasedEditor.Stores.createAvatarEditorStores
local AnimatedVisibilityProvider = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.AnimatedVisibilityProvider
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local GetTopLevelPageFPSCounterName = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Utils.GetTopLevelPageFPSCounterName)
local u41 = game:DefineFastInt("AvatarExperienceFPSDuration", 6)
local GetFFlagAXFPSEventStreamAndCounters = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAXFPSEventStreamAndCounters
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local FFlagAXPhotoboothFunctionality = AvatarExperienceFlags.FFlagAXPhotoboothFunctionality
local FFlagAXAvatarEditorStoresContext = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarEditorStoresContext
local OnFocusLayerExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusLayerExposureLogger)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local FFlagAXPhotoboothExposure = AvatarExperienceFlags.FFlagAXPhotoboothExposure
local FFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local v50 = game:DefineFastFlag("AXGamepadNoHarmExposureLogging", false)
local v51 = game:DefineFastFlag("AXUseFlagLinkedUserLayerExposure", false)
local v52 = game:DefineFastFlag("AXAllViewsSecondaryExposure", false)
local FFlagAXDurablesSupportExposureLogging = AvatarExperienceFlags.FFlagAXDurablesSupportExposureLogging
local FStringAXDurablesSupportExposureLayer = AvatarExperienceFlags.FStringAXDurablesSupportExposureLayer
local FFlagAXSlotsDesignUpdatesExposureLogging = AvatarExperienceFlags.FFlagAXSlotsDesignUpdatesExposureLogging

local function v56() -- line: 154
	-- upvalues: useUnifiedEventListener (copy)
	useUnifiedEventListener()

	return nil
end

function v28.init(p1) -- line: 159
	-- upvalues: RoactGamepad (copy), makeAvatarRoute (copy), FFlagAXAvatarEditorStoresContext (copy), createAvatarEditorStores (copy), createInventoryStoresFromCategories (copy), getCatalogStores (copy)
	p1.namedRefs = RoactGamepad.createRefCache()
	p1.startAXLatencyTimer = os.clock()
	p1.isNavigating = false

	local navigation = p1.props.navigation

	p1:trackTopLevelPageFPS((makeAvatarRoute(navigation, false)))

	if FFlagAXAvatarEditorStoresContext then
		p1.avatarEditorStores = createAvatarEditorStores()
		p1.avatarEditorStores.categoryInventoryStores = createInventoryStoresFromCategories()
	end

	p1.catalogStores = getCatalogStores()
end
function v28.getProviders(p2) -- line: 178
	-- upvalues: FFlagAXPhotoboothFunctionality (copy), AvatarExperiencePhotobooth (copy), FFlagAXHideMenuOnScroll (copy), AnimatedVisibilityProvider (copy), FFlagAXAvatarEditorStoresContext (copy), AvatarEditorStores (copy), AXCatalogStoreContext (copy)
	local t1 = {}

	if FFlagAXPhotoboothFunctionality then
		table.insert(t1, {
			class = AvatarExperiencePhotobooth.Context.PhotoboothContextProvider
		})
	end

	if FFlagAXHideMenuOnScroll then
		table.insert(t1, {
			class = AnimatedVisibilityProvider
		})
	end

	if FFlagAXAvatarEditorStoresContext then
		table.insert(t1, {
			class = AvatarEditorStores.Provider,
			props = {
				value = p2.avatarEditorStores
			}
		})
	end

	table.insert(t1, {
		class = AXCatalogStoreContext.Provider,
		props = {
			value = p2.catalogStores
		}
	})

	return t1
end
function v28.render(p3) -- line: 206
	-- upvalues: Roact (copy), CurrentTabContext (copy), SwitchNavigatorVisibleContext (copy), AvatarScreen (copy), OnFocusExperimentExposureLogger (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), FFlagAXDurablesSupportExposureLogging (copy), FFlagAXSlotsDesignUpdatesExposureLogging (copy), FStringAXDurablesSupportExposureLayer (copy), FFlagAXPhotoboothExposure (copy), OnFocusLayerExposureLogger (copy), AppUserLayers (copy)
	return Roact.createElement(CurrentTabContext.Consumer, {
		render = function(p4) -- line: 210
			-- upvalues: Roact (copy), SwitchNavigatorVisibleContext (copy), p3 (copy), AvatarScreen (copy), OnFocusExperimentExposureLogger (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), FFlagAXDurablesSupportExposureLogging (copy), FFlagAXSlotsDesignUpdatesExposureLogging (copy), FStringAXDurablesSupportExposureLayer (copy), FFlagAXPhotoboothExposure (copy), OnFocusLayerExposureLogger (copy), AppUserLayers (copy)
			return Roact.createElement(SwitchNavigatorVisibleContext.Consumer, {
				render = function(p5) -- line: 212
					-- upvalues: p3 (copy), p4 (copy), AvatarScreen (copy), Roact (copy), OnFocusExperimentExposureLogger (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), FFlagAXDurablesSupportExposureLogging (copy), FFlagAXSlotsDesignUpdatesExposureLogging (copy), FStringAXDurablesSupportExposureLayer (copy), FFlagAXPhotoboothExposure (copy), OnFocusLayerExposureLogger (copy), AppUserLayers (copy)
					local v114 = p3.props.screenProps and p3.props.screenProps.isVisible or not not p5 and (p4 == AvatarScreen.AvatarExperienceRoot or false)

					return Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						Visible = v114
					}, {
						AvatarExperienceRoot = p3:renderWithVisibility(v114),
						OnFocusExperimentExposureLogger = Roact.createElement(OnFocusExperimentExposureLogger, {
							ixpTests = { if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else AXEnableAccessoryAdjustmentDuringTryOnIXP },
							flagIXPTestLayers = if not FFlagAXDurablesSupportExposureLogging and not FFlagAXSlotsDesignUpdatesExposureLogging then nil else { if not FFlagAXDurablesSupportExposureLogging then nil else FStringAXDurablesSupportExposureLayer }
						}),
						OnFocusLayerExposureLogger = if not FFlagAXPhotoboothExposure then nil else Roact.createElement(OnFocusLayerExposureLogger, {
							ixpLayers = { AppUserLayers.AvatarExperienceUAAllViews }
						})
					})
				end
			})
		end
	})
end
function v28.renderWithVisibility(p6, p7) -- line: 258
	-- upvalues: makeAvatarRoute (copy), Roact (copy), AvatarRouteContext (copy), ProviderContainer (copy), NamedRefsContext (copy), AvatarExperienceRootNavigator (copy), AvatarExperienceAlwaysMounted (copy), v56 (copy)
	local navigation = p6.props.navigation
	local v69 = makeAvatarRoute(navigation, p7)
	local v70 = p6:getProviders()

	return Roact.createElement(AvatarRouteContext.Provider, {
		value = v69
	}, {
		ProviderContainer = Roact.createElement(ProviderContainer, {
			providers = v70
		}, {
			AvatarExperienceRootWithProviders = Roact.createElement(NamedRefsContext.Provider, {
				value = p6.namedRefs
			}, {
				RootNavigator = Roact.createElement(AvatarExperienceRootNavigator, {
					navigation = navigation,
					avatarRoute = v69
				}),
				AlwaysMounted = Roact.createElement(AvatarExperienceAlwaysMounted, {
					navigation = navigation,
					avatarRoute = v69
				}),
				Analytics = Roact.createElement(v56)
			})
		})
	})
end

local function getPageErrorCounterMap(b1: boolean) -- line: 286
	-- upvalues: Constants (copy), AvatarScreen (copy)
	local TopLevelErrors = Constants.Counter.TopLevelErrors

	return {
		[AvatarScreen.Catalog] = TopLevelErrors.CatalogViewError,
		[AvatarScreen.CatalogSearch] = TopLevelErrors.SearchViewError,
		[AvatarScreen.AvatarEditor] = TopLevelErrors.EditorViewError,
		[AvatarScreen.ItemDetails] = b1 and TopLevelErrors.SearchItemDetailsViewError or TopLevelErrors.CatalogItemDetailsViewError,
		[AvatarScreen.SortAndFilters] = b1 and TopLevelErrors.SearchFiltersViewError or TopLevelErrors.CatalogFiltersViewError
	}
end
local function trackTopLevelErrorCounters(p8, p9) -- line: 305
	-- upvalues: NavigationUtils (copy), AvatarScreen (copy), getPageErrorCounterMap (copy), Constants (copy)
	local name = p8.current.name
	local v76 = NavigationUtils.isWithinViewContext(p8, AvatarScreen.CatalogSearch)
	local v77 = getPageErrorCounterMap(v76)[name] or Constants.Counter.TopLevelErrors.UnknownViewError

	task.spawn(function() -- line: 314
		-- upvalues: p9 (copy), v77 (copy)
		p9.sendAXCounter(v77)
	end)
end
local function getPageLatencyCountersMap(b2: boolean) -- line: 319
	-- upvalues: Constants (copy), AvatarScreen (copy)
	local TopLevelLatency = Constants.Counter.TopLevelLatency

	return {
		[AvatarScreen.Catalog] = TopLevelLatency.CatalogViewLatency,
		[AvatarScreen.CatalogSearch] = TopLevelLatency.SearchViewLatency,
		[AvatarScreen.AvatarEditor] = TopLevelLatency.EditorViewLatency,
		[AvatarScreen.ItemDetails] = b2 and TopLevelLatency.SearchItemDetailsViewLatency or TopLevelLatency.CatalogItemDetailsViewLatency,
		[AvatarScreen.SortAndFilters] = b2 and TopLevelLatency.SearchFiltersViewLatency or TopLevelLatency.CatalogFiltersViewLatency
	}
end

function v28.trackTopLevelPageLatency(p10) -- line: 332
	-- upvalues: makeAvatarRoute (copy), NavigationUtils (copy), AvatarScreen (copy), getPageLatencyCountersMap (copy), Constants (copy), v20 (copy), Utils (copy)
	local navigation = p10.props.navigation
	local v82 = makeAvatarRoute(navigation, false)
	local appAnalytics = p10.props.appAnalytics
	local name = v82.current.name
	local v85 = NavigationUtils.isWithinViewContext(v82, AvatarScreen.CatalogSearch)
	local v86 = getPageLatencyCountersMap(v85)[name] or Constants.Counter.TopLevelLatency.UnknownViewLatency
	local v87 = (os.clock() - p10.startAXLatencyTimer) * 1000

	v20:info("Avatar experirence load time: {} ms", v87)

	local v88 = v86 .. "_" .. Utils.getDeviceType()

	appAnalytics.Diag:reportStats(v88, v87)
	p10.props.catalogAnalytics.sendAXStat(Constants.Counter.TopLevelLatency.Name, v87, {
		Page = v86
	})
	p10.startAXLatencyTimer = nil
end
function v28.trackTopLevelPageFPS(_, p12) -- line: 359
	-- upvalues: GetTopLevelPageFPSCounterName (copy), u41 (ref), IntervalPerformanceTracker (copy), GetFFlagAXFPSEventStreamAndCounters (copy)
	local v91 = GetTopLevelPageFPSCounterName(p12.current.name, p12)

	if not u41 or u41 <= 0 then
		u41 = 1
	end

	IntervalPerformanceTracker:startTracking(v91, u41, nil, not not GetFFlagAXFPSEventStreamAndCounters() or nil, not not GetFFlagAXFPSEventStreamAndCounters() or nil)
end
function v28.componentDidCatch(p13, p14, _) -- line: 380
	-- upvalues: makeAvatarRoute (copy), trackTopLevelErrorCounters (copy)
	local navigation = p13.props.navigation
	local v96 = makeAvatarRoute(navigation, false)
	local catalogAnalytics = p13.props.catalogAnalytics

	trackTopLevelErrorCounters(v96, catalogAnalytics)
	error(p14)
end
function v28.didMount(p16) -- line: 392
	-- upvalues: v50 (copy), v51 (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IxpUtils (copy), v52 (copy)
	p16:trackTopLevelPageLatency()

	if v50 then
		if v51 then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.AvatarExperienceUAAllViews)
		else
			IxpUtils.logLayerExposure(AppUserLayers.AvatarExperienceUAAllViews)
		end
	end

	if v52 then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure("AvatarExperience.UA.AllViews.Secondary")
	end
end
function v28.willUpdate(p17, p18) -- line: 410
	-- upvalues: makeAvatarRoute (copy)
	local navigation = p18.navigation
	local v102 = makeAvatarRoute(navigation, false)
	local name = v102.current.name
	local navigation2 = p17.props.navigation

	if name ~= makeAvatarRoute(navigation2, false).current.name then
		p17.startAXLatencyTimer = os.clock()
		p17.isNavigating = true
		p17:trackTopLevelPageFPS(v102)
	end
end
function v28.didUpdate(p19, p20) -- line: 427
	-- upvalues: makeAvatarRoute (copy)
	local navigation = p19.props.navigation
	local v108 = makeAvatarRoute(navigation, false)
	local navigation3 = p20.navigation
	local name = makeAvatarRoute(navigation3, false).current.name
	local name2 = v108.current.name

	if p19.isNavigating and name2 ~= name then
		p19:trackTopLevelPageLatency()
		p19.isNavigating = false
	end
end

local v60 = RoactServices.connect({
	catalogAnalytics = Analytics,
	appAnalytics = RoactAnalytics
})(v28)

v60.router = AvatarExperienceRootNavigator.router

return v60
