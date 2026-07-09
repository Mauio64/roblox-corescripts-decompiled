local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local AvatarNavigationItemsView = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarNavigationItemsView)
local NavigationEventsLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local SetItemDetailsPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetItemDetailsPeekViewState
local OpenItemPrompt = require(Modules.AvatarExperience.Common.Thunks.OpenItemPrompt)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local OpenQuickMenu = require(Modules.AvatarExperience.Common.Thunks.OpenQuickMenu)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local isGamepadInput = RoactUtils.isGamepadInput
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AXDisableAlwaysRenderedScreensIXP = require(Modules.AvatarExperience.Experiments.AXDisableAlwaysRenderedScreensIXP)
local AXCombineGetOutfitDispatchesIXP = require(Modules.AvatarExperience.Experiments.AXCombineGetOutfitDispatchesIXP)
local OnFocusExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExposureLogger)
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)
local useAvatarExperienceFocusNavigationBindings = require(Modules.AvatarExperience.Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useAvatarEditorPageFocusNavigationBindings = require(script.Parent.useAvatarEditorPageFocusNavigationBindings)
local useOpenQuickMenuCallback = require(Modules.AvatarExperience.Common.Hooks.useOpenQuickMenuCallback)
local useQuickMenuAvailable = require(Modules.AvatarExperience.Common.Hooks.useQuickMenuAvailable)
local useOverlayClosedCallback = require(Modules.AvatarExperience.Common.Hooks.useOverlayClosedCallback)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local useRoactService = RobloxAppHooks.useRoactService
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local AvatarEditorTopBar = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarEditorTopBar)
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local AvatarMarketplaceBackendIXPTests = require(Modules.AvatarExperience.Flags.AvatarMarketplaceBackendIXPTests)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagAXDisableEditorLayerExposure = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableEditorLayerExposure)
local GetFlagAXEnableInitialTopLevelPageCounter = require(Modules.AvatarExperience.Flags.GetFlagAXEnableInitialTopLevelPageCounter)
local FFlagAXCustomizeOverhaulEditorExposure = require(Modules.AvatarExperience.Flags.FFlagAXCustomizeOverhaulEditorExposure)
local FFlagAXCatalogAndEditorExposureUseFStringLayer = require(Modules.AvatarExperience.Flags.FFlagAXCatalogAndEditorExposureUseFStringLayer)
local GetFStringAXCatalogAndEditorExposureLayerName = require(Modules.AvatarExperience.Flags.GetFStringAXCatalogAndEditorExposureLayerName)
local FFlagAXMigrateAvatarEditorPageInputBindings = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAvatarEditorPageInputBindings
local FFlagDynamicHeadsMigration = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagDynamicHeadsMigration
local GetHeadShapeInventoryStore = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Stores.GetHeadShapeInventoryStore)
local v62 = Roact.PureComponent:extend("AvatarEditorPage")

function v62.init(p1) -- line: 95
	-- upvalues: Roact (copy), UserInputService (copy), isGamepadInput (copy), Utils (copy), GetFlagAXEnableInitialTopLevelPageCounter (copy), sendAXCounterV2 (copy), Constants (copy)
	p1.topBarRef = Roact.createRef()
	p1.sceneUIContainerRef = Roact.createRef()
	p1.refinementButtonsRef = Roact.createRef()
	p1.quickButtonsRef = Roact.createRef()

	local LastInputType = UserInputService:GetLastInputType()

	p1:setState({
		lastInputIsGamepad = isGamepadInput(LastInputType)
	})

	function p1.changeView() -- line: 106
		-- upvalues: p1 (copy), Utils (copy)
		local avatarExperienceAnalytics = p1.props.avatarExperienceAnalytics
		local v95 = Utils.getNewFullViewEnum(p1.props.fullView)

		p1.props.setFullView(avatarExperienceAnalytics, p1.props.avatarRoute.opaque.name, v95)
	end

	p1.defaultChildRef = Roact.createRef()

	function p1.lastInputTypeChangedCallback(p2) -- line: 115
		-- upvalues: isGamepadInput (copy), p1 (copy)
		local v97 = isGamepadInput(p2)

		if v97 ~= p1.state.lastInputIsGamepad then
			p1:setState({
				lastInputIsGamepad = v97
			})
		end
	end

	if GetFlagAXEnableInitialTopLevelPageCounter() then
		sendAXCounterV2(Constants.Counter.TopLevelPageInitialView.Editor)
	end
end

if FFlagAXCustomizeOverhaulEditorExposure then
	function v62.didMount(_) -- line: 130
		-- upvalues: IxpUtils (copy), FFlagAXCatalogAndEditorExposureUseFStringLayer (copy), GetFStringAXCatalogAndEditorExposureLayerName (copy), AppUserLayers (copy)
		IxpUtils.logLayerExposure(if not FFlagAXCatalogAndEditorExposureUseFStringLayer then AppUserLayers.AvatarExperienceUAAllViews else GetFStringAXCatalogAndEditorExposureLayerName())
	end
end

