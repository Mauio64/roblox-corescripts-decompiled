local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local useEffectOnMount = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useEffectOnMount
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local AvatarExperienceControlBar = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local AvatarExperienceSave = require(CorePackages.Workspace.Packages.AvatarExperienceSave)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local tutils = require(CorePackages.Packages.tutils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Constants = require(Modules.LuaApp.Constants)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local withStyle = UIBlox.Style.withStyle
local withNamedRefs = require(Modules.AvatarExperience.Common.Context.withNamedRefs)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local InsetBackground = require(CorePackages.Workspace.Packages.AppBlox).InsetBackground
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local NamedRefConstants = require(Modules.AvatarExperience.Common.NamedRefConstants)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAXMigrateSceneGamepadHandlerInputBindings = SharedFlags.FFlagAXMigrateSceneGamepadHandlerInputBindings
local Display = require(CorePackages.Workspace.Packages.Display)
local v43 = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler_DEPRECATED) else require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler)
local VRAvatarRotateHandler = require(Modules.AvatarExperience.Common.Components.Scene.VRAvatarRotateHandler)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local AvatarLoadingSpinner = require(Modules.AvatarExperience.Common.Components.Scene.AvatarLoadingSpinner)
local SceneUIContainer = require(Modules.AvatarExperience.Common.Components.Scene.SceneUIContainer)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local SceneButtons = require(Modules.AvatarExperience.Common.Components.SceneButtons)
local BottomInsetBackground = require(Modules.AvatarExperience.Common.Components.BottomInsetBackground)
local VRAvatarEditorNavBar = require(Modules.AvatarExperience.Common.Components.NavBar.VRAvatarEditorNavBar)
local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local AvatarVRPanelWrapper = require(Modules.AvatarExperience.Common.Components.AvatarVRPanelWrapper)
local AdaptiveScrollingView = require(Modules.AvatarExperience.Common.Components.AdaptiveScrollingView)
local RobuxBalance = require(Modules.AvatarExperience.Catalog.Components.RobuxBalance)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local TimeoutBanner = AvatarExperienceCommon.Components.TimeoutBanner
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local CheckoutActionBarContainer = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Checkout.CheckoutActionBarContainer
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local MultiTryOnBottomBar = require(Modules.AvatarExperience.Catalog.Components.ActionBar.MultiTryOnBottomBar)
local QuickButtons = require(Modules.AvatarExperience.Common.Components.QuickButtons)
local SlotControlBar = require(Modules.AvatarExperience.SlotBasedEditor.Components.SlotControlBar)
local UndoRedoBar = AvatarExperienceControlBar.UndoRedoBar
local SaveButton = AvatarExperienceSave.Components.SaveButton
local FullViewEntryButton = require(Modules.AvatarExperience.Common.Components.FullViewEntryButton)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local GetFFlagLuaAppEnableTopBanner = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableTopBanner
local GetFFlagAXFixRobuxBalanceButtonPositionSecond = require(Modules.AvatarExperience.Flags.GetFFlagAXFixRobuxBalanceButtonPositionSecond)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMoveRobuxBalanceButtonLower = require(Modules.AvatarExperience.Flags.FFlagAXMoveRobuxBalanceButtonLower)
local FFlagAXEnableManualSaving = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableManualSaving
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local v77 = GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("FFlagAXEnableFullSceneInteractionFrame3", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local GetFFlagAXEnableCategoryPills = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableCategoryPills)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local v81 = game:DefineFastFlag("AXFixConsoleFullSceneViewPosition", false)
local v82 = game:DefineFastFlag("AXQuickButtonsFrameShouldAlwaysExist", false)
local FFlagAXMigrateQuickButtonsToGlobalAutoFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateQuickButtonsToGlobalAutoFocus
local FFlagAXSlotsPeekViewScrollFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsPeekViewScrollFix
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local FFlagAXShowHeadAdjustmentInRightControlBar = AvatarExperienceFlags.FFlagAXShowHeadAdjustmentInRightControlBar
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXMoveContextualActionButtons = AvatarExperienceFlags.FFlagAXMoveContextualActionButtons
local FFlagAXFixControlBarSubMenuOverlap = AvatarExperienceFlags.FFlagAXFixControlBarSubMenuOverlap
local FFlagAXResetAvatarButtonExposureLogging = AvatarExperienceFlags.FFlagAXResetAvatarButtonExposureLogging
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace
local FFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local FFlagStackedBottomNavMarketplaceCTA = SharedFlags.FFlagStackedBottomNavMarketplaceCTA
local VisibilityControl = require(CorePackages.Workspace.Packages.AppNavBar).VisibilityControl
local v98 = game:DefineFastFlag("AXFixLightThemeBorder", false)
local v99 = game:DefineFastFlag("AXDeregisterSurfacesWhenNotVisible", false)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local RemoveUnavailableEquippedAssets = require(Modules.AvatarExperience.Common.Thunks.RemoveUnavailableEquippedAssets)
local useAvatarSaveContext = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.useAvatarSaveContext
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local FFlagAXExpandPeekViewOnFirstScroll = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXExpandPeekViewOnFirstScroll
local FFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXAvatarTimeoutFlow = AvatarExperienceFlags.FFlagAXAvatarTimeoutFlow
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local FFlagAXFixContextualActionVisibility = AvatarExperienceFlags.FFlagAXFixContextualActionVisibility
local FFlagAXFixRobuxButtonShowingInFullView = AvatarExperienceFlags.FFlagAXFixRobuxButtonShowingInFullView
local SelectOutfitTryOnMostRecentAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMostRecentAssetId)
local SlotBasedEditorAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics
local AvatarExperienceControlBar2 = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local IconOnlyMenu = AvatarExperienceControlBar2.IconOnlyMenu
local MenuItemEnum = AvatarExperienceControlBar2.Enums.MenuItemEnum
local ContextualActions = require(Modules.AvatarExperience.SlotBasedEditor.Components.ContextualActions.ContextualActions)
local IconName = Foundation.Enums.IconName
local t1 = {
	[AvatarScreen.UpdateOutfitPage] = true,
	[AvatarScreen.ManageOutfitPage] = true,
	[AvatarScreen.OutfitDetails] = true
}
local t2 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v121 = Constants2.PeekHeaderHeight + (if not GetFFlagAXEnableSlotBasedEditor() then Constants2.MainNavHeight else 0) + Constants2.SubNavHeight
local v122 = if not GetFFlagAXEnableCategoryPills() and not FFlagAXMoveCatalogFilterToL1Navigation then nil else Constants2.PeekHeaderHeight + Constants2.CatalogMainNavHeight
local v123 = GuiService:IsTenFootInterface()

local function selectQuickItemsVisible(p1) -- line: 192
	-- upvalues: PeekViewState (copy)
	local ItemDetailsPeekView = p1.AvatarExperience.Common.ItemDetailsPeekView
	local v135 = ItemDetailsPeekView.viewState == PeekViewState.Full
	local v136 = ItemDetailsPeekView.tryOnViewState == PeekViewState.Full

	return ItemDetailsPeekView.tryOnManagerViewState ~= PeekViewState.Full and (not v135 and not v136)
