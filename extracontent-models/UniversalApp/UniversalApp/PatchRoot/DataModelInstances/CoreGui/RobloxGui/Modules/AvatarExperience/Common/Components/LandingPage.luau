local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics3 = require(Modules.AvatarExperience.ProfilePictureEditor.Services.Analytics)
local Analytics4 = require(Modules.AvatarExperience.Common.Services.Analytics)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local LuaAppEvents = require(Modules.LuaApp.LuaAppEvents)
local AppPage = require(Modules.LuaApp.AppPage)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local AvatarPageButton = require(Modules.AvatarExperience.Common.Components.Landing.AvatarPageButton)
local CatalogPageButton = require(Modules.AvatarExperience.Common.Components.Landing.CatalogPageButton)
local ProfilePictureEditorPageButton = require(Modules.AvatarExperience.Common.Components.Landing.ProfilePictureEditorPageButton)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local Constants = require(Modules.LuaApp.Constants)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local isAvatarRouteVisible = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Utils.isAvatarRouteVisible)
local NavigationEventsLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local SetCategoryAndSubcategory2 = require(Modules.AvatarExperience.Catalog.Thunks.SetCategoryAndSubcategory)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry
local useFirstFocusableDescendantRef = FocusNavigationUtils.useFirstFocusableDescendantRef
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useAvatarExperienceFocusNavigationBindings = require(Modules.AvatarExperience.Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Modules.AvatarExperience.Common.Hooks.useOverlayClosedCallback)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local GetFFlagAvatarAutocompleteEnabledForAll = require(Modules.AvatarExperience.Flags.GetFFlagAvatarAutocompleteEnabledForAll)
local GetFFlagAllowAvatarLandingPageSearch = require(Modules.AvatarExperience.Flags.GetFFlagAllowAvatarLandingPageSearch)
local AXDisableAlwaysRenderedScreensIXP = require(Modules.AvatarExperience.Experiments.AXDisableAlwaysRenderedScreensIXP)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v61 = game:DefineFastFlag("AXMigrateLandingPageToAutoFocus", false) and FFlagAXMigrateAXToGlobalAutofocus
local v62 = game:DefineFastFlag("AXFixLandingPageButtonsStuckOffscreen", false)
local FFlagAXMoveAllTabToWidgetOnly = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMoveAllTabToWidgetOnly
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local WidgetsPercievedTTIManager = AvatarExperienceTTIPerformance.WidgetsPercievedTTIManager
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local t1 = {
	dampingRatio = 0.8,
	frequency = 4
}

local function mapValuesToPropsLeft(p1) -- line: 137
	return {
		Position = UDim2.new(0.5, -13, p1.yPosition, 0)
	}
end
local function mapValuesToPropsRight(p2) -- line: 145
	return {
		Position = UDim2.new(0.5, 13, p2.yPosition, 0)
	}
end
local function mapValuesToPropsMiddle(p3) -- line: 153
	return {
		Position = UDim2.new(0.5, 0, p3.yPosition, 13)
	}
end

local v74 = Roact.PureComponent:extend("AvatarExperienceLandingPage")

v74.validateProps = t.strictInterface({
	avatarCategory = t.number,
	avatarSubcategory = t.number,
	catalogCategoryId = t.optional(t.string),
	catalogSubcategoryId = t.optional(t.string),
	deviceOrientation = t.string,
	statusBarHeight = t.number,
	resetAvatarCategories = t.callback,
	resetCatalogCategories = t.callback,
	setFullView = t.callback,
	startPercievedCatalogTTITracker = t.callback,
	avatarAnalytics = t.table,
	catalogAnalytics = t.table,
	profilePictureEditorAnalytics = t.table,
	avatarExperienceAnalytics = t.table,
	lastInputGroup = t.string,
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	NextSelectionUp = t.optional(t.any),
	shouldCaptureFocus = t.boolean,
	is10ftUI = t.boolean,
	focusNavigationBindingsRef = t.callback,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil
})

