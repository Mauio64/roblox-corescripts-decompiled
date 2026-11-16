local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useEffectOnMount
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module2 = require("@luauforge/deferred/goR")
local module3 = require("@luauforge/bundled/gfT")
local module4 = require("@luauforge/bundled/eeo")
local useFocusNavigableSurfaceRegistryConnection = module4.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local tutils = require(CorePackages.Packages.tutils)

local UIBlox = require(CorePackages.Packages.UIBlox)

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local module8 = require("@luauforge/bundled/dwA")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local withStyle = UIBlox.Style.withStyle
local module9 = require("@luauforge/deferred/ggF")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local insetBackground = require("@game/CorePackages/Workspace/Packages/AppBlox").InsetBackground

local module10 = require("@luauforge/bundled/dMx")
local module11 = require("@luauforge/bundled/gfn")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local module13 = require("@luauforge/deferred/goS")

local module14 = require("@luauforge/deferred/goT")

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module15 = require("@luauforge/deferred/ggH")

local module16 = require("@luauforge/bundled/dUd")

local module17 = require("@luauforge/deferred/goU")
local module18 = require("@luauforge/deferred/goI")
local module19 = require("@luauforge/bundled/goB")
local module20 = require("@luauforge/deferred/goW")
local module21 = require("@luauforge/deferred/goX")
local module22 = require("@luauforge/bundled/goD")
local module23 = require("@luauforge/deferred/gpd")
local module24 = require("@luauforge/deferred/gpf")
local module25 = require("@luauforge/deferred/gpg")
local module26 = require("@luauforge/deferred/gmh")
local module27 = require("@luauforge/deferred/gff")
local module28 = require("@luauforge/deferred/gph")
local module29 = require("@luauforge/deferred/gpk")
local module30 = require("@luauforge/deferred/gma")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local timeoutBanner = AvatarExperienceCommon.Components.TimeoutBanner

local photoboothMomentsButton = require("@luauforge/deferred/gpl").Components.PhotoboothMomentsButton

local photoboothMomentsFullViewButton = require("@luauforge/deferred/gpl").Components.PhotoboothMomentsFullViewButton
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore

local checkoutActionBarContainer = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Checkout.CheckoutActionBarContainer

local module31 = require("@luauforge/deferred/gqf")

require("@luauforge/bundled/dHK")
local module32 = require("@luauforge/deferred/gqg")
local module33 = require("@luauforge/deferred/gqh")
local module34 = require("@luauforge/deferred/gqI")
local undoRedoBar = module2.UndoRedoBar
local saveButton = module3.Components.SaveButton
local module35 = require("@luauforge/deferred/gpe")
local module36 = require("@luauforge/bundled/dMB")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

local getFFlagLuaAppEnableTopBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableTopBanner

local module37 = require("@luauforge/deferred/gpa")
local module38 = require("@luauforge/bundled/dOc")
local module39 = require("@luauforge/deferred/gpb")

local fFlagAXEnableManualSaving = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEnableManualSaving
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local isVRHiddenRobuxBalanceScreen = AvatarExperienceCommon.Utils.isVRHiddenRobuxBalanceScreen

local v6 = module38() and game:DefineFastFlag("FFlagAXEnableFullSceneInteractionFrame3", false)

local module40 = require("@luauforge/bundled/dMC")

local defineFastFlag = game:DefineFastFlag("AXFixConsoleFullSceneViewPosition", false)
local defineFastFlag2 = game:DefineFastFlag("AXQuickButtonsFrameShouldAlwaysExist", false)
local defineFastFlag3 = game:DefineFastFlag("AXFixSheetHeightForDeviceSafeInsets", false)
local shouldUseDeviceSafeInsets = module16.shouldUseDeviceSafeInsets
local fFlagAXAvatarPreviewPhotoboothMomentsButton = AvatarExperienceFlags.FFlagAXAvatarPreviewPhotoboothMomentsButton

local fFlagAXPhotoboothMomentsButtonUnderRobuxBalance = AvatarExperienceFlags.FFlagAXPhotoboothMomentsButtonUnderRobuxBalance
local fFlagAXPhotoboothMomentsButtonsEditorOnly = AvatarExperienceFlags.FFlagAXPhotoboothMomentsButtonsEditorOnly

local fFlagAXSlotsPeekViewScrollFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsPeekViewScrollFix
local fFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local fFlagAXShowHeadAdjustmentInRightControlBar = AvatarExperienceFlags.FFlagAXShowHeadAdjustmentInRightControlBar
local fFlagAXFixControlBarSubMenuOverlap = AvatarExperienceFlags.FFlagAXFixControlBarSubMenuOverlap
local fFlagAXResetAvatarButtonExposureLogging = AvatarExperienceFlags.FFlagAXResetAvatarButtonExposureLogging
local fFlagQRCodePageVisualRefresh = SharedFlags.FFlagQRCodePageVisualRefresh
local fFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace
local fFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local fFlagStackedBottomNavMarketplaceCTA = SharedFlags.FFlagStackedBottomNavMarketplaceCTA
local visibilityControl = require("@luauforge/bundled/dHu").VisibilityControl
local defineFastFlag4 = game:DefineFastFlag("AXFixLightThemeBorder", false)
local defineFastFlag5 = game:DefineFastFlag("AXDeregisterSurfacesWhenNotVisible", false)
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module41 = require("@luauforge/deferred/gqL")
local useAvatarSaveContext = require("@luauforge/bundled/gfT").Context.useAvatarSaveContext

local module42 = require("@luauforge/bundled/fuJ")