end

local v125 = Roact.PureComponent:extend("AvatarExperienceView")

v125.defaultProps = {
	bottomBarEnabled = false,
	isDisabled = false,
	showRobuxBalance = true,
	showMultiTryOnBottomBar = true,
	showControlBar = true,
	itemDetailsPeekViewRefs = {}
}

local function mapStateToProps(p2, p3) -- line: 258
	-- upvalues: DeviceOrientationMode (copy), GetFFlagAXFixRobuxBalanceButtonPositionSecond (copy)
	local v139 = p2.DeviceOrientation == DeviceOrientationMode.Portrait
	local v140 = p3.topBar and p2.TopBar.topBarHeight or 0
	local v141 = if not GetFFlagAXFixRobuxBalanceButtonPositionSecond() then nil else p3.topBar and p2.TopBar.statusBarHeight or 0

	return {
		globalGuiInset = p2.GlobalGuiInset,
		isPortrait = v139,
		screenSize = p2.ScreenSize,
		topBarHeight = v140,
		tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lookId = p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId,
		statusBarHeight = if not GetFFlagAXFixRobuxBalanceButtonPositionSecond() then nil else v141
	}
end
local function mapValuesToProps(p4) -- line: 317
	return {
		Size = UDim2.new(0, p4.width, 0, p4.height)
	}
end

function v125.init(p5) -- line: 323
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), FFlagAXCatalogOffersBannerEnabled (copy), Cryo (copy), Roact (copy), FFlagAXMoveRobuxBalanceButtonLower (copy), FFlagAppIaScopedScrollAway (copy), FFlagEnableBottomNavOnMarketplace (copy), VisibilityControl (copy), FFlagStackedBottomNavMarketplaceCTA (copy), GetFFlagAXEnableSlotBasedEditor (copy), React (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), Constants2 (copy), FFlagEnableLeftNavOnConsole (copy), v81 (copy)
	local v144, v145 = p5:calculateSceneSize()

	p5.state = {
		sceneShowing = true,
		isVerticallyOffscreen = false,
		animatedValues = {
			height = v144,
			width = v145
		},
		bottomBarHeight = if not FFlagAXMISEnableMultiShopping then nil else 0
	}

	if FFlagAXCatalogOffersBannerEnabled then
		p5.state = Cryo.Dictionary.join(p5.state, {
			catalogOffersBannerPeekHeaderBackgroundActive = true
		})

		function p5.onCatalogOffersBannerPeekHeaderBackgroundActiveChanged(b1: boolean) -- line: 340
			-- upvalues: p5 (copy)
			if b1 ~= p5.state.catalogOffersBannerPeekHeaderBackgroundActive then
				p5:setState({
					catalogOffersBannerPeekHeaderBackgroundActive = b1
				})
			end
		end
	end

	p5.navItemsFrameRef = Roact.createRef()
	p5.sceneFrameRef = Roact.createRef()
	p5.robuxBalanceRef = if not FFlagAXMoveRobuxBalanceButtonLower then nil else Roact.createRef()

	if FFlagAppIaScopedScrollAway and FFlagEnableBottomNavOnMarketplace then
		function p5.onSheetCanvasYDelta(n1: number) -- line: 354
			-- upvalues: VisibilityControl (copy)
			VisibilityControl.onTouchMoved(-n1)
		end
		function p5.onSheetScrollTouchEnded() -- line: 357
			-- upvalues: VisibilityControl (copy)
			VisibilityControl.onTouchEnded()
		end
	end

	if FFlagStackedBottomNavMarketplaceCTA then
		p5.ctaBottomNavOffsetBinding = VisibilityControl.getFooterBinding()
	end

	if GetFFlagAXEnableSlotBasedEditor() then
		local v146, v147 = React.createBinding(nil)

		p5.quickButtonsZIndexBinding = v146
		p5.setQuickButtonsZIndexBinding = v147

		function p5.onActiveControlBarMenuItemChanged(_: string, b2: boolean) -- line: 369
			-- upvalues: p5 (copy)
			if b2 then
				p5.setQuickButtonsZIndexBinding(3)

				return
			end

			p5.setQuickButtonsZIndexBinding(nil)
		end
	end

	function p5.onTransitionComplete(p6) -- line: 378
		-- upvalues: p5 (copy), AvatarScreen (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy)
		local props = p5.props
		local name = props.avatarRoute.current.name
		local isPortrait = props.isPortrait
		local isSceneFullView = props.isSceneFullView
		local isUIFullView = props.isUIFullView
		local sceneShowing = p5.state.sceneShowing

		if isUIFullView and (isPortrait and sceneShowing) then
			p5:setState({
				sceneShowing = false
			})
		end

		if not isPortrait and isSceneFullView and name == AvatarScreen.AvatarExperienceLandingPage then
			if not p5.state.isVerticallyOffscreen then
				p5:setState({
					isVerticallyOffscreen = true
				})
			end
		elseif p5.state.isVerticallyOffscreen then
			p5:setState({
				isVerticallyOffscreen = false
			})
		end

		if not FFlagAXMigrateAXToGlobalAutofocus then
			local v319 = name == props.navigation.state.routeName and not props.avatarRoute.isOverlayVisible

			if p6 and v319 and props.lastInputGroup == Constants.InputType.Gamepad and not isSceneFullView then
				p6.captureFocus()
			end
		end
	end
	function p5.onNavItemsFrameResized(_) -- line: 418
		-- upvalues: p5 (copy)
		if p5.sceneFrameRef.current then
			p5.onSceneResized(p5.sceneFrameRef.current)
		end
	end
	function p5.onSceneResized(p8) -- line: 426
		-- upvalues: p5 (copy), AvatarScreen (copy), Constants2 (copy), FFlagEnableLeftNavOnConsole (copy), v81 (copy)
		local current = p5.navItemsFrameRef.current

		if not current then
			return
		end

		local props = p5.props
		local name = props.avatarRoute.current.name
		local isDisabled = props.isDisabled
		local isPortrait = props.isPortrait
		local screenSize = props.screenSize
		local allowAdaptiveScrolling = props.allowAdaptiveScrolling
		local v329 = p5:getTopBarHeight()
		local v330 = p5.state.isVerticallyOffscreen or name == AvatarScreen.AvatarExperienceLandingPage

		if isPortrait then
			if allowAdaptiveScrolling then
				current.Position = UDim2.new(0, 0, 0, v329)
				current.Size = UDim2.new(1, 0, 1, -v329)

				return
			end

			current.Position = UDim2.new(0, 0, 0, p8.AbsoluteSize.Y + v329)
			current.Size = UDim2.new(1, 0, 1, -p8.AbsoluteSize.Y - v329)

			return
		end

		local v331 = if not isDisabled then Constants2.LandscapeNavWidth else 1

		current.Size = UDim2.fromScale(v331, 1)

		local v332 = not FFlagEnableLeftNavOnConsole and 0 or props.globalGuiInset.left + props.deviceSafePadding.left
		local AbsoluteSizeX = current.AbsoluteSize.X
		local v334 = screenSize.X - p8.AbsoluteSize.X - (FFlagEnableLeftNavOnConsole and v332 or 0)
		local n2 = 0

		if v334 < AbsoluteSizeX then
			n2 = if not v81 then v334 - AbsoluteSizeX else v334 - AbsoluteSizeX - v329
		end

		if v330 then
			current.Position = UDim2.fromOffset(0, screenSize.Y * (-n2 / AbsoluteSizeX))

			return
		end

		current.Position = UDim2.fromOffset(n2, 0)
	end

	p5.onBottomBarAbsoluteSizeChanged = if not FFlagAXMISEnableMultiShopping then nil else function(p9) -- line: 478
		-- upvalues: p5 (copy)
		p5:setState({
			bottomBarHeight = p9.AbsoluteSize.Y
		})
	end