function v74.init(p4) -- line: 196
	-- upvalues: Roact (copy), LuaAppEvents (copy), AppPage (copy), AvatarScreen (copy), UserInputService (copy), isGamepadInput (copy), Otter (copy), FFlagAXMoveAllTabToWidgetOnly (copy), WidgetsPercievedTTIManager (copy), TTIPerformanceManager (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), v62 (copy), FullView (copy)
	p4.robuxBalanceRef = Roact.createRef()
	p4.quickMenuRef = Roact.createRef()
	p4.state = {
		buttonsOffscreen = false,
		buttonTransparencyModifier = 0
	}
	p4.luaAppReloadPageEventConnection = LuaAppEvents.ReloadPage:connect(function(p5) -- line: 205
		-- upvalues: AppPage (copy), p4 (copy), AvatarScreen (copy)
		if p5 == AppPage.AvatarExperienceRoot then
			if p4.props.is10ftUI then
				p4.props.navigation.navigate(AvatarScreen.AvatarExperienceLandingPage)

				return
			end

			p4.props.navigation.navigate(AvatarScreen.Catalog)
		end
	end)

	local LastInputType = UserInputService:GetLastInputType()

	function p4.lastInputTypeChangedCallback(p6) -- line: 217
		-- upvalues: isGamepadInput (copy), p4 (copy)
		local v137 = isGamepadInput(p6)

		if v137 ~= p4.state.lastInputIsGamepad then
			p4:setState({
				lastInputIsGamepad = v137
			})
		end
	end

	p4.state.lastInputIsGamepad = isGamepadInput(LastInputType)

	function p4.updateButtonPositions() -- line: 228
		-- upvalues: p4 (copy), Otter (copy)
		p4:setState({
			buttonsOffscreen = true
		})

		if p4.motor then
			p4.motor:setGoal(Otter.spring(1), {
				frequency = 3
			})
		end
	end
	function p4.showProfilePictureEditorCallback() -- line: 240
		-- upvalues: p4 (copy), AvatarScreen (copy)
		p4.props.profilePictureEditorAnalytics.profilePictureEditorOpenedFromLandingPage()
		p4.updateButtonPositions()
		delay(0.2, function() -- line: 245
			-- upvalues: p4 (copy), AvatarScreen (copy)
			p4.props.navigation.navigate(AvatarScreen.ProfilePictureEditorEmotes)
		end)
	end
	function p4.showAvatarEditorCallback() -- line: 250
		-- upvalues: p4 (copy), AvatarScreen (copy)
		p4.props.avatarAnalytics.avatarEditorOpenedFromLandingPage()
		p4.updateButtonPositions()
		delay(0.2, function() -- line: 256
			-- upvalues: p4 (copy), AvatarScreen (copy)
			if p4.isMounted then
				p4.props.navigation.navigate(AvatarScreen.AvatarEditor)
			end
		end)
	end
	function p4.showCatalogCallback() -- line: 263
		-- upvalues: p4 (copy), FFlagAXMoveAllTabToWidgetOnly (copy), WidgetsPercievedTTIManager (copy), TTIPerformanceManager (copy), AvatarScreen (copy)
		p4.props.catalogAnalytics.catalogOpenedFromLandingPage()
		p4.updateButtonPositions()

		if FFlagAXMoveAllTabToWidgetOnly then
			WidgetsPercievedTTIManager.startPerceivedTracking()
		else
			TTIPerformanceManager.Surface.Marketplace.Root.startPerceivedTracking()
		end

		p4.props.startPercievedCatalogTTITracker()
		delay(0.2, function() -- line: 274
			-- upvalues: p4 (copy), AvatarScreen (copy)
			if p4.isMounted then
				p4.props.navigation.navigate(AvatarScreen.Catalog)
			end
		end)
	end
	function p4.transitionOnscreen() -- line: 281
		-- upvalues: p4 (copy), Otter (copy)
		p4:setState({
			buttonsOffscreen = false
		})

		if p4.motor then
			p4.motor:setGoal(Otter.spring(0), {
				frequency = 3
			})
		end
	end

	p4.pageButtonsRef = Roact.createRef()
	p4.catalogPageButtonRef = Roact.createRef()
	p4.avatarPageButtonRef = Roact.createRef()
	p4.topFrameRef = Roact.createRef()
	p4.topBarRef = Roact.createRef()
	p4.robuxButtonRef = Roact.createRef()
	p4.profilePictureEditorPageButtonRef = Roact.createRef()
	p4.topFrameRef = Roact.createRef()
	p4.sceneUIContainerRef = Roact.createRef()

	function p4.onComplete() -- line: 305
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p4 (copy), Constants (copy)
		if not FFlagAXMigrateAXToGlobalAutofocus and (p4.isFocused and (p4.props.lastInputGroup == Constants.InputType.Gamepad and p4.props.avatarRoute.isVisible) and not p4.state.buttonsOffscreen and p4.props.shouldCaptureFocus) then
			p4.props.focusController.captureFocus()
		end
	end
	function p4.onWillFocus() -- line: 317
		-- upvalues: p4 (copy), Otter (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy)
		if not p4.isMounted then
			return
		end

		p4.isFocused = true
		p4.motor = Otter.createSingleMotor(p4.state.buttonTransparencyModifier)
		p4.motor:onStep(function(p7) -- line: 325
			-- upvalues: p4 (copy)
			if not p4.isFocused and not p4.isMounted then
				return
			end

			p4:setState({
				buttonTransparencyModifier = p7
			})
		end)
		p4.transitionOnscreen()

		if not FFlagAXMigrateAXToGlobalAutofocus and (p4.isFocused and (p4.props.lastInputGroup == Constants.InputType.Gamepad and p4.props.avatarRoute.isVisible)) and p4.props.shouldCaptureFocus then
			p4.props.focusController.captureFocus()
		end
	end
	function p4.onWillBlur() -- line: 347
		-- upvalues: p4 (copy), v62 (copy)
		if p4.motor then
			p4.motor:destroy()

			if v62 then
				p4.motor = nil
			end
		end

		p4.isFocused = false
	end
	function p4.resetCategoryNavigation() -- line: 364
		-- upvalues: p4 (copy)
		local avatarCategory = p4.props.avatarCategory
		local avatarSubcategory = p4.props.avatarSubcategory
		local catalogCategoryId = p4.props.catalogCategoryId
		local catalogSubcategoryId = p4.props.catalogSubcategoryId

		if avatarCategory ~= 1 or avatarSubcategory ~= 1 then
			p4.props.resetAvatarCategories(p4.props.avatarAnalytics)

			return
		end

		if catalogCategoryId ~= "1" or catalogSubcategoryId ~= "1" then
			p4.props.resetCatalogCategories(p4.props.catalogAnalytics)
		end
	end
	function p4.setUIFullView() -- line: 378
		-- upvalues: p4 (copy), AvatarScreen (copy), FullView (copy)
		local avatarExperienceAnalytics = p4.props.avatarExperienceAnalytics

		p4.props.setFullView(avatarExperienceAnalytics, AvatarScreen.CatalogSearch, FullView.UIFullView)
	end