local fFlagAXExpandPeekViewOnFirstScroll = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXExpandPeekViewOnFirstScroll
local fFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local fFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local fFlagAXFixRobuxButtonShowingInFullView = AvatarExperienceFlags.FFlagAXFixRobuxButtonShowingInFullView
local fFlagAXHideRobuxBalanceInVR = AvatarExperienceFlags.FFlagAXHideRobuxBalanceInVR

local module43 = require("@luauforge/deferred/gqJ")
local set

if fFlagAXOutfitPageRevamp then
	set = {}
	set[avatarScreen.UpdateOutfitPage] = true
	set[avatarScreen.ManageOutfitPage] = true
else
	set = {}
	set[avatarScreen.UpdateOutfitPage] = true
	set[avatarScreen.ManageOutfitPage] = true
	set[avatarScreen.OutfitDetails] = true
end

local v7 = { dampingRatio = 1, frequency = 3.5 }

local v8 = module10.PeekHeaderHeight + (module38() and 0 or module10.MainNavHeight) + module10.SubNavHeight
local v9

if module40() or fFlagAXMoveCatalogFilterToL1Navigation then
	v9 = module10.PeekHeaderHeight + module10.CatalogMainNavHeight
else
	v9 = nil
end

local tenFootInterface = isTenFootInterface()

local function isPhotoboothMomentsButtonsPage(p2)
	return p2 == avatarScreen.AvatarEditor or module38() and p2 == avatarScreen.AvatarSwitcher
end

local function BottomCenterButtons(p2)
	local v10 = useTokens()
	local bottomOffset = p2.bottomOffset

	local v11 = React.useMemo(function()
		return UDim2.new(0.5, 0, 1, -(bottomOffset + v10.Size.Size_500))
	end, { bottomOffset, v10 })

	return React.createElement(Foundation.View, {
		tag = "auto-xy anchor-bottom-center",
		Position = v11
	}, {
		PhotoboothMomentsFullViewButton = React.createElement(photoboothMomentsFullViewButton)
	})
end

local function selectQuickItemsVisible(p2): boolean
	local itemDetailsPeekView = p2.AvatarExperience.Common.ItemDetailsPeekView
	local v10 = itemDetailsPeekView.viewState == peekViewState.Full
	local v11 = itemDetailsPeekView.tryOnViewState == peekViewState.Full

	return itemDetailsPeekView.tryOnManagerViewState ~= peekViewState.Full and not v10 and not v11
end

local extended = Roact.PureComponent:extend("AvatarExperienceView")

extended.defaultProps = {
	bottomBarEnabled = false,
	isDisabled = false,
	showRobuxBalance = true,
	showMultiTryOnBottomBar = true,
	showControlBar = true,
	itemDetailsPeekViewRefs = {}
}

local function mapStateToProps(data, p2)
	local v11 = (if fFlagEnableSplitPane then module11(data) else data.DeviceOrientation) == deviceOrientationMode.Portrait
	local topBarHeight = p2.topBar and data.TopBar.topBarHeight or 0
	local statusBarHeight = module37() and (p2.topBar and data.TopBar.statusBarHeight or 0) or nil

	local statusBarHeight2 = module14
		and p2.reserveTopBarOffset
		and module37()
		and (data.TopBar.statusBarHeight or 0)
		or statusBarHeight

	local v12 = {
		globalGuiInset = data.GlobalGuiInset,
		isPortrait = v11,
		screenSize = data.ScreenSize,
		topBarHeight = topBarHeight,
		storeTopBarHeight = data.TopBar.topBarHeight,
		tryOnItems = data.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lookId = data.AvatarExperience.AvatarScene.OutfitTryOn.LookId,
		statusBarHeight = 0
	}

	if not module37() then
		statusBarHeight2 = nil
	end

	v12.statusBarHeight = statusBarHeight2
	return v12
end

local function mapValuesToProps(p2)
	return {
		Size = UDim2.new(0, p2.width, 0, p2.height)
	}
end