end
function v125.getTopBarHeight(p10) -- line: 486
	return p10.props.topBarHeight
end
function v125.instantResize(p11) -- line: 491
	local current = p11.sceneFrameRef.current

	if not current then
		return
	end

	local v151, v152 = p11:calculateSceneSize()

	current.Size = UDim2.new(0, v152, 0, v151)
	p11.onSceneResized(current)
end
function v125.calculatePortraitSceneHeight(p12) -- line: 503
	-- upvalues: getSafeAreaSize (copy), Constants2 (copy)
	local props = p12.props
	local globalGuiInset = props.globalGuiInset
	local screenSize = props.screenSize
	local isLandingPage = props.isLandingPage
	local YOffset = getSafeAreaSize(screenSize, globalGuiInset).Y.Offset
	local v159 = YOffset * Constants2.PortraitSceneHeight

	if isLandingPage then
		v159 = YOffset * Constants2.LandingPagePortraitSceneHeight

		if YOffset - v159 < Constants2.LandingPagePortraitMinItemsHeightPix then
			v159 = YOffset - Constants2.LandingPagePortraitMinItemsHeightPix
		end
	end

	return v159
end
function v125.calculateFullHeight(p13) -- line: 526
	local props = p13.props
	local globalGuiInset = props.globalGuiInset
	local isPortrait = props.isPortrait
	local screenSize = props.screenSize
	local bottom = globalGuiInset.bottom
	local v166 = p13:getTopBarHeight()
	local v167 = isPortrait and v166 or 0

	return screenSize.Y - bottom - v167
end
function v125.calculateSceneSize(p14) -- line: 537
	-- upvalues: Constants2 (copy)
	local props = p14.props
	local globalGuiInset = props.globalGuiInset
	local isDisabled = props.isDisabled
	local isSceneFullView = props.isSceneFullView
	local isPortrait = props.isPortrait
	local isUIFullView = props.isUIFullView
	local screenSize = props.screenSize
	local v176 = p14:getTopBarHeight()
	local bottom = globalGuiInset.bottom
	local left = globalGuiInset.left
	local v179 = isPortrait and v176 or 0
	local v180 = screenSize.Y - bottom
	local v181 = (screenSize.X - left) * Constants2.LandscapeSceneWidth
	local v182 = screenSize.X - left
	local v183 = p14:calculatePortraitSceneHeight()
	local v184 = isPortrait and v183 or v180
	local v185 = isPortrait and v182 or v181

	if isUIFullView and isPortrait then
		v184 = 0
	elseif isSceneFullView then
		v185 = screenSize.X
		v184 = screenSize.Y - bottom - v179
	end

	if isDisabled then
		v184 = 0
		v185 = 0
	end

	return v184, v185
end
function v125.isConsoleWithGamepad(p15) -- line: 575
	-- upvalues: v123 (copy), Constants (copy)
	local props = p15.props

	return v123 and props.lastInputGroup == Constants.InputType.Gamepad
end
function v125.renderSceneFrame(p16) -- line: 580
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), IsVRAppBuild (copy), AvatarScreen (copy), Roact (copy), SpringAnimatedItem (copy), mapValuesToProps (copy), t2 (copy), SceneUIContainer (copy), GetFFlagAXFixRobuxBalanceButtonPositionSecond (copy), v77 (copy), SceneInteractionFrame (copy), AvatarLoadingSpinner (copy), VRAvatarEditorNavBar (copy), RoactGamepad (copy), Focusable (copy)
	local props = p16.props
	local isDisabled = props.isDisabled
	local isSceneFullView = props.isSceneFullView
	local isUIFullView = props.isUIFullView
	local isPortrait = props.isPortrait
	local v194 = p16:getTopBarHeight()
	local name = props.avatarRoute.opaque.name
	local u196 = p16.state.sceneShowing or not isPortrait

	if isDisabled then
		u196 = false
	end

	if FFlagAXMigrateAXToGlobalAutofocus then
		local forwardRef = props.forwardRef
		local v198 = not isSceneFullView and not isUIFullView

		if IsVRAppBuild() then
			v198 = v198 and name ~= AvatarScreen.LayeredClothingSort
		end

		return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, isPortrait and v194 or 0),
				ZIndex = -1,
				[Roact.Change.AbsoluteSize] = p16.onSceneResized,
				[Roact.Event.AncestryChanged] = p16.onSceneResized,
				[Roact.Ref] = p16.sceneFrameRef
			},
			animatedValues = p16.state.animatedValues,
			mapValuesToProps = mapValuesToProps,
			springOptions = t2,
			onComplete = function() -- line: 622
				-- upvalues: p16 (copy)
				p16.onTransitionComplete()
			end
		}, {
			SceneUIContainer = Roact.createElement(SceneUIContainer, {
				globalGuiInset = p16.props.globalGuiInset,
				statusBarHeight = if not GetFFlagAXFixRobuxBalanceButtonPositionSecond() then nil else p16.props.statusBarHeight,
				changeViewFunction = props.changeViewFunction,
				isVisible = u196,
				row1ChildrenVisible = v198,
				showRobuxBalance = props.showRobuxBalance,
				[Roact.Ref] = forwardRef
			}),
			SceneInteractionFrame = if not v77 then if not IsVRAppBuild() then Roact.createElement(SceneInteractionFrame) else nil else nil,
			AvatarLoadingSpinner = if not IsVRAppBuild() then Roact.createElement(AvatarLoadingSpinner) else nil,
			VRAvatarEditorNavBar = if not IsVRAppBuild() then nil else Roact.createElement(VRAvatarEditorNavBar, {
				currentPage = name,
				navigation = props.navigation
			}),
			SceneUi = props.sceneUi
		})
	end

	return RoactGamepad.withFocusController(function(p17) -- line: 652
		-- upvalues: props (copy), isSceneFullView (copy), isUIFullView (copy), IsVRAppBuild (copy), name (copy), AvatarScreen (copy), Roact (copy), SpringAnimatedItem (copy), isPortrait (copy), v194 (copy), p16 (copy), mapValuesToProps (copy), t2 (copy), Focusable (copy), SceneUIContainer (copy), GetFFlagAXFixRobuxBalanceButtonPositionSecond (copy), u196 (ref), v77 (copy), SceneInteractionFrame (copy), AvatarLoadingSpinner (copy), VRAvatarEditorNavBar (copy)
		local forwardRef = props.forwardRef
		local v339 = not isSceneFullView and not isUIFullView

		if IsVRAppBuild() then
			v339 = v339 and name ~= AvatarScreen.LayeredClothingSort
		end

		return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, isPortrait and v194 or 0),
				ZIndex = -1,
				[Roact.Change.AbsoluteSize] = p16.onSceneResized,
				[Roact.Event.AncestryChanged] = p16.onSceneResized,
				[Roact.Ref] = p16.sceneFrameRef
			},
			animatedValues = p16.state.animatedValues,
			mapValuesToProps = mapValuesToProps,
			springOptions = t2,
			onComplete = function() -- line: 680
				-- upvalues: p16 (copy), p17 (copy)
				p16.onTransitionComplete(p17)
			end
		}, {
			SceneUIContainer = Roact.createElement(Focusable[SceneUIContainer], {
				globalGuiInset = p16.props.globalGuiInset,
				statusBarHeight = if not GetFFlagAXFixRobuxBalanceButtonPositionSecond() then nil else p16.props.statusBarHeight,
				changeViewFunction = props.changeViewFunction,
				isVisible = u196,
				row1ChildrenVisible = v339,
				showRobuxBalance = props.showRobuxBalance,
				[Roact.Ref] = forwardRef,
				NextSelectionDown = props.NextSelectionDown,
				NextSelectionLeft = props.NextSelectionLeft,
				NextSelectionUp = props.NextSelectionUp
			}),
			SceneInteractionFrame = if not v77 then if not IsVRAppBuild() then Roact.createElement(SceneInteractionFrame) else nil else nil,
			AvatarLoadingSpinner = if not IsVRAppBuild() then Roact.createElement(AvatarLoadingSpinner) else nil,
			VRAvatarEditorNavBar = if not IsVRAppBuild() then nil else Roact.createElement(VRAvatarEditorNavBar, {
				currentPage = name,
				navigation = props.navigation
			}),
			SceneUi = props.sceneUi
		})
	end)