end
function v74.renderTopBar(p8) -- line: 385
	-- upvalues: GetFFlagAllowAvatarLandingPageSearch (copy), withLocalization (copy), Roact (copy), v61 (copy), TopBar (copy), Focusable (copy), RobloxAppEnums (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy)
	local n1 = 0

	if GetFFlagAllowAvatarLandingPageSearch() then
		n1 = 2
	end

	return withLocalization({
		title = "CommonUI.Features.Label.Avatar"
	})(function(p9) -- line: 393
		-- upvalues: Roact (copy), v61 (copy), TopBar (copy), Focusable (copy), GetFFlagAllowAvatarLandingPageSearch (copy), RobloxAppEnums (copy), n1 (ref), GetFFlagAvatarAutocompleteEnabledForAll (copy), p8 (copy)
		return Roact.createElement(if not v61 then Focusable[TopBar.Container] else TopBar.Container, {
			titleText = p9.title,
			searchType = GetFFlagAllowAvatarLandingPageSearch() and RobloxAppEnums.SearchTypes.Catalog or nil,
			transparentBackground = true,
			ZIndex = n1,
			onConfirmSearchCallback = GetFFlagAvatarAutocompleteEnabledForAll() and p8.setUIFullView or nil,
			rightItems = if not GetFFlagAllowAvatarLandingPageSearch() then {} else { TopBar.SearchButton },
			[Roact.Ref] = p8.topBarRef,
			NextSelectionDown = if not v61 then p8.catalogPageButtonRef else nil,
			NextSelectionRight = if not v61 then p8.sceneUIContainerRef else nil,
			NextSelectionUp = if not v61 then p8.props.NextSelectionUp else nil
		})
	end)