function extended:init()
	local sceneSize, v10 = self:calculateSceneSize()

	self.state = {
		sceneShowing = true,
		isVerticallyOffscreen = false,
		animatedValues = { height = sceneSize, width = v10 },
		bottomBarHeight = 0
	}

	if fFlagAXCatalogOffersBannerEnabled then
		self.state = Cryo.Dictionary.join(self.state, {
			catalogOffersBannerPeekHeaderBackgroundActive = true
		})

		function self.onCatalogOffersBannerPeekHeaderBackgroundActiveChanged(p2)
			if self.state.catalogOffersBannerPeekHeaderBackgroundActive ~= p2 then
				self:setState({ catalogOffersBannerPeekHeaderBackgroundActive = p2 })
			end
		end
	end

	self.navItemsFrameRef = Roact.createRef()
	self.sceneFrameRef = Roact.createRef()
	local ref = if module39 then Roact.createRef() else nil
	self.robuxBalanceRef = ref

	if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then
		function self.onSheetCanvasYDelta(p2)
			visibilityControl.onTouchMoved(-p2)
		end
		function self.onSheetScrollTouchEnded()
			visibilityControl.onTouchEnded()
		end
	end

	if fFlagStackedBottomNavMarketplaceCTA then
		self.ctaBottomNavOffsetBinding = visibilityControl.getFooterBinding()
	end

	if module38() then
		local binding, v11 = React.createBinding(nil)
		self.quickButtonsZIndexBinding = binding
		self.setQuickButtonsZIndexBinding = v11

		function self.onActiveControlBarMenuItemChanged(p2, p3)
			if p3 then
				self.setQuickButtonsZIndexBinding(3)
			else
				self.setQuickButtonsZIndexBinding(nil)
			end
		end
	end

	function self.onTransitionComplete()
		local props = self.props
		local name = props.avatarRoute.current.name
		local isPortrait = props.isPortrait
		local isSceneFullView = props.isSceneFullView
		local isUIFullView = props.isUIFullView
		local sceneShowing = self.state.sceneShowing

		if isUIFullView and isPortrait and sceneShowing then
			self:setState({ sceneShowing = false })
		end

		if isPortrait or not isSceneFullView or name ~= avatarScreen.AvatarExperienceLandingPage then
			if self.state.isVerticallyOffscreen then
				self:setState({ isVerticallyOffscreen = false })
			end
		elseif not self.state.isVerticallyOffscreen then
			self:setState({ isVerticallyOffscreen = true })
		end
	end

	function self.onNavItemsFrameResized(p2)
		if self.sceneFrameRef.current then
			self.onSceneResized(self.sceneFrameRef.current)
		end
	end

	function self.onSceneResized(p2)
		local current = self.navItemsFrameRef.current

		if not current then
			return
		end

		local props = self.props
		local name = props.avatarRoute.current.name
		local isDisabled = props.isDisabled
		local isPortrait = props.isPortrait
		local screenSize = props.screenSize
		local allowAdaptiveScrolling = props.allowAdaptiveScrolling
		local topBarHeight = self:getTopBarHeight()

		local isVerticallyOffscreen = self.state.isVerticallyOffscreen
			or name == avatarScreen.AvatarExperienceLandingPage

		if isPortrait then
			if allowAdaptiveScrolling then
				current.Position = UDim2.new(0, 0, 0, topBarHeight)
				current.Size = UDim2.new(1, 0, 1, -topBarHeight)
			else
				current.Position = UDim2.new(0, 0, 0, p2.AbsoluteSize.Y + topBarHeight)
				current.Size = UDim2.new(1, 0, 1, -p2.AbsoluteSize.Y - topBarHeight)
			end
		else
			local v11 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth

			current.Size = UDim2.fromScale(isDisabled and 1 or v11, 1)

			local v12 = props.globalGuiInset.left + props.deviceSafePadding.left
			local x = current.AbsoluteSize.X
			local v13 = screenSize.X - p2.AbsoluteSize.X - v12

			local v14 = if v13 < x then (if defineFastFlag then v13 - x - topBarHeight else v13 - x) else 0

			if isVerticallyOffscreen then
				current.Position = UDim2.fromOffset(0, screenSize.Y * (-v14 / x))
			else
				current.Position = UDim2.fromOffset(v14, 0)
			end
		end
	end

	function self.onBottomBarAbsoluteSizeChanged(p2)
		self:setState({ bottomBarHeight = p2.AbsoluteSize.Y })
	end
end

function extended:getTopBarHeight()
	return self.props.topBarHeight
end

function extended:instantResize()
	local current = self.sceneFrameRef.current

	if not current then
		return
	end

	local sceneSize, v10 = self:calculateSceneSize()
	current.Size = UDim2.new(0, v10, 0, sceneSize)

	self.onSceneResized(current)
end

function extended:calculatePortraitSceneHeight()
	local props = self.props
	local globalGuiInset = props.globalGuiInset
	local screenSize = props.screenSize
	local isLandingPage = props.isLandingPage
	local offset = getSafeAreaSize(screenSize, globalGuiInset).Y.Offset

	local portraitSceneHeight = offset * module10.PortraitSceneHeight

	if isLandingPage then
		portraitSceneHeight = offset * module10.LandingPagePortraitSceneHeight

		if offset - portraitSceneHeight < module10.LandingPagePortraitMinItemsHeightPix then
			portraitSceneHeight = offset - module10.LandingPagePortraitMinItemsHeightPix
		end
	end

	return portraitSceneHeight
end

function extended:calculateFullHeight()
	local props = self.props
	local globalGuiInset = props.globalGuiInset
	local isPortrait = props.isPortrait
	local screenSize = props.screenSize
	local bottom = globalGuiInset.bottom
	local topBarHeight = self:getTopBarHeight()
	local v10 = isPortrait and topBarHeight or 0

	if defineFastFlag3 and shouldUseDeviceSafeInsets then
		return module29(screenSize.Y, props.deviceSafePadding, v10)
	end

	return screenSize.Y - bottom - v10
end

function extended:calculateSceneSize()
	local props = self.props
	local globalGuiInset = props.globalGuiInset
	local isDisabled = props.isDisabled
	local isSceneFullView = props.isSceneFullView
	local isPortrait = props.isPortrait
	local isUIFullView = props.isUIFullView
	local screenSize = props.screenSize
	local topBarHeight = self:getTopBarHeight()

	local bottom = globalGuiInset.bottom
	local left = globalGuiInset.left
	local v10 = isPortrait and topBarHeight or 0
	local v11 = screenSize.Y - bottom
	local v12 = screenSize.X - left
	local v13 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module10.LandscapeSceneWidth
	local v14 = v12 * v13

	local v15 = screenSize.X - left
	local portraitSceneHeight = self:calculatePortraitSceneHeight()
	v11 = isPortrait and portraitSceneHeight or v11
	v14 = isPortrait and v15 or v14

	if isUIFullView and isPortrait then
		v11 = 0
	elseif isSceneFullView then
		v14 = screenSize.X
		v11 = screenSize.Y - bottom - v10
	end

	if isDisabled then
		v11 = 0
		v14 = 0
	end

	return v11, v14
end

function extended:isConsoleWithGamepad()
	local props = self.props
	return tenFootInterface and props.lastInputGroup == module8.InputType.Gamepad
end