end
function v125.renderWithStyle(p18, _) -- line: 714
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), FFlagAXEnableManualSaving (copy), GetFFlagAXEnableCategoryPills (copy), AvatarScreen (copy), v122 (copy), v121 (copy), FFlagAXCatalogOffersBannerEnabled (copy), Constants2 (copy), FFlagEnableBottomNavOnMarketplace (copy), Cryo (copy), FFlagAXMISEnableMultiShopping (copy), Roact (copy), AdaptiveScrollingView (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), FFlagAXSlotsPeekViewScrollFix (copy), FFlagAXHideMenuOnScroll (copy), FFlagAXAvatarTimeoutFlow (copy), React (copy), TimeoutBanner (copy), FFlagAppIaScopedScrollAway (copy), FFlagEnableLeftNavOnConsole (copy), v98 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Foundation (copy), InsetBackground (copy), SaveButton (copy), FullViewEntryButton (copy), SceneButtons (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), SlotControlBar (copy), FFlagAXResetAvatarButton (copy), QuickButtons (copy), FFlagAXMoveRobuxBalanceButtonLower (copy), Responsive (copy), FFlagAXShowHeadAdjustmentInRightControlBar (copy), FFlagAXFixRobuxButtonShowingInFullView (copy), RobuxBalance (copy), FFlagAXMoveContextualActionButtons (copy), IconOnlyMenu (copy), MenuItemEnum (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), FFlagAXFixContextualActionVisibility (copy), ContextualActions (copy), FFlagAXFixControlBarSubMenuOverlap (copy), UndoRedoBar (copy), IsVRAppBuild (copy), AvatarVRPanelWrapper (copy), VRAvatarRotateHandler (copy), tutils (copy), GetFFlagLuaAppEnableTopBanner (copy), v82 (copy), FFlagAXMigrateQuickButtonsToGlobalAutoFocus (copy), BottomInsetBackground (copy), MultiTryOnBottomBar (copy), NamedRefConstants (copy), FFlagStackedBottomNavMarketplaceCTA (copy), CheckoutActionBarContainer (copy), v77 (copy), SceneInteractionFrame (copy), FFlagAXResetAvatarButtonExposureLogging (copy), OnFocusExperimentExposureLogger (copy), AppUserLayers (copy)
	local props = p18.props
	local allowAdaptiveScrolling = props.allowAdaptiveScrolling
	local bottomBarEnabled = props.bottomBarEnabled
	local globalGuiInset = props.globalGuiInset
	local isPortrait = props.isPortrait
	local v206 = p18:getTopBarHeight()
	local tokens = props.tokens
	local isTimedOut = props.isTimedOut
	local v209 = if not GetFFlagAXEnableSlotBasedEditor() then nil else props.showUndoRedo
	local v210 = if not GetFFlagAXEnableSlotBasedEditor() or not FFlagAXEnableManualSaving then nil else props.showSaveButton
	local v211 = not bottomBarEnabled and globalGuiInset.bottom > 0
	local v212 = p18:calculateSceneSize()
	local avatarRoute = props.avatarRoute
	local v214 = nil

	if GetFFlagAXEnableCategoryPills() then
		v214 = if props.avatarRoute.opaque.name ~= AvatarScreen.Catalog then v121 else v122
	end

	local v215 = nil
	local v216 = nil

	if FFlagAXCatalogOffersBannerEnabled then
		local name = avatarRoute.opaque.name

		v215 = name == AvatarScreen.Catalog or name == AvatarScreen.CatalogSearch
		v216 = ((if not GetFFlagAXEnableCategoryPills() then v121 else (if name ~= AvatarScreen.Catalog then v121 else v122))) + ((not v215 or not p18.state.catalogOffersBannerPeekHeaderBackgroundActive) and 0 or Constants2.CatalogOffersBannerPeekClosedExtraHeight)
	end

	local v218 = (not FFlagEnableBottomNavOnMarketplace or (not isPortrait or not tokens)) and 0 or tokens.Size.Size_1600
	local v219 = not Cryo.isEmpty(props.tryOnItems) and (not props.isSceneFullView or false)

	if props.lookId ~= nil then
		v219 = not not FFlagAXMISEnableMultiShopping and (avatarRoute.opaque.name ~= AvatarScreen.MySharedAvatars and v219)
	end

	local v220 = if props.showMultiTryOnBottomBar then v219 else false
	local v221 = nil
	local v222 = nil

	if allowAdaptiveScrolling then
		v221 = p18:calculateFullHeight()
		v222 = v221 - p18:calculatePortraitSceneHeight()
	end

	local t3 = {
		TopBar = not isPortrait and props.topBar,
		Items = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 1, if not isPortrait then -v206 else 0)
		}, if not allowAdaptiveScrolling or not isPortrait then if not FFlagAXAvatarTimeoutFlow or not props.tokens then props.children else {
			ScrollingView = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, not FFlagEnableLeftNavOnConsole and 0 or props.deviceSafePadding.bottom),
				BorderSizePixel = if not v98 then nil else 0,
				BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then props.tokens.Semantic.Color.Background.Contrast else props.tokens.Color.Surface.Surface_100)).Color3,
				BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then props.tokens.Semantic.Color.Background.Contrast else props.tokens.Color.Surface.Surface_100)).Transparency
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Banner = if not FFlagAXAvatarTimeoutFlow or not isTimedOut then nil else React.createElement(TimeoutBanner),
				Content = Roact.createElement(Foundation.View, {
					tag = "size-full-full",
					LayoutOrder = 1
				}, props.children)
			})
		} else {
			AdaptiveScrollingView = Roact.createElement(AdaptiveScrollingView, {
				fullHeight = v221,
				midHeight = v222,
				alwaysShowingHeight = ((if not FFlagAXCatalogOffersBannerEnabled then (if not GetFFlagAXEnableCategoryPills() then v121 else v214) else v216)) + (not FFlagEnableBottomNavOnMarketplace and 0 or v218),
				topBarHeight = props.topBarHeight,
				fullHeightOptions = if not props.adaptiveScrollingProps then nil else props.adaptiveScrollingProps.fullHeightOptions,
				enableExpandPeekViewOnUpwardScroll = if not FFlagAXExpandPeekViewOnFirstScroll or not props.adaptiveScrollingProps then nil else props.adaptiveScrollingProps.enableExpandPeekViewOnUpwardScroll,
				disableViewChangeByScroll = if not FFlagAXSlotsPeekViewScrollFix then nil else props.disableScrollViewBindings,
				enableAnimatedVisibility = if not FFlagAXHideMenuOnScroll or not props.adaptiveScrollingProps then nil else props.adaptiveScrollingProps.enableAnimatedVisibility,
				peekHeaderUsesElevatedBackground = if not FFlagAXCatalogOffersBannerEnabled then nil else v215 or FFlagAXAvatarTimeoutFlow and isTimedOut == true,
				peekHeaderBackgroundActive = if not FFlagAXCatalogOffersBannerEnabled or not v215 then nil else p18.state.catalogOffersBannerPeekHeaderBackgroundActive,
				onPeekHeaderBackgroundActiveChanged = if not FFlagAXCatalogOffersBannerEnabled or not v215 then nil else p18.onCatalogOffersBannerPeekHeaderBackgroundActiveChanged,
				banner = if not FFlagAXAvatarTimeoutFlow or not isTimedOut then nil else React.createElement(TimeoutBanner),
				onCanvasYDelta = if not FFlagAppIaScopedScrollAway or not FFlagEnableBottomNavOnMarketplace then nil else p18.onSheetCanvasYDelta,
				onScrollTouchEnded = if not FFlagAppIaScopedScrollAway or not FFlagEnableBottomNavOnMarketplace then nil else p18.onSheetScrollTouchEnded
			}, props.children)
		}),
		InsetBackground = if not FFlagEnableLeftNavOnConsole or isPortrait then nil else React.createElement(InsetBackground, {
			directions = {
				top = true
			}
		})
	}
	local v224 = p18:renderSceneFrame()
	local v229

	if GetFFlagAXEnableSlotBasedEditor() and tokens then
		local v225 = p18:calculatePortraitSceneHeight()
		local uDim2 = UDim2.new(1, -tokens.Size.Size_500, 0, v225 + v206 - tokens.Size.Size_400)

		if not isPortrait then
			local Size_500 = tokens.Size.Size_500

			if FFlagAXMISEnableMultiShopping then
				local bottomBarHeight = p18.state.bottomBarHeight

				if props.isTryingOnItems and bottomBarHeight then
					Size_500 += bottomBarHeight
				end
			elseif props.isTryingOnItems and props.multiTryOnBottomBarRef and props.multiTryOnBottomBarRef.current then
				Size_500 += props.multiTryOnBottomBarRef.current.AbsoluteSize.Y
			end

			uDim2 = UDim2.new(1, -tokens.Size.Size_500, 1, -Size_500)
		end

		v229 = Roact.createElement(Foundation.View, {
			tag = "auto-xy anchor-bottom-right row",
			Position = uDim2
		}, {
			SaveButton = if not v210 or props.isSceneFullView then nil else Roact.createElement(SaveButton, {}),
			FullViewEntryButton = if not props.isSceneFullView or isPortrait then nil else React.createElement(FullViewEntryButton, {
				isUIFullView = props.isUIFullView,
				isSceneFullView = props.isSceneFullView,
				changeViewFunction = props.changeViewFunction
			})
		})
	else
		v229 = if not allowAdaptiveScrolling or not isPortrait then Roact.createElement(SceneButtons, {
			ZIndex = 3,
			sceneHeight = v212,
			isUIFullView = props.isUIFullView,
			isSceneFullView = props.isSceneFullView,
			changeViewFunction = props.changeViewFunction
		}) else nil
	end

	local v230 = if not GetFFlagAXEnableSlotBasedEditor() or not tokens then Roact.createElement(QuickButtons, {
		isUIFullView = props.isUIFullView,
		isSceneFullView = props.isSceneFullView,
		ref = if not FFlagAXMigrateAXToGlobalAutofocus then props.quickButtonsRef else nil,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then props.defaultChildRef else nil
	}) else React.createElement(Foundation.View, {
		tag = "auto-xy col gap-small",
		ref = if not FFlagAXMigrateAXToGlobalAutofocus then props.quickButtonsRef else nil,
		SelectionGroup = not not FFlagAXMigrateAXToGlobalAutofocus or nil,
		Position = if not isPortrait then UDim2.new(Constants2.LandscapeNavWidth, tokens.Size.Size_700, 0, v206) else UDim2.fromOffset(tokens.Size.Size_500, v206),
		Visible = not props.isSceneFullView,
		ZIndex = p18.quickButtonsZIndexBinding
	}, {
		ControlBar = React.createElement(SlotControlBar, {
			LayoutOrder = 1,
			isUIFullView = props.isUIFullView,
			isSceneFullView = props.isSceneFullView,
			showControlBar = props.showControlBar,
			showUndoRedo = v209 and (not not FFlagAXResetAvatarButton or not isPortrait),
			onActiveMenuItemChanged = p18.onActiveControlBarMenuItemChanged,
			NextSelectionLeft = props.defaultChildRef
		})
	})
	local v231 = nil

	if FFlagAXMoveRobuxBalanceButtonLower and p18.props.showRobuxBalance and p18.props.tokens then
		local Size_700 = p18.props.tokens.Size.Size_700

		if isPortrait then
			Size_700 = p18.props.tokens.Size.Size_500
		elseif p18.props.preferredInput == Responsive.Input.Directional then
			Size_700 = p18.props.tokens.Size.Size_200
		end

		local s2 = "auto-xy anchor-top-right"

		if FFlagAXShowHeadAdjustmentInRightControlBar then
			s2 ..= " col gap-small align-x-right"
		end

		v231 = React.createElement(Foundation.View, {
			tag = s2,
			Position = UDim2.new(1, -Size_700, 0, if not p18.props.isSpatial then p18.props.topBarHeight else 0)
		}, {
			RobuxBalance = if not if not FFlagAXFixRobuxButtonShowingInFullView then not props.isSceneFullView else not (props.isSceneFullView or props.isUIFullView) then nil else React.createElement(RobuxBalance, {
				ref = p18.robuxBalanceRef,
				NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then props.quickButtonsRef else nil
			}),
			WhiteSpace = if FFlagAXMoveContextualActionButtons or not FFlagAXShowHeadAdjustmentInRightControlBar then nil else React.createElement(Foundation.View, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, p18.props.tokens.Size.Size_1300)
			}),
			HeadAdjustmentButton = if FFlagAXMoveContextualActionButtons or (not FFlagAXShowHeadAdjustmentInRightControlBar or not p18.props.supportsHeadShapes) then nil else React.createElement(IconOnlyMenu, {
				LayoutOrder = 3,
				items = {{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.CustomizeHead,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
					iconSize = p18.props.tokens.Size.Size_600,
					onActivated = p18.props.onCustomizeHeadActivated
				}}
			})
		})
	end

	local v234 = nil

	if FFlagAXMoveContextualActionButtons and tokens then
		local v235 = p18:calculatePortraitSceneHeight() / 2 + v206

		v234 = React.createElement(Foundation.View, {
			tag = "auto-xy anchor-center-right",
			Position = UDim2.new(1, -tokens.Size.Size_500, 0, v235),
			Visible = not FFlagAXFixContextualActionVisibility or not (props.isSceneFullView or props.isUIFullView)
		}, {
			ContextualActions = if not p18.props.isPortrait then nil else React.createElement(ContextualActions, {
				LayoutOrder = 1
			})
		})
	end

	local v236 = nil

	if GetFFlagAXEnableSlotBasedEditor() and tokens then
		local v237 = v209 and (not props.isSceneFullView and (isPortrait and (not FFlagAXResetAvatarButton and not (FFlagAXFixControlBarSubMenuOverlap and props.isUIFullView))))
		local v238 = p18:calculatePortraitSceneHeight()
		local uDim2 = UDim2.fromOffset(tokens.Size.Size_500, v238 + v206 - tokens.Size.Size_400)

		if not isPortrait then
			local Size_500 = tokens.Size.Size_500

			if FFlagAXMISEnableMultiShopping then
				local bottomBarHeight = p18.state.bottomBarHeight

				if props.isTryingOnItems and bottomBarHeight then
					Size_500 += bottomBarHeight
				end
			elseif props.isTryingOnItems and props.multiTryOnBottomBarRef and props.multiTryOnBottomBarRef.current then
				Size_500 += props.multiTryOnBottomBarRef.current.AbsoluteSize.Y
			end

			uDim2 = UDim2.new(Constants2.LandscapeNavWidth, tokens.Size.Size_500, 1, -Size_500)
		end

		v236 = React.createElement(Foundation.View, {
			tag = "auto-xy anchor-bottom-left",
			Position = uDim2
		}, {
			UndoRedoBarPortrait = if not v237 then nil else React.createElement(UndoRedoBar)
		})
	end

	local v242 = if not IsVRAppBuild() then Roact.createFragment({
		SceneFrame = v224,
		QuickButtons = v230,
		BottomRightButtons = v229,
		TopRightButtons = if not FFlagAXMoveRobuxBalanceButtonLower then nil else v231,
		MiddleRightButtons = if not FFlagAXMoveContextualActionButtons then nil else v234,
		BottomLeftButtons = if not GetFFlagAXEnableSlotBasedEditor() then nil else v236
	}) else Roact.createElement(AvatarVRPanelWrapper, {
		roundedCornersFrame = false,
		panelPlacement = "Center"
	}, {
		SceneFrame = v224,
		QuickButtons = v230,
		BottomRightButtons = v229,
		GamepadHandler = if avatarRoute.current.name == AvatarScreen.LayeredClothingSort then nil else Roact.createElement(VRAvatarRotateHandler),
		TopRightButtons = if not FFlagAXMoveRobuxBalanceButtonLower then nil else v231,
		MiddleRightButtons = if not FFlagAXMoveContextualActionButtons then nil else v234,
		BottomLeftButtons = if not GetFFlagAXEnableSlotBasedEditor() then nil else v236
	})
	local v243 = tutils.fieldCount(props.tryOnItems) > 1

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, not GetFFlagLuaAppEnableTopBanner() and 0 or -props.globalGuiInset.top),
		Size = UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		ref = if not FFlagAXMigrateAXToGlobalAutofocus then nil else props.itemFrameRef
	}, {
		TopBar = isPortrait and props.topBar,
		ItemsFrame = if not IsVRAppBuild() then Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = if not not isPortrait and not allowAdaptiveScrolling then nil else 2,
			[Roact.Change.AbsoluteSize] = p18.onNavItemsFrameResized,
			[Roact.Ref] = p18.navItemsFrameRef,
			Visible = if not FFlagAXMigrateAXToGlobalAutofocus then nil else p18.props.isItemFrameVisible
		}, t3) else Roact.createElement(AvatarVRPanelWrapper, {
			roundedCornersFrame = true,
			panelPlacement = "Left",
			visible = avatarRoute.current.name ~= AvatarScreen.LayeredClothingSort
		}, t3),
		OverlayedUI = if not FFlagAXMigrateAXToGlobalAutofocus then v242 else if not v82 then if not props.isQuickButtonsVisible then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ref = props.quickButtonsRef,
			Size = UDim2.fromScale(1, 1),
			ZIndex = if not FFlagAXFixControlBarSubMenuOverlap then nil else 3
		}, v242) else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ref = props.quickButtonsRef,
			Size = UDim2.fromScale(1, 1),
			Visible = props.isQuickButtonsVisible,
			SelectionGroup = not not FFlagAXMigrateQuickButtonsToGlobalAutoFocus or nil,
			ZIndex = if not FFlagAXFixControlBarSubMenuOverlap then nil else 3
		}, v242),
		BottomInsetBackground = if not v211 then nil else Roact.createElement(BottomInsetBackground, {
			globalGuiInset = globalGuiInset
		}),
		MultiTryOnBottomBar = if not FFlagAXMISEnableMultiShopping or not v243 then Roact.createElement(MultiTryOnBottomBar, {
			bottomBarRef = props.multiTryOnBottomBarRef,
			NextSelectionLeft = props.namedRefs[props.avatarRoute.opaque.name .. NamedRefConstants.ItemsList],
			Visible = if not FFlagAXMigrateAXToGlobalAutofocus then v220 else props.isOpaqueRouteMatchingCurrentRoute and v220,
			isConsoleWithGamepad = p18:isConsoleWithGamepad(),
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			onAbsoluteSizeChanged = if not FFlagAXMISEnableMultiShopping then nil else p18.onBottomBarAbsoluteSizeChanged,
			footerVisibilityBinding = if not FFlagStackedBottomNavMarketplaceCTA then nil else p18.ctaBottomNavOffsetBinding
		}) else nil,
		CheckoutActionBar = if not FFlagAXMISEnableMultiShopping or (not props.isOpaqueRouteMatchingCurrentRoute or not v243) then nil else React.createElement(CheckoutActionBarContainer, {
			ref = props.multiTryOnBottomBarRef,
			onAbsoluteSizeChanged = p18.onBottomBarAbsoluteSizeChanged,
			Visible = v220,
			footerVisibilityBinding = if not FFlagStackedBottomNavMarketplaceCTA then nil else p18.ctaBottomNavOffsetBinding
		}),
		FullSceneInteractionFrame = if not v77 then nil else if not p18.props.isSpatial then Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = -2,
			Size = UDim2.fromScale(1, 1)
		}, {
			SceneInteractionFrame = Roact.createElement(SceneInteractionFrame)
		}) else nil,
		OnFocusExperimentExposureLogger = if not FFlagAXResetAvatarButtonExposureLogging then nil else Roact.createElement(OnFocusExperimentExposureLogger, {
			ixpTests = {},
			flagIXPTestLayers = { if not FFlagAXResetAvatarButtonExposureLogging then nil else AppUserLayers.AvatarExperienceUAAllViews }
		})
	})