end
function v74.makeLeftFrame(p10, p11, p12, p13) -- line: 413
	-- upvalues: Roact (copy), SpringAnimatedItem (copy), mapValuesToPropsLeft (copy), t1 (copy), v61 (copy), AvatarPageButton (copy), Focusable (copy)
	local buttonsOffscreen = p10.state.buttonsOffscreen

	return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0.5, -p12 * 3 / 4, p11, 0)
		},
		animatedValues = {
			xPosition = 0.5,
			yPosition = buttonsOffscreen and p13 or 0.5
		},
		mapValuesToProps = mapValuesToPropsLeft,
		springOptions = t1,
		onComplete = p10.onComplete
	}, {
		AvatarPageButton = Roact.createElement(if not v61 then Focusable[AvatarPageButton] else AvatarPageButton, {
			onActivated = p10.showAvatarEditorCallback,
			transparencyModifier = p10.state.buttonTransparencyModifier,
			[Roact.Ref] = p10.avatarPageButtonRef,
			NextSelectionRight = if not v61 then p10.catalogPageButtonRef else nil,
			NextSelectionDown = if not v61 then p10.profilePictureEditorPageButtonRef else nil,
			NextSelectionUp = if not v61 then p10.topBarRef else nil
		})
	})
end
function v74.makeRightFrame(p14, p15, p16, p17) -- line: 449
	-- upvalues: Roact (copy), SpringAnimatedItem (copy), mapValuesToPropsRight (copy), t1 (copy), v61 (copy), CatalogPageButton (copy), Focusable (copy)
	local buttonsOffscreen = p14.state.buttonsOffscreen

	return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0.5, -p16 * 3 / 4, p15, 0)
		},
		animatedValues = {
			xPosition = 0.5,
			yPosition = buttonsOffscreen and p17 or 0.5
		},
		mapValuesToProps = mapValuesToPropsRight,
		springOptions = t1
	}, {
		CatalogPageButton = Roact.createElement(if not v61 then Focusable[CatalogPageButton] else CatalogPageButton, {
			onActivated = p14.showCatalogCallback,
			transparencyModifier = p14.state.buttonTransparencyModifier,
			[Roact.Ref] = p14.catalogPageButtonRef,
			NextSelectionLeft = if not v61 then p14.avatarPageButtonRef else nil,
			NextSelectionRight = if not v61 then p14.sceneUIContainerRef else nil,
			NextSelectionDown = if not v61 then p14.profilePictureEditorPageButtonRef else nil,
			NextSelectionUp = if not v61 then p14.topBarRef else nil
		})
	})
end
function v74.makeMiddleFrame(p18, p19, p20, p21) -- line: 485
	-- upvalues: Roact (copy), SpringAnimatedItem (copy), mapValuesToPropsMiddle (copy), t1 (copy), v61 (copy), ProfilePictureEditorPageButton (copy), Focusable (copy)
	local buttonsOffscreen = p18.state.buttonsOffscreen

	return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, -p20, p19, -p20 / 2)
		},
		animatedValues = {
			xPosition = 0.5,
			yPosition = buttonsOffscreen and p21 or 0.5
		},
		mapValuesToProps = mapValuesToPropsMiddle,
		springOptions = t1,
		onComplete = p18.onComplete
	}, {
		ProfilePictureEditorPageButton = Roact.createElement(if not v61 then Focusable[ProfilePictureEditorPageButton] else ProfilePictureEditorPageButton, {
			onActivated = p18.showProfilePictureEditorCallback,
			transparencyModifier = p18.state.buttonTransparencyModifier,
			[Roact.Ref] = p18.profilePictureEditorPageButtonRef,
			NextSelectionUp = if not v61 then p18.topFrameRef else nil
		})
	})