if not FFlagAXMigrateAvatarEditorPageInputBindings then
	function v62.getInputBindings(p4) -- line: 140
		-- upvalues: AvatarScreen (copy), Cryo (copy), RoactGamepad (copy), NavigationUtils (copy)
		local avatarRoute = p4.props.avatarRoute
		local t1 = {}

		if avatarRoute.current.name == AvatarScreen.ItemDetails then
			t1 = Cryo.Dictionary.join(t1, {
				NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 148
					-- upvalues: NavigationUtils (copy), p4 (copy)
					NavigationUtils.closeFocusedScreen(p4.props.navigation)
				end),
				OpenItemPrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, function() -- line: 151
					-- upvalues: p4 (copy), avatarRoute (copy)
					p4.props.openItemPrompt(p4.props.networking, p4.props.catalogAnalytics, p4.props.overlayClosedCallback, p4.props.navigation, avatarRoute)
				end, {
					key = "Feature.Catalog.Action.Buy"
				}),
				OpenCatalogContextMenu = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL3, function() -- line: 162
					-- upvalues: p4 (copy), AvatarScreen (copy), avatarRoute (copy)
					p4.props.navigation.navigate(AvatarScreen.CatalogContextMenu, {
						itemId = avatarRoute.current.params.itemId,
						itemType = avatarRoute.current.params.itemType,
						onOverlayClosed = p4.props.overlayClosedCallback
					})
				end, {
					key = "Feature.Catalog.Action.ItemOptions"
				})
			})
		end

		return t1
	end
end

function v62.render(p5) -- line: 178
	-- upvalues: FullView (copy), Roact (copy), OnFocusExposureLogger (copy), UniversalAppCameraIXPTest (copy), OnFocusExperimentExposureLogger (copy), AXDisableAlwaysRenderedScreensIXP (copy), AXCombineGetOutfitDispatchesIXP (copy), GetFFlagAXDisableEditorLayerExposure (copy), AvatarMarketplaceBackendIXPTests (copy), ExternalEventConnection (copy), UserInputService (copy), NavigationEventsLogger (copy), AvatarExperienceView (copy), React (copy), AvatarEditorTopBar (copy), AvatarNavigationItemsView (copy)
	local v73 = p5.props.fullView == FullView.SceneFullView
	local v74 = p5.props.fullView == FullView.UIFullView
	local quickButtonsRef = p5.quickButtonsRef

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Ref] = p5.ref
	}, {
		UniversalAppCameraExposure = Roact.createElement(OnFocusExposureLogger, {
			ixpTest = UniversalAppCameraIXPTest
		}),
		OnFocusExperimentExposureLogger = Roact.createElement(OnFocusExperimentExposureLogger, {
			ixpTests = {
				if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then nil else AXDisableAlwaysRenderedScreensIXP,
				if not AXCombineGetOutfitDispatchesIXP.isEnabled() then nil else AXCombineGetOutfitDispatchesIXP
			}
		}),
		EditorExposure = if not GetFFlagAXDisableEditorLayerExposure() then Roact.createElement(OnFocusExposureLogger, {
			ixpTest = AvatarMarketplaceBackendIXPTests.Editor
		}) else nil,
		LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = p5.lastInputTypeChangedCallback
		}),
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "AvatarEditor"
		}),
		AvatarExperienceView = Roact.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = true,
			bottomBarEnabled = false,
			changeViewFunction = p5.changeView,
			isSceneFullView = v73,
			isUIFullView = v74,
			topBar = React.createElement(AvatarEditorTopBar, {
				showManageOutfitButton = p5.props.showManageOutfitButton,
				overlayClosedCallback = p5.props.overlayClosedCallback,
				topBarRef = p5.topBarRef,
				NextSelectionDown = p5.defaultChildRef,
				NextSelectionRight = p5.sceneUIContainerRef,
				navigation = p5.props.navigation,
				avatarRoute = p5.props.avatarRoute
			}),
			refinementButtonsRef = p5.refinementButtonsRef,
			quickButtonsRef = p5.quickButtonsRef,
			ref = p5.sceneUIContainerRef,
			NextSelectionDown = p5.defaultChildRef,
			NextSelectionLeft = p5.topBarRef,
			defaultChildRef = p5.defaultChildRef
		}, {
			AvatarNavigationItemsView = Roact.createElement(AvatarNavigationItemsView, {
				defaultChildRef = p5.defaultChildRef,
				NextSelectionUp = p5.topBarRef,
				NextSelectionRight = quickButtonsRef
			})
		})
	})
end