end
function v125.render(p20) -- line: 1220
	-- upvalues: withStyle (copy), Roact (copy), v43 (copy)
	return withStyle(function(p21) -- line: 1221
		-- upvalues: Roact (copy), v43 (copy), p20 (copy)
		return Roact.createElement(v43, nil, {
			AvatarExperienceView = p20:renderWithStyle(p21)
		})
	end)
end
function v125.didUpdate(p22, p23) -- line: 1228
	local props = p22.props
	local isUIFullView = props.isUIFullView
	local sceneShowing = p22.state.sceneShowing

	if not isUIFullView and not sceneShowing then
		p22:setState({
			sceneShowing = true
		})
	end

	local isPortrait = p23.isPortrait
	local isPortrait2 = props.isPortrait

	if isPortrait2 ~= isPortrait then
		if isPortrait2 and isUIFullView then
			p22:setState({
				sceneShowing = false
			})
		elseif not isPortrait and isUIFullView then
			p22:setState({
				sceneShowing = true
			})
		end

		p22:instantResize()
	end

	if props.isDisabled then
		p22:instantResize()
	end

	if props.screenSize ~= p23.screenSize then
		p22:instantResize()
	end

	if props.topBarHeight ~= p23.topBarHeight then
		p22:instantResize()
	end

	local v252, v253 = p22:calculateSceneSize()

	if v252 ~= p22.state.animatedValues.height or v253 ~= p22.state.animatedValues.width then
		p22:setState({
			animatedValues = {
				height = v252,
				width = v253
			}
		})
	end