end
function v74.renderAvatarExperienceView(p22, p23) -- line: 519
	-- upvalues: DeviceOrientationMode (copy), Roact (copy), AvatarExperienceView (copy), v61 (copy), GetFFlagAllowAvatarLandingPageSearch (copy), NavigationEventsLogger (copy), OnFocusExperimentExposureLogger (copy), AXDisableAlwaysRenderedScreensIXP (copy), RoactNavigation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), GamepadFocusHandlerForPage (copy), Focusable (copy), Constants2 (copy)
	local v105 = p22.props.deviceOrientation == DeviceOrientationMode.Portrait
	local v106 = if not v105 then not v105 and 48 or 52 else not v105 and 48 or 52
	local v107 = not v105 and 0.33 or 0.528
	local v108 = not v105 and 0.16999999999999998 or 0.27199999999999996
	local v109 = not v105 and 0.5 or 0.8
	local n2 = 1
	local v111 = 0.5 + (0.5 + 0.5 * v109) / v107
	local v112 = 0.5 + (0.5 + 0.5 * v109) / v108

	return Roact.createElement(AvatarExperienceView, {
		topBar = p23 and p22:renderTopBar() or nil,
		ZIndex = 1,
		bottomBarEnabled = true,
		isSceneFullView = false,
		isUIFullView = false,
		isLandingPage = true,
		showRobuxBalance = false,
		[Roact.Ref] = p22.sceneUIContainerRef,
		NextSelectionLeft = if not v61 then if not GetFFlagAllowAvatarLandingPageSearch() then nil else p22.topBarRef else nil,
		NextSelectionDown = if not v61 then p22.pageButtonsRef else nil,
		NextSelectionUp = if not v61 then p22.props.NextSelectionUp else nil
	}, {
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "LandingPage"
		}),
		OnFocusExperimentExposureLogger = Roact.createElement(OnFocusExperimentExposureLogger, {
			ixpTests = { if not AXDisableAlwaysRenderedScreensIXP.isEnabled() then nil else AXDisableAlwaysRenderedScreensIXP }
		}),
		navigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
			onWillFocus = p22.onWillFocus,
			onWillBlur = p22.onWillBlur
		}),
		GamepadFocusHandlerForPage = if FFlagAXMigrateAXToGlobalAutofocus or not p22.props.shouldCaptureFocus then nil else Roact.createElement(GamepadFocusHandlerForPage, {
			focusController = p22.props.focusController
		}),
		Buttons = Roact.createElement(if not v61 then Focusable.Frame else "Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Ref] = p22.pageButtonsRef,
			NextSelectionUp = if not v61 then p22.sceneUIContainerRef else nil,
			defaultChild = if not v61 then p22.topFrameRef else nil,
			restorePreviousChildFocus = not v61 or nil
		}, {
			TopFrame = Roact.createElement(if not v61 then Focusable.Frame else "Frame", {
				Size = UDim2.new(1, 0, v107, 0),
				Position = UDim2.new(0, 0, v107 + 0.5 - v109 / 2, 0),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				[Roact.Ref] = p22.topFrameRef,
				defaultChild = if not v61 then p22.avatarPageButtonRef else nil,
				restorePreviousChildFocus = not v61 or nil
			}, {
				LeftFrame = p22:makeLeftFrame(n2, v106, v111),
				RightFrame = p22:makeRightFrame(n2, v106, v111),
				uiSizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, Constants2.LandingPageMinTopFrameHeightPix)
				})
			}),
			BottomFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, v108, 0),
				Position = UDim2.new(0, 0, 0.5 - v109 / 2 + v107, 0)
			}, {
				MiddleFrame = p22:makeMiddleFrame(n2, v106, v112),
				uiSizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, Constants2.LandingPageMinBottomFrameHeightPix)
				})
			})
		})
	})
end
function v74.renderMainView(p24) -- line: 610
	-- upvalues: DeviceOrientationMode (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	if p24.props.deviceOrientation ~= DeviceOrientationMode.Portrait then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[Roact.Ref] = p24.props.focusNavigationBindingsRef
		}, {
			LastInputTypeChangedConnection = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = p24.lastInputTypeChangedCallback
			}),
			TopBar = p24:renderTopBar(),
			AEView = p24:renderAvatarExperienceView(false)
		})
	end

	return p24:renderAvatarExperienceView(true)