function extended:renderSceneFrame()
	local props2 = self.props
	local isDisabled = props2.isDisabled
	local isSceneFullView = props2.isSceneFullView
	local isUIFullView = props2.isUIFullView
	local isPortrait = props2.isPortrait
	local topBarHeight = self:getTopBarHeight()
	local name = props2.avatarRoute.opaque.name

	local v10 = self.state.sceneShowing or not isPortrait

	if isDisabled then
		v10 = false
	end

	local forwardRef = props2.forwardRef
	local v11 = not (isSceneFullView or isUIFullView)

	if isVRAppBuild() then
		v11 = v11 and name ~= avatarScreen.LayeredClothingSort
	end

	local createElement = Roact.createElement
	local animatedFrame = springAnimatedItem.AnimatedFrame
	local v12 = {
		regularProps = {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 0, 0, isPortrait and topBarHeight or 0),
			ZIndex = -1,
			[Roact.Change.AbsoluteSize] = self.onSceneResized,
			[Roact.Event.AncestryChanged] = self.onSceneResized,
			[Roact.Ref] = self.sceneFrameRef
		},
		animatedValues = self.state.animatedValues,
		mapValuesToProps = mapValuesToProps,
		springOptions = v7,
		onComplete = function()
			self.onTransitionComplete()
		end
	}

	local createElement2 = Roact.createElement
	local forwardRefsByRef = {}

	forwardRefsByRef.globalGuiInset = self.props.globalGuiInset
	local v16 = if module37() then self.props.statusBarHeight else nil
	forwardRefsByRef.statusBarHeight = v16

	forwardRefsByRef.changeViewFunction = props2.changeViewFunction
	forwardRefsByRef.isVisible = v10
	forwardRefsByRef.row1ChildrenVisible = v11
	forwardRefsByRef.showRobuxBalance = props2.showRobuxBalance
	forwardRefsByRef[Roact.Ref] = forwardRef
	local v14 = {
		SceneUIContainer = createElement2(module21, forwardRefsByRef),
		SceneInteractionFrame = 0,
		AvatarLoadingSpinner = 0,
		VRAvatarEditorNavBar = 0,
		SceneUi = 0
	}

	local v17 = if not (v6 or isVRAppBuild()) then Roact.createElement(module19) else nil
	v14.SceneInteractionFrame = v17

	local v18 = if not isVRAppBuild() then Roact.createElement(module20) else nil
	v14.AvatarLoadingSpinner = v18
	local v19 = if isVRAppBuild() then Roact.createElement(module25, {
		currentPage = name,
		navigation = props2.navigation
	}) else nil
	v14.VRAvatarEditorNavBar = v19

	v14.SceneUi = props2.sceneUi
	return createElement(animatedFrame, v12, v14)
end