local v63 = RoactServices.connect({
	avatarExperienceAnalytics = Analytics,
	catalogAnalytics = if not FFlagAXMigrateAvatarEditorPageInputBindings then Analytics2 else nil,
	networking = if not FFlagAXMigrateAvatarEditorPageInputBindings then RoactNetworking else nil
})(v62)
local u64 = withStackVisibilityWrapper((RoactRodux.connect(function(p6, _) -- line: 248
	-- upvalues: Utils (copy), selectIsFullView (copy), AvatarScreen (copy), selectIsPortrait (copy)
	local v78 = Utils.getAvatarEditorCategoryInfoFromState(p6)

	return {
		fullView = selectIsFullView(p6, AvatarScreen.AvatarEditor),
		isPortrait = selectIsPortrait(p6),
		itemDetailsExpanded = p6.AvatarExperience.Common.ItemDetailsExpanded,
		showManageOutfitButton = v78.ManageOutfitsEnabled == true,
		isCurrentUserAllowedToCreateShares = p6.AvatarExperience.Catalog.Metadata.isCurrentUserAllowedToCreateShares
	}
end, function(p8) -- line: 258
	-- upvalues: FFlagAXMigrateAvatarEditorPageInputBindings (copy), OpenItemPrompt (copy), SetItemDetailsPeekViewState (copy), OpenQuickMenu (copy), SetFullView (copy)
	return {
		openItemPrompt = not FFlagAXMigrateAvatarEditorPageInputBindings and function(p9, p10, p11, p12, p13) -- line: 262
			-- upvalues: p8 (copy), OpenItemPrompt (copy)
			p8(OpenItemPrompt(p9, p10, p11, p12, p13))
		end or nil,
		setItemDetailsPeekViewState = not FFlagAXMigrateAvatarEditorPageInputBindings and function(p14) -- line: 267
			-- upvalues: p8 (copy), SetItemDetailsPeekViewState (copy)
			p8(SetItemDetailsPeekViewState(p14))
		end or nil,
		navigateIntoQuickMenu = not FFlagAXMigrateAvatarEditorPageInputBindings and function(p15, p16) -- line: 272
			-- upvalues: p8 (copy), OpenQuickMenu (copy)
			p8(OpenQuickMenu(p15, p16))
		end or nil,
		setFullView = function(p17, p18, p19) -- line: 275
			-- upvalues: p8 (copy), SetFullView (copy)
			p8(SetFullView(p17, p18, p19))
		end
	}
end)(v63)))

local function AvatarEditorPageContainer(p20) -- line: 283
	-- upvalues: FFlagDynamicHeadsMigration (copy), React (copy), GetHeadShapeInventoryStore (copy), useOverlayClosedCallback (copy), FFlagAXMigrateAvatarEditorPageInputBindings (copy), useDispatch (copy), useRoactService (copy), Analytics2 (copy), RoactNetworking (copy), useQuickMenuAvailable (copy), useAvatarRoute (copy), AvatarScreen (copy), useOpenQuickMenuCallback (copy), NavigationUtils (copy), OpenItemPrompt (copy), useAvatarEditorPageFocusNavigationBindings (copy), useAvatarExperienceFocusNavigationBindings (copy), Cryo (copy), useUiModeInfo (copy), UiMode (copy), u64 (ref)
	if FFlagDynamicHeadsMigration then
		React.useEffect(function() -- line: 285
			-- upvalues: GetHeadShapeInventoryStore (copy)
			local v109 = GetHeadShapeInventoryStore(false)

			if v109 then
				v109.getInventory(false)
			end
		end, {})
	end

	local v81 = useOverlayClosedCallback()
	local v92

	if FFlagAXMigrateAvatarEditorPageInputBindings then
		local v82 = useDispatch()
		local v83 = useRoactService(Analytics2)
		local v84 = useRoactService(RoactNetworking)
		local v85 = useQuickMenuAvailable()
		local v86 = useAvatarRoute()
		local v87 = v86.current.name == AvatarScreen.ItemDetails
		local v88 = useOpenQuickMenuCallback(v81)
		local v89 = React.useCallback(function(p21) -- line: 306
			-- upvalues: NavigationUtils (copy), p20 (copy)
			p21.cancelled = true
			NavigationUtils.closeFocusedScreen(p20.navigation)
		end, { p20.navigation })
		local v90 = React.useCallback(function() -- line: 312
			-- upvalues: v82 (copy), OpenItemPrompt (copy), v84 (copy), v83 (copy), v81 (copy), p20 (copy), v86 (copy)
			v82(OpenItemPrompt(v84, v83, v81, p20.navigation, v86))
		end, {
			v82,
			v84,
			v83,
			v81,
			p20.navigation,
			v86
		})
		local v91 = React.useCallback(function() -- line: 328
			-- upvalues: p20 (copy), AvatarScreen (copy), v86 (copy), v81 (copy)
			p20.navigation.navigate(AvatarScreen.CatalogContextMenu, {
				itemId = v86.current.params.itemId,
				itemType = v86.current.params.itemType,
				onOverlayClosed = v81
			})
		end, {
			p20.navigation,
			v86,
			v81
		})

		v92 = useAvatarEditorPageFocusNavigationBindings({
			onNavigateBack = v89,
			onOpenQuickMenu = if not v85 then nil else v88,
			onOpenBuyItemPrompt = if not v87 then nil else v90,
			onOpenContextMenu = if not v87 then nil else v91
		})
	else
		v92 = useAvatarExperienceFocusNavigationBindings({
			overlayClosedCallback = v81
		})
	end

	local v93 = Cryo.Dictionary.join(p20, {
		overlayClosedCallback = v81,
		is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v92
	}, React.createElement(u64, v93))
end

return AvatarEditorPageContainer