end
function v74.render(p25) -- line: 632
	-- upvalues: Roact (copy), v61 (copy), Focusable (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	return Roact.createElement(if not v61 then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p25.props.focusController else nil,
		defaultChild = if not v61 then p25.pageButtonsRef else nil
	}, { p25:renderMainView() })
end
function v74.didMount(p26) -- line: 643
	p26.isMounted = true
end
function v74.didUpdate(p27, p28) -- line: 647
	-- upvalues: v62 (copy), isAvatarRouteVisible (copy)
	if v62 then
		local v118 = isAvatarRouteVisible(p28)
		local v119 = isAvatarRouteVisible(p27.props)

		if not v118 and v119 then
			p27:setState({
				buttonTransparencyModifier = 0
			})
			p27.transitionOnscreen()
		end
	end
end
function v74.willUnmount(p29) -- line: 664
	p29.isFocused = false
	p29.isMounted = false

	if p29.luaAppReloadPageEventConnection ~= nil then
		p29.luaAppReloadPageEventConnection:disconnect()
		p29.luaAppReloadPageEventConnection = nil
	end
end

local function mapStateToProps(p30, p31) -- line: 674
	return {
		avatarCategory = p30.AvatarExperience.AvatarEditor.Categories.category,
		avatarSubcategory = p30.AvatarExperience.AvatarEditor.Categories.subcategory,
		catalogCategory = p31.catalogCategory,
		catalogSubcategory = p31.catalogSubcategory,
		catalogCategoryId = p30.AvatarExperience.Catalog.Categories.categoryId,
		catalogSubcategoryId = p30.AvatarExperience.Catalog.Categories.subcategoryId,
		deviceOrientation = p30.DeviceOrientation,
		statusBarHeight = p30.TopBar.statusBarHeight
	}
end
local function mapDispatchToProps(p32) -- line: 687
	-- upvalues: SetCategoryAndSubcategory (copy), SetCategoryAndSubcategory2 (copy), SetFullView (copy), CatalogTilesLatencyTracker (copy)
	return {
		resetAvatarCategories = function(p33) -- line: 689
			-- upvalues: p32 (copy), SetCategoryAndSubcategory (copy)
			p32(SetCategoryAndSubcategory(1, nil, p33))
		end,
		resetCatalogCategories = function(p34) -- line: 693
			-- upvalues: p32 (copy), SetCategoryAndSubcategory2 (copy)
			p32(SetCategoryAndSubcategory2(1, nil, p34))
		end,
		setFullView = function(p35, p36, p37) -- line: 697
			-- upvalues: p32 (copy), SetFullView (copy)
			p32(SetFullView(p35, p36, p37))
		end,
		startPercievedCatalogTTITracker = function() -- line: 701
			-- upvalues: p32 (copy), CatalogTilesLatencyTracker (copy)
			p32(CatalogTilesLatencyTracker.PercievedTrackingStarted())
		end
	}
end

local v77 = withLastInputGroup(v74)
local v78 = RoactServices.connect({
	avatarAnalytics = Analytics,
	catalogAnalytics = Analytics2,
	avatarExperienceAnalytics = Analytics4,
	profilePictureEditorAnalytics = Analytics3
})(v77)
local u79 = withStackVisibilityWrapper((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v78)))

local function AvatarExperienceLandingPageContainer(p38) -- line: 720
	-- upvalues: useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFirstFocusableDescendantRef (copy), useDescendantHasFocus (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), Roact (copy), u79 (ref)
	local v125 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v126 = useFirstFocusableDescendantRef(v125)
	local v127 = useDescendantHasFocus(v125)
	local v128 = table.clone(p38)

	v128.NextSelectionUp = if not v125 then nil else v126
	v128.shouldCaptureFocus = not v127

	local v129 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef((if not p38.focusController then RoactGamepad.createFocusController() else p38.focusController)).current else nil
	local v130 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v129 else nil)
	local v131 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v130
	})

	v128.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v129 else nil
	v128.focusNavigationBindingsRef = v131
	v128.is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole

	local v132 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v133 = useSignalState(v132.selectedCategoryId)
	local v134 = useSignalState(v132.selectedSubcategoryId)

	v128.catalogCategoryId = v133
	v128.catalogSubcategoryId = v134

	return Roact.createElement(u79, v128)
end

return AvatarExperienceLandingPageContainer