function extended:renderWithStyle(p2)
	local props2 = self.props
	local allowAdaptiveScrolling = props2.allowAdaptiveScrolling
	local bottomBarEnabled = props2.bottomBarEnabled
	local globalGuiInset = props2.globalGuiInset
	local isPortrait = props2.isPortrait
	local topBarHeight = self:getTopBarHeight()
	local tokens = props2.tokens
	local isTimedOut = props2.isTimedOut
	local showUndoRedo = if module38() then props2.showUndoRedo else nil
	local showSaveButton = if module38() and fFlagAXEnableManualSaving then props2.showSaveButton else nil

	local v10 = not bottomBarEnabled and globalGuiInset.bottom > 0
	local sceneSize = self:calculateSceneSize()

	local avatarRoute = props2.avatarRoute
	local v11

	if module40() then
		v11 = if props2.avatarRoute.opaque.name == avatarScreen.Catalog then v9 else v8
	end

	local v12, v13

	if fFlagAXCatalogOffersBannerEnabled then
		local name = avatarRoute.opaque.name

		v12 = name == avatarScreen.Catalog or name == avatarScreen.CatalogSearch

		local v14 = if module40() then (if name == avatarScreen.Catalog then v9 else v8) else v8

		v13 = v14 + (not (v12 and self.state.catalogOffersBannerPeekHeaderBackgroundActive) and 0 or module10.CatalogOffersBannerPeekClosedExtraHeight)
	end

	local v14 = not (fFlagEnableBottomNavOnMarketplace and isPortrait and tokens) and 0
		or tokens.Size.Size_1600
	local v15 = fFlagAXAvatarPreviewPhotoboothMomentsButton and 0 or nil

	if fFlagAXAvatarPreviewPhotoboothMomentsButton then
		local v16 = if fFlagAXCatalogOffersBannerEnabled then v13 elseif module40() then v11 else v8

		v15 = v16 + (not fFlagEnableBottomNavOnMarketplace and 0 or v14)
	end

	local v16 = not Cryo.isEmpty(props2.tryOnItems) and (not props2.isSceneFullView or false)

	if props2.lookId ~= nil and avatarRoute.opaque.name == avatarScreen.MySharedAvatars then
		v16 = false
	end

	if not props2.showMultiTryOnBottomBar then
		v16 = false
	end

	local v17, v18

	if allowAdaptiveScrolling then
		v17 = self:calculateFullHeight()
		v18 = v17 - self:calculatePortraitSceneHeight()
	end

	local v19 = {
		TopBar = not isPortrait and props2.topBar,
		Items = 0,
		InsetBackground = 0
	}

	local createElement = Roact.createElement

	local v21 = {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 1, isPortrait and 0 or -topBarHeight),
		ZIndex = 2
	}
	local children

	if allowAdaptiveScrolling and isPortrait then
		children = { AdaptiveScrollingView = 0 }
		local createElement2 = Roact.createElement
		local v24

		if fFlagAXAvatarPreviewPhotoboothMomentsButton then
			v24 = v15
		else
			if fFlagAXCatalogOffersBannerEnabled then
				v11 = v13
			elseif not module40() then
				v11 = v8
			end

			v24 = v11 + (not fFlagEnableBottomNavOnMarketplace and 0 or v14)
		end

		local v23 = {
			fullHeight = v17,
			midHeight = v18,
			alwaysShowingHeight = v24,
			topBarHeight = props2.topBarHeight,
			fullHeightOptions = 0,
			enableExpandPeekViewOnUpwardScroll = 0,
			disableViewChangeByScroll = 0,
			enableAnimatedVisibility = 0,
			peekHeaderUsesElevatedBackground = 0,
			peekHeaderBackgroundActive = 0,
			onPeekHeaderBackgroundActiveChanged = 0,
			banner = 0,
			onCanvasYDelta = 0,
			onScrollTouchEnded = 0
		}
		local v25 = if props2.adaptiveScrollingProps then props2.adaptiveScrollingProps.fullHeightOptions else nil
		v23.fullHeightOptions = v25

		local v26 = if fFlagAXExpandPeekViewOnFirstScroll and props2.adaptiveScrollingProps then props2.adaptiveScrollingProps.enableExpandPeekViewOnUpwardScroll else nil
		v23.enableExpandPeekViewOnUpwardScroll = v26

		local v27 = if fFlagAXSlotsPeekViewScrollFix then props2.disableScrollViewBindings else nil
		v23.disableViewChangeByScroll = v27

		local v28 = if fFlagAXHideMenuOnScroll and props2.adaptiveScrollingProps then props2.adaptiveScrollingProps.enableAnimatedVisibility else nil
		v23.enableAnimatedVisibility = v28
		local v29 = if fFlagAXCatalogOffersBannerEnabled then v12 or isTimedOut == true else nil
		v23.peekHeaderUsesElevatedBackground = v29

		local v30 = if fFlagAXCatalogOffersBannerEnabled and v12 then self.state.catalogOffersBannerPeekHeaderBackgroundActive else nil
		v23.peekHeaderBackgroundActive = v30

		local v31 = if fFlagAXCatalogOffersBannerEnabled and v12 then self.onCatalogOffersBannerPeekHeaderBackgroundActiveChanged else nil
		v23.onPeekHeaderBackgroundActiveChanged = v31

		local v32 = if isTimedOut then React.createElement(timeoutBanner) else nil
		v23.banner = v32

		local v33 = if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then self.onSheetCanvasYDelta else nil
		v23.onCanvasYDelta = v33

		local v34 = if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then self.onSheetScrollTouchEnded else nil
		v23.onScrollTouchEnded = v34
		children.AdaptiveScrollingView = createElement2(module28, v23, props2.children)
	elseif props2.tokens then
		children = { ScrollingView = 0 }
		local createElement2 = Roact.createElement
		local v23 = {
			Size = UDim2.new(1, 0, 1, props2.deviceSafePadding.bottom),
			BorderSizePixel = defineFastFlag4 and 0 or nil,
			BackgroundColor3 = props2.tokens.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = props2.tokens.Color.Surface.Surface_100.Transparency
		}
		local v24 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Banner = 0,
			Content = 0
		}

		local v25 = if isTimedOut then React.createElement(timeoutBanner) else nil
		v24.Banner = v25
		v24.Content = Roact.createElement(
			Foundation.View,
			{ tag = "size-full-full", LayoutOrder = 1 },
			props2.children
		)
		children.ScrollingView = createElement2("Frame", v23, v24)
	else
		children = props2.children
	end

	v19.Items = createElement("Frame", v21, children)

	local v22 = if not isPortrait then React.createElement(insetBackground, {
		directions = { top = true }
	}) else nil
	v19.InsetBackground = v22

	local sceneFrame = self:renderSceneFrame()
	local v23

	if fFlagAXPhotoboothMomentsButtonsEditorOnly then
		local name = avatarRoute.opaque.name
		v23 = name == avatarScreen.AvatarEditor or module38() and name == avatarScreen.AvatarSwitcher
	else
		v23 = true
	end

	local v24

	if module38() and tokens then
		local portraitSceneHeight = self:calculatePortraitSceneHeight()

		local udim = UDim2.new(
			1,
			-tokens.Size.Size_500,
			0,
			portraitSceneHeight + topBarHeight - tokens.Size.Size_400
		)

		if not isPortrait then
			local size_500 = tokens.Size.Size_500
			local bottomBarHeight = self.state.bottomBarHeight

			if props2.isTryingOnItems and bottomBarHeight then
				size_500 += bottomBarHeight
			end

			udim = UDim2.new(1, -tokens.Size.Size_500, 1, -size_500)
		end

		local createElement2 = Roact.createElement
		local view = Foundation.View

		local v27 = if showSaveButton and not props2.isSceneFullView then Roact.createElement(saveButton, {}) else nil

		local v28 = if props2.isSceneFullView and not isPortrait and (not fFlagQRCodePageVisualRefresh or props2.changeViewFunction ~= nil) then React.createElement(module35, {
			isUIFullView = props2.isUIFullView,
			isSceneFullView = props2.isSceneFullView,
			changeViewFunction = props2.changeViewFunction
		}) else nil

		local v29 = if fFlagAXAvatarPreviewPhotoboothMomentsButton and v23 and not props2.isSceneFullView and not props2.isUIFullView and (not fFlagAXPhotoboothMomentsButtonUnderRobuxBalance or isPortrait or not (module39 and props2.showRobuxBalance)) then React.createElement(photoboothMomentsButton, {
			LayoutOrder = 2
		}) else nil
		v24 = createElement2(view, {
			tag = "auto-xy anchor-bottom-right row",
			Position = udim
		}, {
			SaveButton = v27,
			FullViewEntryButton = v28,
			PhotoboothMomentsButton = v29
		})
	elseif not (allowAdaptiveScrolling and isPortrait) then
		v24 = Roact.createElement(module23, {
			sceneHeight = sceneSize,
			isUIFullView = props2.isUIFullView,
			isSceneFullView = props2.isSceneFullView,
			changeViewFunction = props2.changeViewFunction,
			ZIndex = 3
		})
	end

	local v25

	if module38() and tokens then
		local createElement2 = React.createElement
		local view = Foundation.View
		local udim

		if isPortrait then
			local fromOffset = UDim2.fromOffset
			local size_500 = tokens.Size.Size_500
			local v27

			if avatarRoute.opaque.name == avatarScreen.CatalogSearchLanding then
				v27 = props2.storeTopBarHeight
			else
				v27 = topBarHeight
			end

			udim = fromOffset(size_500, v27)
		else
			local newUDim2 = UDim2.new
			local v27 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth
			local size_700 = tokens.Size.Size_700
			local v29

			if module13 then
				v29 = tokens.Size.Size_400
			elseif avatarRoute.opaque.name == avatarScreen.CatalogSearchLanding then
				v29 = props2.storeTopBarHeight
			else
				v29 = if module14 and props2.reserveTopBarOffset then props2.storeTopBarHeight else topBarHeight
			end

			udim = newUDim2(v27, size_700, 0, v29)
		end

		v25 = createElement2(view, {
			tag = "auto-xy col gap-small",
			SelectionGroup = true,
			Position = udim,
			Visible = not props2.isSceneFullView,
			ZIndex = self.quickButtonsZIndexBinding
		}, {
			ControlBar = React.createElement(module34, {
				isUIFullView = props2.isUIFullView,
				isSceneFullView = props2.isSceneFullView,
				showControlBar = props2.showControlBar,
				showUndoRedo = showUndoRedo and (fFlagAXResetAvatarButton and true or not isPortrait),
				onActiveMenuItemChanged = self.onActiveControlBarMenuItemChanged,
				NextSelectionLeft = props2.defaultChildRef,
				LayoutOrder = 1
			})
		})
	else
		v25 = Roact.createElement(module33, {
			isUIFullView = props2.isUIFullView,
			isSceneFullView = props2.isSceneFullView
		})
	end

	local v26

	if module39 and self.props.showRobuxBalance and self.props.tokens then
		local v27 = fFlagAXHideRobuxBalanceInVR
			and self.props.isSpatial
			and isVRHiddenRobuxBalanceScreen(avatarRoute.current.name)

		local v28 = self.props.tokens.Size.Size_700

		if isPortrait then
			v28 = self.props.tokens.Size.Size_500
		elseif self.props.preferredInput == Responsive.Input.Directional then
			v28 = self.props.tokens.Size.Size_200
		end

		local v29 = "auto-xy anchor-top-right"

		if fFlagAXShowHeadAdjustmentInRightControlBar then
			v29 ..= " col gap-small align-x-right"
		elseif
			fFlagAXPhotoboothMomentsButtonUnderRobuxBalance
			and not isPortrait
			and v23
			and not (props2.isSceneFullView or props2.isUIFullView)
		then
			v29 ..= " col gap-small align-x-right"
		end

		local createElement2 = React.createElement
		local view = Foundation.View

		local newUDim2 = UDim2.new

		local v32 = -v28
		local v34

		if self.props.isSpatial then
			v34 = 0
		elseif module13 and not isPortrait then
			v34 = self.props.tokens.Size.Size_400
		elseif avatarRoute.opaque.name == avatarScreen.CatalogSearchLanding then
			v34 = self.props.storeTopBarHeight
		elseif module14 and self.props.reserveTopBarOffset then
			v34 = self.props.storeTopBarHeight
		else
			v34 = self.props.topBarHeight
		end

		local v30 = { tag = v29, Position = newUDim2(1, v32, 0, v34) }
		local v36

		if not v27 then
			local v37

			if fFlagAXFixRobuxButtonShowingInFullView then
				local isSceneFullView = props2.isSceneFullView or props2.isUIFullView
				v37 = not isSceneFullView
			else
				v37 = not props2.isSceneFullView
			end

			if v37 then
				v36 = React.createElement(module30, { ref = self.robuxBalanceRef })
			end
		end

		local v37 = if fFlagAXPhotoboothMomentsButtonUnderRobuxBalance and not isPortrait and v23 and not (props2.isSceneFullView or props2.isUIFullView) then React.createElement(photoboothMomentsButton, {
			LayoutOrder = 4
		}) else nil
		v26 = createElement2(view, v30, {
			RobuxBalance = v36,
			PhotoboothMomentsButton = v37
		})
	end

	local v27

	if tokens then
		local v28 = self:calculatePortraitSceneHeight() / 2 + topBarHeight

		local createElement2 = React.createElement
		local view = Foundation.View
		local v29 = {
			tag = "auto-xy anchor-center-right",
			Position = UDim2.new(1, -tokens.Size.Size_500, 0, v28),
			Visible = not (props2.isSceneFullView or props2.isUIFullView)
		}

		local v31 = if self.props.isPortrait then React.createElement(module43, {
			LayoutOrder = 1
		}) else nil
		v27 = createElement2(view, v29, { ContextualActions = v31 })
	end

	local v28

	if module38() and tokens then
		local v29 = showUndoRedo
			and not props2.isSceneFullView
			and isPortrait
			and not fFlagAXResetAvatarButton

		if v29 then
			local isUIFullView = fFlagAXFixControlBarSubMenuOverlap and props2.isUIFullView
			v29 = not isUIFullView
		end

		local portraitSceneHeight = self:calculatePortraitSceneHeight()

		local udim = UDim2.fromOffset(
			tokens.Size.Size_500,
			portraitSceneHeight + topBarHeight - tokens.Size.Size_400
		)

		if not isPortrait then
			local size_500 = tokens.Size.Size_500
			local bottomBarHeight = self.state.bottomBarHeight

			if props2.isTryingOnItems and bottomBarHeight then
				size_500 += bottomBarHeight
			end

			local newUDim2 = UDim2.new
			local v30 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module10.LandscapeNavWidth
			udim = newUDim2(v30, tokens.Size.Size_500, 1, -size_500)
		end

		local createElement2 = React.createElement
		local view = Foundation.View

		local v32 = if v29 then React.createElement(undoRedoBar) else nil
		v28 = createElement2(view, {
			tag = "auto-xy anchor-bottom-left",
			Position = udim
		}, {
			UndoRedoBarPortrait = v32
		})
	end

	local v29 = nil

	if fFlagAXAvatarPreviewPhotoboothMomentsButton then
		local v30 = avatarRoute.opaque.name == avatarScreen.PhotoboothMomentsPage

		if v23 and props2.isSceneFullView and not v30 then
			local v31

			if allowAdaptiveScrolling and isPortrait then
				v31 = math.max(v15 or 0, globalGuiInset.bottom)
			else
				v31 = globalGuiInset.bottom
			end

			v29 = React.createElement(BottomCenterButtons, { bottomOffset = v31 })
		end
	end

	local v30

	if isVRAppBuild() then
		local createElement2 = Roact.createElement

		local v34 = if avatarRoute.current.name ~= avatarScreen.LayeredClothingSort then Roact.createElement(module18) else nil

		if not module39 then
			v26 = nil
		end

		if not module38() then
			v28 = nil
		end

		if not fFlagAXAvatarPreviewPhotoboothMomentsButton then
			v29 = nil
		end

		v30 = createElement2(module27, {
			roundedCornersFrame = false,
			panelPlacement = "Center"
		}, {
			SceneFrame = sceneFrame,
			QuickButtons = v25,
			BottomRightButtons = v24,
			GamepadHandler = v34,
			TopRightButtons = v26,
			MiddleRightButtons = v27,
			BottomLeftButtons = v28,
			BottomCenterButtons = v29
		})
	else
		local createFragment = Roact.createFragment

		if not module39 then
			v26 = nil
		end

		if not module38() then
			v28 = nil
		end

		if not fFlagAXAvatarPreviewPhotoboothMomentsButton then
			v29 = nil
		end

		v30 = createFragment({
			SceneFrame = sceneFrame,
			QuickButtons = v25,
			BottomRightButtons = v24,
			TopRightButtons = v26,
			MiddleRightButtons = v27,
			BottomLeftButtons = v28,
			BottomCenterButtons = v29
		})
	end

	local v31 = tutils.fieldCount(props2.tryOnItems) > 1

	local createElement2 = Roact.createElement
	local v33 = {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(
			0,
			not getFFlagLuaAppEnableTopBanner() and 0 or -props2.globalGuiInset.top
		),
		Size = UDim2.fromScale(1, 1),
		ZIndex = props2.ZIndex,
		ref = props2.itemFrameRef
	}
	local v34 = {
		TopBar = isPortrait and props2.topBar,
		ItemsFrame = 0,
		OverlayedUI = 0,
		BottomInsetBackground = 0,
		MultiTryOnBottomBar = 0,
		CheckoutActionBar = 0,
		FullSceneInteractionFrame = 0,
		OnFocusExperimentExposureLogger = 0
	}
	local v35

	if isVRAppBuild() then
		v35 = Roact.createElement(module27, {
			visible = avatarRoute.current.name ~= avatarScreen.LayeredClothingSort,
			roundedCornersFrame = true,
			panelPlacement = "Left"
		}, v19)
	else
		v35 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = (not isPortrait or allowAdaptiveScrolling) and 2 or nil,
			[Roact.Change.AbsoluteSize] = self.onNavItemsFrameResized,
			[Roact.Ref] = self.navItemsFrameRef,
			Visible = self.props.isItemFrameVisible
		}, v19)
	end

	v34.ItemsFrame = v35
	local v36

	if defineFastFlag2 then
		v36 = React.createElement("Frame", {
			ref = props2.quickButtonsRef,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = props2.isQuickButtonsVisible,
			SelectionGroup = true,
			ZIndex = fFlagAXFixControlBarSubMenuOverlap and 3 or nil
		}, v30)
	elseif props2.isQuickButtonsVisible then
		v36 = React.createElement("Frame", {
			ref = props2.quickButtonsRef,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = fFlagAXFixControlBarSubMenuOverlap and 3 or nil
		}, v30)
	end

	v34.OverlayedUI = v36

	local v37 = if v10 then Roact.createElement(module24, {
		globalGuiInset = globalGuiInset
	}) else nil
	v34.BottomInsetBackground = v37
	local v38

	if not v31 then
		local createElement3 = Roact.createElement
		local v40 = {
			bottomBarRef = props2.multiTryOnBottomBarRef,
			NextSelectionLeft = props2.namedRefs[props2.avatarRoute.opaque.name .. module15.ItemsList],
			Visible = props2.isOpaqueRouteMatchingCurrentRoute and v16,
			isConsoleWithGamepad = self:isConsoleWithGamepad(),
			itemDetailsPeekViewRefs = props2.itemDetailsPeekViewRefs,
			onAbsoluteSizeChanged = self.onBottomBarAbsoluteSizeChanged,
			footerVisibilityBinding = 0
		}

		local v41 = if fFlagStackedBottomNavMarketplaceCTA then self.ctaBottomNavOffsetBinding else nil
		v40.footerVisibilityBinding = v41
		v38 = createElement3(module32, v40)
	end

	v34.MultiTryOnBottomBar = v38
	local v39

	if props2.isOpaqueRouteMatchingCurrentRoute and v31 then
		local createElement3 = React.createElement
		local v41 = {
			ref = props2.multiTryOnBottomBarRef,
			onAbsoluteSizeChanged = self.onBottomBarAbsoluteSizeChanged,
			Visible = v16,
			footerVisibilityBinding = 0
		}

		local v42 = if fFlagStackedBottomNavMarketplaceCTA then self.ctaBottomNavOffsetBinding else nil
		v41.footerVisibilityBinding = v42
		v39 = createElement3(checkoutActionBarContainer, v41)
	end

	v34.CheckoutActionBar = v39

	local v40 = if v6 and not self.props.isSpatial then Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = -2 },
		{ SceneInteractionFrame = Roact.createElement(module19) }
	) else nil
	v34.FullSceneInteractionFrame = v40
	local v41

	if fFlagAXResetAvatarButtonExposureLogging then
		v41 = Roact.createElement(module31, {
			ixpTests = {},
			flagIXPTestLayers = { if fFlagAXResetAvatarButtonExposureLogging then appUserLayers.AvatarExperienceUAAllViews else nil }
		})
	end

	v34.OnFocusExperimentExposureLogger = v41
	return createElement2("Frame", v33, v34)