end
function v125.didMount(p24) -- line: 1281
	p24:instantResize()

	local v255, v256 = p24:calculateSceneSize()

	p24:setState({
		animatedValues = {
			height = v255,
			width = v256
		}
	})
end

local v128 = withLastInputGroup((RoactRodux.connect(mapStateToProps, nil)(v125)))
local v129 = withNamedRefs((withAppRoute((RoactNavigation.withNavigation(v128)))))
local u130 = IxpUtils.connectTestVariables({
	universalAppCameraEnabled = UniversalAppCameraIXPTest.EnabledForUser
})(v129)

local function selectTryingOnItems(p25) -- line: 1308
	-- upvalues: Cryo (copy)
	return not Cryo.isEmpty(p25.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
end
local function selectEquippedDynamicHeadAndTryOnBundle(p26) -- line: 1313
	-- upvalues: Constants2 (copy), SelectOutfitTryOnMostRecentAssetId (copy), FFlagDynamicHeadsMigration (copy), FFlagHeadRefinementFacialAnimationToggle (copy)
	local v259 = nil
	local v260 = nil
	local v261 = p26.AvatarExperience and (p26.AvatarExperience.AvatarEditor and (p26.AvatarExperience.AvatarEditor.Character and p26.AvatarExperience.AvatarEditor.Character.EquippedAssets))

	if v261 and v261[Constants2.AssetTypeIdStrings.DynamicHead] then
		v259 = next(v261[Constants2.AssetTypeIdStrings.DynamicHead])
	end

	local v262 = p26.AvatarExperience and (p26.AvatarExperience.Common and p26.AvatarExperience.Common.AssetInfos)

	if v259 and v262 then
		v260 = v262[v259]
	end

	local v263, _ = SelectOutfitTryOnMostRecentAssetId(p26, Constants2.AssetTypeIdStrings.DynamicHead)
	local v265 = nil

	if v263 and v262 then
		v265 = v262[v263]
	end

	local v266 = false

	if FFlagDynamicHeadsMigration then
		local v267 = p26.AvatarExperience.AvatarScene.OutfitTryOn and p26.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local itemId = nil
		local v269 = nil
		local LookId = p26.AvatarExperience.AvatarScene.OutfitTryOn.LookId

		if v267 and v263 then
			for _, v272 in v267 do
				if v272.itemType ~= Constants2.ItemType.Bundle or not v272.bundleInfo then
					if v272.itemType ~= Constants2.ItemType.Asset or v263 ~= v272.itemId then
						continue
					end

					itemId = v272.itemId
					v269 = v272

					break
				end

				if v272.bundleInfo[v263] then
					itemId = v272.itemId
					v269 = v272

					break
				end
			end
		end

		local v273 = p26.AvatarExperience and (p26.AvatarExperience.Common and p26.AvatarExperience.Common.BundleInfos)
		local v274 = nil

		if itemId and v273 then
			v274 = v273[itemId]
		end

		local v275 = nil

		if v269 and v269.itemSubType == Constants2.BundleTypeIdStrings.DynamicHead and v269.bundleInfo then
			for v276, _ in v269.bundleInfo do
				local v278 = if not v262 then nil else v262[v276]

				if v278 and v278.supportsHeadShapes == true then
					v275 = true

					break
				end
			end
		end

		if v265 and v265.supportsHeadShapes ~= nil then
			v266 = v265.supportsHeadShapes
		elseif v274 and v274.supportsHeadShapes ~= nil then
			v266 = v274.supportsHeadShapes
		elseif v275 ~= nil then
			v266 = v275
		elseif v263 == nil and v260 and v260.supportsHeadShapes ~= nil then
			v266 = v260.supportsHeadShapes
		elseif LookId then
			v266 = false
		end
	elseif v265 then
		v266 = v265.supportsHeadShapes ~= nil and v265.supportsHeadShapes
	elseif v260 then
		v266 = v260.supportsHeadShapes ~= nil and v260.supportsHeadShapes
	end

	return {
		equippedDynamicHeadId = v259,
		equippedDynamicHeadInfo = v260,
		tryOnAssetId = v263,
		tryOnDynamicHeadAssetInfo = v265,
		supportsHeadShapes = v266,
		hasDynamicHead = if not FFlagHeadRefinementFacialAnimationToggle then nil else v259 ~= nil or v263 ~= nil
	}
end

return Roact.forwardRef(function(t4: {[any]: any}, p27) -- line: 1451
	-- upvalues: FFlagAXShowHeadAdjustmentInRightControlBar (copy), useNavigation (copy), FFlagAXMoveRobuxBalanceButtonLower (copy), GetFFlagAXEnableSlotBasedEditor (copy), FFlagAXAvatarTimeoutFlow (copy), useTokens (copy), getTimeoutStatusStore (copy), useSignalState (copy), Responsive (copy), useSelector (copy), selectTryingOnItems (copy), getUseSelectorDeepEquals (copy), FFlagAXMoveContextualActionButtons (copy), selectEquippedDynamicHeadAndTryOnBundle (copy), React (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useAvatarRoute (copy), v99 (copy), t1 (copy), selectQuickItemsVisible (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXModeratedItemsFlow (copy), useDispatch (copy), useAvatarSaveContext (copy), useEffectOnMount (copy), RemoveUnavailableEquippedAssets (copy), FFlagHeadRefinementFacialAnimationToggle (copy), FFlagEnableLeftNavOnConsole (copy), Display (copy), Roact (copy), u130 (ref), Cryo (copy)
	local u281 = if not FFlagAXShowHeadAdjustmentInRightControlBar then nil else useNavigation()
	local v282 = if not FFlagAXMoveRobuxBalanceButtonLower and (not GetFFlagAXEnableSlotBasedEditor() and not FFlagAXAvatarTimeoutFlow) then nil else useTokens()
	local v283 = if not FFlagAXAvatarTimeoutFlow then nil else getTimeoutStatusStore(false)
	local v284 = if not v283 then nil else useSignalState(v283.getIsTimedOut)
	local v285 = if not FFlagAXMoveRobuxBalanceButtonLower then nil else Responsive.useIsSpatial()
	local v286 = if not FFlagAXMoveRobuxBalanceButtonLower then nil else Responsive.usePreferredInput()
	local v287 = if not GetFFlagAXEnableSlotBasedEditor() then nil else useSelector(selectTryingOnItems, getUseSelectorDeepEquals())
	local v288 = if FFlagAXMoveContextualActionButtons or not FFlagAXShowHeadAdjustmentInRightControlBar then nil else useSelector(selectEquippedDynamicHeadAndTryOnBundle)
	local v289 = if FFlagAXMoveContextualActionButtons or not FFlagAXShowHeadAdjustmentInRightControlBar then nil else React.useCallback(function() -- line: 1473
		-- upvalues: u281 (ref), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		u281.navigate(AvatarScreen.HeadRefinement)
		SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClick(MenuItemEnum.AvatarRefinement.CustomizeHead)
	end, { u281 })
	local v290 = nil
	local v291 = nil
	local v292 = nil
	local v293 = nil
	local v294 = nil

	if FFlagAXMigrateAXToGlobalAutofocus then
		v293 = React.useRef(nil)

		local v295 = React.useRef(nil)

		v292 = t4.quickButtonsRef or v295

		if not FFlagAXShowHeadAdjustmentInRightControlBar then
			u281 = useNavigation()
		end

		local v296 = useAvatarRoute()
		local v297 = if not u281 or not u281.state then nil else u281.state.routeName
		local name = v296.opaque.name
		local name2 = v296.current.name

		v294 = (not v99 or v296.isVisible) and (v297 == name and not t1[name2])

		local v300 = useSelector(selectQuickItemsVisible)

		v291 = (not v99 or v296.isVisible) and v300
		v290 = v297 == name2
		useFocusNavigableSurfaceRegistryConnection(v293.current, FocusNavigableSurfaceIdentifierEnum.SubRouterView, v294)
		useFocusNavigableSurfaceRegistryConnection(v292.current, FocusNavigableSurfaceIdentifierEnum.Auxiliary, v291)
	end

	if FFlagAXMISEnableMultiShopping then
		if not FFlagAXShowHeadAdjustmentInRightControlBar then
			u281 = useNavigation()
		end

		local v301 = useAvatarRoute()
		local v302 = u281 and (u281.state and u281.state.routeName)
		local v303 = v301 and (v301.current and v301.current.name)

		v290 = v302 and v302 == v303
	end

	if FFlagAXModeratedItemsFlow then
		if not FFlagAXShowHeadAdjustmentInRightControlBar then
			u281 = useNavigation()
		end

		local v304 = useDispatch()
		local v305 = useAvatarSaveContext()

		useEffectOnMount(function() -- line: 1536
			-- upvalues: v304 (copy), RemoveUnavailableEquippedAssets (copy), u281 (ref), v305 (copy)
			v304(RemoveUnavailableEquippedAssets(u281, v305.trySaveAvatar))
		end)
	end

	local v306 = nil

	if not FFlagAXMoveContextualActionButtons and FFlagAXShowHeadAdjustmentInRightControlBar then
		v306 = if not FFlagHeadRefinementFacialAnimationToggle then not not v288 and (v288.supportsHeadShapes or false) else v288 and v288.hasDynamicHead
	end

	local v307 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return Roact.createElement(u130, Cryo.Dictionary.join(t4, {
		controlBarFocusAnimation = nil,
		forwardRef = p27,
		tokens = v282,
		isSpatial = v285,
		navigation = if not FFlagAXShowHeadAdjustmentInRightControlBar then nil else u281,
		onCustomizeHeadActivated = if FFlagAXMoveContextualActionButtons or not FFlagAXShowHeadAdjustmentInRightControlBar then nil else v289,
		supportsHeadShapes = if FFlagAXMoveContextualActionButtons or not FFlagAXShowHeadAdjustmentInRightControlBar then nil else v306,
		preferredInput = v286,
		isTryingOnItems = v287,
		itemFrameRef = if not FFlagAXMigrateAXToGlobalAutofocus then nil else v293,
		quickButtonsRef = if not FFlagAXMigrateAXToGlobalAutofocus then nil else v292,
		isQuickButtonsVisible = if not FFlagAXMigrateAXToGlobalAutofocus then nil else v291,
		isOpaqueRouteMatchingCurrentRoute = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMISEnableMultiShopping then nil else v290,
		isItemFrameVisible = if not FFlagAXMigrateAXToGlobalAutofocus then nil else v294,
		isTimedOut = if not FFlagAXAvatarTimeoutFlow then nil else v284,
		deviceSafePadding = if not FFlagEnableLeftNavOnConsole then nil else v307
	}))
end)