end

function extended:render()
	return withStyle(function(p2)
		return Roact.createElement(module17, nil, {
			AvatarExperienceView = self:renderWithStyle(p2)
		})
	end)
end

function extended:didUpdate(data)
	local props = self.props
	local isUIFullView = props.isUIFullView
	local sceneShowing = self.state.sceneShowing

	if not (isUIFullView or sceneShowing) then
		self:setState({ sceneShowing = true })
	end

	local isPortrait = data.isPortrait
	local isPortrait2 = props.isPortrait

	if isPortrait2 ~= isPortrait then
		if isPortrait2 and isUIFullView then
			self:setState({ sceneShowing = false })
		elseif not isPortrait and isUIFullView then
			self:setState({ sceneShowing = true })
		end

		self:instantResize()
	end

	if props.isDisabled then
		self:instantResize()
	end

	if props.screenSize ~= data.screenSize then
		self:instantResize()
	end

	if props.topBarHeight ~= data.topBarHeight then
		self:instantResize()
	end

	local sceneSize, v10 = self:calculateSceneSize()

	if sceneSize ~= self.state.animatedValues.height or v10 ~= self.state.animatedValues.width then
		self:setState({
			animatedValues = { height = sceneSize, width = v10 }
		})
	end
end

function extended:didMount()
	self:instantResize()

	local sceneSize, v10 = self:calculateSceneSize()

	self:setState({
		animatedValues = { height = sceneSize, width = v10 }
	})
end

local v10 = module26((RoactRodux.connect(mapStateToProps, nil)(extended)))

local v11 = module9((module22((RoactNavigation.withNavigation(v10)))))

local v12 = module36.connectTestVariables({
	universalAppCameraEnabled = module42.EnabledForUser
})(v11)

local function selectTryingOnItems(p2): boolean
	return not Cryo.isEmpty(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
end

return Roact.forwardRef(function(p2, p3)
	local v13 = if fFlagAXShowHeadAdjustmentInRightControlBar then useNavigation() else nil
	local v14 = useTokens()
	local timeoutStatusStore = getTimeoutStatusStore(false)
	local v15 = if timeoutStatusStore then useSignalState(timeoutStatusStore.getIsTimedOut) else nil
	local v16 = if module39 then Responsive.useIsSpatial() else nil
	local v17 = if module39 then Responsive.usePreferredInput() else nil
	local v18 = if module38() then useSelector(selectTryingOnItems, getUseSelectorDeepEquals()) else nil

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local quickButtonsRef = p2.quickButtonsRef or ref2

	if not fFlagAXShowHeadAdjustmentInRightControlBar then
		v13 = useNavigation()
	end

	local v19 = useAvatarRoute()
	local routeName = if v13 and v13.state then v13.state.routeName else nil
	local name = v19.opaque.name
	local name2 = v19.current.name
	local v20 = not defineFastFlag5 or v19.isVisible

	if v20 then
		v20 = routeName == name and not set[name2]
	end

	local v21 = useSelector(selectQuickItemsVisible)

	if defineFastFlag5 then
		v21 = v19.isVisible and v21
	end

	local v22 = routeName == name2
	useFocusNavigableSurfaceRegistryConnection(
		ref.current,
		focusNavigableSurfaceIdentifierEnum.SubRouterView,
		v20
	)

	useFocusNavigableSurfaceRegistryConnection(
		quickButtonsRef.current,
		focusNavigableSurfaceIdentifierEnum.Auxiliary,
		v21
	)

	if not fFlagAXShowHeadAdjustmentInRightControlBar then
		v13 = useNavigation()
	end

	local v23 = routeName and routeName == name2

	if fFlagAXModeratedItemsFlow then
		if not fFlagAXShowHeadAdjustmentInRightControlBar then
			v13 = useNavigation()
		end

		local v24 = useDispatch()
		local v25 = useAvatarSaveContext()

		useEffectOnMount(function()
			v24(module41(v13, v25.trySaveAvatar))
		end)
	end

	local v24 = useSignalState(module16.GetDisplayStore().getDeviceSafePadding)

	return Roact.createElement(v12, Cryo.Dictionary.join(p2, {
		forwardRef = p3,
		tokens = v14,
		isSpatial = v16,
		navigation = if fFlagAXShowHeadAdjustmentInRightControlBar then v13 else nil,
		preferredInput = v17,
		isTryingOnItems = v18,
		controlBarFocusAnimation = nil,
		itemFrameRef = ref,
		quickButtonsRef = quickButtonsRef,
		isQuickButtonsVisible = v21,
		isOpaqueRouteMatchingCurrentRoute = v23,
		isItemFrameVisible = v20,
		isTimedOut = v15,
		deviceSafePadding = v24
	}))
end)
