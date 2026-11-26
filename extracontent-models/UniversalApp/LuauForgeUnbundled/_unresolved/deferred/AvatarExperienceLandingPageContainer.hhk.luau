local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")

local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/gJz")
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/deferred/fDS")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
require("@luauforge/bundled/dKT")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module4 = require("@luauforge/deferred/gQM")
local module5 = require("@luauforge/bundled/egU")
local module6 = require("@luauforge/bundled/dFu")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module8 = require("@luauforge/deferred/gTt")
local module9 = require("@luauforge/deferred/hhl")
local module10 = require("@luauforge/deferred/hho")

local module11 = require("@luauforge/deferred/hhq")
local module12 = require("@luauforge/bundled/fvR")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local module14 = require("@luauforge/bundled/dPN")

local module15 = require("@luauforge/deferred/gRz")

local module16 = require("@luauforge/deferred/gRB")

local module17 = require("@luauforge/deferred/gJK")
local module18 = require("@luauforge/bundled/gSD")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

local module19 = require("@luauforge/deferred/gUI")

local module20 = require("@luauforge/deferred/gJZ")
local module21 = require("@luauforge/deferred/fCX")

local module22 = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceIdentifierEnum = module22.FocusNavigableSurfaceIdentifierEnum
local useRegistryEntry = module22.FocusNavigableSurfaceRegistry.useRegistryEntry
local useFirstFocusableDescendantRef = module22.useFirstFocusableDescendantRef
local useDescendantHasFocus = module22.useDescendantHasFocus

local module23 = require("@luauforge/deferred/gQN")
local module24 = require("@luauforge/deferred/gQQ")
local module25 = require("@luauforge/bundled/dWq")

local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem

local module26 = require("@luauforge/bundled/fyM")

local module27 = require("@luauforge/deferred/hhr")

local module28 = require("@luauforge/deferred/hfm")

local defineFastFlag = game:DefineFastFlag("AXMigrateLandingPageToAutoFocus", false)

local defineFastFlag2 = game:DefineFastFlag("AXFixLandingPageButtonsStuckOffscreen", false)

local fFlagAXMoveAllTabToWidgetOnly = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMoveAllTabToWidgetOnly
local module29 = require("@luauforge/bundled/gLF")
local ttiPerformanceManager = module29.TTIPerformanceManager
local widgetsPercievedTTIManager = module29.WidgetsPercievedTTIManager
local module30 = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface

local v5 = { dampingRatio = 0.8, frequency = 4 }

local function mapValuesToPropsLeft(p2)
	return {
		Position = UDim2.new(0.5, -13, p2.yPosition, 0)
	}
end

local function mapValuesToPropsRight(p2)
	return {
		Position = UDim2.new(0.5, 13, p2.yPosition, 0)
	}
end

local function mapValuesToPropsMiddle(p2)
	return {
		Position = UDim2.new(0.5, 0, p2.yPosition, 13)
	}
end

local extended = Roact.PureComponent:extend("AvatarExperienceLandingPage")

extended.validateProps = t.strictInterface({
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
	avatarRoute = avatarRoute.Interface,
	NextSelectionUp = t.optional(t.any),
	shouldCaptureFocus = t.boolean,
	is10ftUI = t.boolean,
	focusNavigationBindingsRef = t.callback
})

function extended:init()
	self.robuxBalanceRef = Roact.createRef()
	self.quickMenuRef = Roact.createRef()

	self.state = { buttonsOffscreen = false, buttonTransparencyModifier = 0 }

	self.luaAppReloadPageEventConnection = module5.ReloadPage:connect(function(p2)
		if p2 == module6.AvatarExperienceRoot then
			if self.props.is10ftUI then
				self.props.navigation.navigate(avatarScreen.AvatarExperienceLandingPage)
			else
				self.props.navigation.navigate(avatarScreen.Catalog)
			end
		end
	end)

	local lastInputType = UserInputService:GetLastInputType()

	function self.lastInputTypeChangedCallback(p2)
		local gamepadInput = isGamepadInput(p2)

		if gamepadInput ~= self.state.lastInputIsGamepad then
			self:setState({ lastInputIsGamepad = gamepadInput })
		end
	end

	self.state.lastInputIsGamepad = isGamepadInput(lastInputType)

	function self.updateButtonPositions()
		self:setState({ buttonsOffscreen = true })

		if self.motor then
			self.motor:setGoal(Otter.spring(1), { frequency = 3 })
		end
	end

	function self.showProfilePictureEditorCallback()
		self.props.profilePictureEditorAnalytics.profilePictureEditorOpenedFromLandingPage()

		self.updateButtonPositions()
		delay(0.2, function()
			if fFlagEditProfileImageV2Enabled then
				if self.isMounted then
					self.props.navigation.navigate(avatarScreen.EditProfileImage, {
						prevNavPage = avatarScreen.AvatarExperienceLandingPage,
						entryOrigin = fFlagAXPPEReturnToEntrySurface and {
							screenName = avatarScreen.AvatarExperienceLandingPage
						} or nil
					})
				end
			else
				self.props.navigation.navigate(avatarScreen.ProfilePictureEditorEmotes)
			end
		end)
	end

	function self.showAvatarEditorCallback()
		self.props.avatarAnalytics.avatarEditorOpenedFromLandingPage()

		self.updateButtonPositions()

		delay(0.2, function()
			if self.isMounted then
				self.props.navigation.navigate(avatarScreen.AvatarEditor)
			end
		end)
	end

	function self.showCatalogCallback()
		self.props.catalogAnalytics.catalogOpenedFromLandingPage()

		self.updateButtonPositions()

		if fFlagAXMoveAllTabToWidgetOnly then
			widgetsPercievedTTIManager.startPerceivedTracking()
		else
			ttiPerformanceManager.Surface.Marketplace.Root.startPerceivedTracking()
		end

		self.props.startPercievedCatalogTTITracker()
		delay(0.2, function()
			if self.isMounted then
				self.props.navigation.navigate(avatarScreen.Catalog)
			end
		end)
	end

	function self.transitionOnscreen()
		self:setState({ buttonsOffscreen = false })

		if self.motor then
			self.motor:setGoal(Otter.spring(0), { frequency = 3 })
		end
	end

	self.pageButtonsRef = Roact.createRef()
	self.catalogPageButtonRef = Roact.createRef()
	self.avatarPageButtonRef = Roact.createRef()
	self.topFrameRef = Roact.createRef()

	self.topBarRef = Roact.createRef()
	self.robuxButtonRef = Roact.createRef()

	self.profilePictureEditorPageButtonRef = Roact.createRef()
	self.topFrameRef = Roact.createRef()
	self.sceneUIContainerRef = Roact.createRef()

	function self.onComplete() end

	function self.onWillFocus()
		if not self.isMounted then
			return
		end

		self.isFocused = true

		self.motor = Otter.createSingleMotor(self.state.buttonTransparencyModifier)
		self.motor:onStep(function(p2)
			if self.isFocused or self.isMounted then
				self:setState({ buttonTransparencyModifier = p2 })
			end
		end)

		self.transitionOnscreen()
	end

	function self.onWillBlur()
		if self.motor then
			self.motor:destroy()

			if defineFastFlag2 then
				self.motor = nil
			end
		end

		self.isFocused = false
	end

	function self.resetCategoryNavigation()
		local avatarCategory = self.props.avatarCategory
		local avatarSubcategory = self.props.avatarSubcategory

		local catalogCategoryId = self.props.catalogCategoryId
		local catalogSubcategoryId = self.props.catalogSubcategoryId

		if avatarCategory ~= 1 or avatarSubcategory ~= 1 then
			self.props.resetAvatarCategories(self.props.avatarAnalytics)
		elseif catalogCategoryId ~= "1" or catalogSubcategoryId ~= "1" then
			self.props.resetCatalogCategories(self.props.catalogAnalytics)
		end
	end

	function self.setUIFullView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		self.props.setFullView(avatarExperienceAnalytics, avatarScreen.CatalogSearch, fullView.UIFullView)
	end
end

function extended:renderTopBar()
	local v6 = module27() and 2 or 0

	return withLocalization({ title = "CommonUI.Features.Label.Avatar" })(function(p2)
		local createElement = Roact.createElement
		local v7 = if defineFastFlag then module12.Container else focusable[module12.Container]
		local topBarRefsByRef = {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = p2.title,
			searchType = module27() and RobloxAppEnums.SearchTypes.Catalog or nil,
			transparentBackground = true,
			ZIndex = v6,
			onConfirmSearchCallback = module26() and self.setUIFullView or nil,
			rightItems = module27() and { module12.SearchButton } or {},
			[Roact.Ref] = self.topBarRef
		}
		local v8 = if not defineFastFlag then self.catalogPageButtonRef else nil
		topBarRefsByRef.NextSelectionDown = v8
		local v9 = if not defineFastFlag then self.sceneUIContainerRef else nil
		topBarRefsByRef.NextSelectionRight = v9
		local v10 = if not defineFastFlag then self.props.NextSelectionUp else nil
		topBarRefsByRef.NextSelectionUp = v10
		return createElement(v7, topBarRefsByRef)
	end)
end

function extended:makeLeftFrame(p2, p3, p4)
	local buttonsOffscreen = self.state.buttonsOffscreen

	local createElement = Roact.createElement
	local animatedFrame = springAnimatedItem.AnimatedFrame
	local v6 = {
		regularProps = {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0.5, -p3 * 3 / 4, p2, 0)
		},
		animatedValues = {
			xPosition = 0.5,
			yPosition = buttonsOffscreen and p4 or 0.5
		},
		mapValuesToProps = mapValuesToPropsLeft,
		springOptions = v5,
		onComplete = self.onComplete
	}

	local createElement2 = Roact.createElement
	local v8 = if defineFastFlag then module9 else focusable[module9]
	local avatarPageButtonRefsByRef = {
		["onActivated"] = nil,
		["onActivated"] = nil,
		onActivated = self.showAvatarEditorCallback,
		transparencyModifier = self.state.buttonTransparencyModifier,
		[Roact.Ref] = self.avatarPageButtonRef
	}
	local v9 = if not defineFastFlag then self.catalogPageButtonRef else nil
	avatarPageButtonRefsByRef.NextSelectionRight = v9

	local v10 = if not defineFastFlag then self.profilePictureEditorPageButtonRef else nil
	avatarPageButtonRefsByRef.NextSelectionDown = v10

	local v11 = if not defineFastFlag then self.topBarRef else nil
	avatarPageButtonRefsByRef.NextSelectionUp = v11
	return createElement(animatedFrame, v6, {
		AvatarPageButton = createElement2(v8, avatarPageButtonRefsByRef)
	})
end

function extended:makeRightFrame(p2, p3, p4)
	local buttonsOffscreen = self.state.buttonsOffscreen

	local createElement = Roact.createElement
	local animatedFrame = springAnimatedItem.AnimatedFrame
	local v6 = {
		regularProps = {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0.5, -p3 * 3 / 4, p2, 0)
		},
		animatedValues = {
			xPosition = 0.5,
			yPosition = buttonsOffscreen and p4 or 0.5
		},
		mapValuesToProps = mapValuesToPropsRight,
		springOptions = v5
	}

	local createElement2 = Roact.createElement
	local v8 = if defineFastFlag then module10 else focusable[module10]
	local catalogPageButtonRefsByRef = {
		["onActivated"] = nil,
		["onActivated"] = nil,
		onActivated = self.showCatalogCallback,
		transparencyModifier = self.state.buttonTransparencyModifier,
		[Roact.Ref] = self.catalogPageButtonRef
	}
	local v9 = if not defineFastFlag then self.avatarPageButtonRef else nil
	catalogPageButtonRefsByRef.NextSelectionLeft = v9
	local v10 = if not defineFastFlag then self.sceneUIContainerRef else nil
	catalogPageButtonRefsByRef.NextSelectionRight = v10

	local v11 = if not defineFastFlag then self.profilePictureEditorPageButtonRef else nil
	catalogPageButtonRefsByRef.NextSelectionDown = v11

	local v12 = if not defineFastFlag then self.topBarRef else nil
	catalogPageButtonRefsByRef.NextSelectionUp = v12
	return createElement(animatedFrame, v6, {
		CatalogPageButton = createElement2(v8, catalogPageButtonRefsByRef)
	})
end

function extended:makeMiddleFrame(p2, p3, p4)
	local buttonsOffscreen = self.state.buttonsOffscreen

	local createElement = Roact.createElement
	local animatedFrame = springAnimatedItem.AnimatedFrame
	local v6 = {
		regularProps = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, -p3, p2, -p3 / 2)
		},
		animatedValues = {
			xPosition = 0.5,
			yPosition = buttonsOffscreen and p4 or 0.5
		},
		mapValuesToProps = mapValuesToPropsMiddle,
		springOptions = v5,
		onComplete = self.onComplete
	}

	local createElement2 = Roact.createElement

	local v8 = if defineFastFlag then module11 else focusable[module11]
	local profilePictureEditorPageButtonRefsByRef = {
		onActivated = self.showProfilePictureEditorCallback,
		transparencyModifier = self.state.buttonTransparencyModifier,
		[Roact.Ref] = self.profilePictureEditorPageButtonRef
	}
	local v9 = if not defineFastFlag then self.topFrameRef else nil
	profilePictureEditorPageButtonRefsByRef.NextSelectionUp = v9
	return createElement(animatedFrame, v6, {
		ProfilePictureEditorPageButton = createElement2(v8, profilePictureEditorPageButtonRefsByRef)
	})
end

function extended:renderAvatarExperienceView(p2)
	local v6 = self.props.deviceOrientation == deviceOrientationMode.Portrait
	local v7 = v6 and 52 or 48
	local v8 = v6 and 0.528 or 0.33
	local v9 = v6 and 0.27199999999999996 or 0.16999999999999998
	local v10 = v6 and 0.8 or 0.5
	local v11 = 1

	local v12 = 0.5 + (0.5 + 0.5 * v10) / v8
	local v13 = 0.5 + (0.5 + 0.5 * v10) / v9

	local createElement = Roact.createElement
	local v15 = if p2 then self:renderTopBar() or nil else nil
	local sceneUIContainerRefsByRef = {
		["topBar"] = nil,
		topBar = v15,
		ZIndex = 1,
		bottomBarEnabled = true,
		isSceneFullView = false,
		isUIFullView = false,
		isLandingPage = true,
		showRobuxBalance = false,
		[Roact.Ref] = self.sceneUIContainerRef
	}

	local v16 = if not (defineFastFlag or not module27()) then self.topBarRef else nil
	sceneUIContainerRefsByRef.NextSelectionLeft = v16

	local v17 = if not defineFastFlag then self.pageButtonsRef else nil
	sceneUIContainerRefsByRef.NextSelectionDown = v17
	local v18 = if not defineFastFlag then self.props.NextSelectionUp else nil
	sceneUIContainerRefsByRef.NextSelectionUp = v18
	local children = {
		NavigationEventsLogger = Roact.createElement(module17, {
			pageName = "LandingPage"
		}),
		OnFocusExperimentExposureLogger = Roact.createElement(module19, {
			ixpTests = { if module28.isEnabled() then module28 else nil }
		}),
		navigationEvents = Roact.createElement(RoactNavigation.NavigationEvents, {
			onWillFocus = self.onWillFocus,
			onWillBlur = self.onWillBlur
		}),
		Buttons = 0
	}

	local createElement3 = Roact.createElement
	local v23 = defineFastFlag and "Frame" or focusable.Frame
	local pageButtonsRefsByRef = {
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Ref] = self.pageButtonsRef
	}
	local v24 = if not defineFastFlag then self.sceneUIContainerRef else nil
	pageButtonsRefsByRef.NextSelectionUp = v24
	local v25 = if not defineFastFlag then self.topFrameRef else nil
	pageButtonsRefsByRef.defaultChild = v25
	pageButtonsRefsByRef.restorePreviousChildFocus = not defineFastFlag or nil

	local createElement4 = Roact.createElement
	local v26 = defineFastFlag and "Frame" or focusable.Frame
	local topFrameRefsByRef = {
		Size = UDim2.new(1, 0, v8, 0),
		Position = UDim2.new(0, 0, v8 + 0.5 - v10 / 2, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		[Roact.Ref] = self.topFrameRef
	}
	local v27 = if not defineFastFlag then self.avatarPageButtonRef else nil
	topFrameRefsByRef.defaultChild = v27
	topFrameRefsByRef.restorePreviousChildFocus = not defineFastFlag or nil
	children.Buttons = createElement3(v23, pageButtonsRefsByRef, {
		TopFrame = createElement4(v26, topFrameRefsByRef, {
			LeftFrame = self:makeLeftFrame(v11, v7, v12),
			RightFrame = self:makeRightFrame(v11, v7, v12),
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, module14.LandingPageMinTopFrameHeightPix)
			})
		}),
		BottomFrame = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, v9, 0),
			Position = UDim2.new(0, 0, 0.5 - v10 / 2 + v8, 0),
			BackgroundTransparency = 1
		}, {
			MiddleFrame = self:makeMiddleFrame(v11, v7, v13),
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, module14.LandingPageMinBottomFrameHeightPix)
			})
		})
	})
	return createElement(module8, sceneUIContainerRefsByRef, children)
end

function extended:renderMainView()
	if self.props.deviceOrientation == deviceOrientationMode.Portrait then
		return self:renderAvatarExperienceView(true)
	end

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[Roact.Ref] = self.props.focusNavigationBindingsRef
		},
		{
			LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = self.lastInputTypeChangedCallback
			}),
			TopBar = self:renderTopBar(),
			AEView = self:renderAvatarExperienceView(false)
		}
	)
end

function extended:render()
	local createElement = Roact.createElement
	local v6 = defineFastFlag and "Frame" or focusable.Frame
	local v7 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		defaultChild = 0
	}
	local v8 = if not defineFastFlag then self.pageButtonsRef else nil
	v7.defaultChild = v8
	return createElement(v6, v7, { self:renderMainView() })
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(object, p2)
	if defineFastFlag2 then
		local v6 = module16(p2)
		local v7 = module16(object.props)

		if not v6 and v7 then
			object:setState({ buttonTransparencyModifier = 0 })

			object.transitionOnscreen()
		end
	end
end

function extended:willUnmount()
	self.isFocused = false
	self.isMounted = false

	if self.luaAppReloadPageEventConnection ~= nil then
		self.luaAppReloadPageEventConnection:disconnect()
		self.luaAppReloadPageEventConnection = nil
	end
end

local function mapStateToProps(data, p2)
	return {
		avatarCategory = data.AvatarExperience.AvatarEditor.Categories.category,
		avatarSubcategory = data.AvatarExperience.AvatarEditor.Categories.subcategory,
		catalogCategory = p2.catalogCategory,
		catalogSubcategory = p2.catalogSubcategory,
		catalogCategoryId = data.AvatarExperience.Catalog.Categories.categoryId,
		catalogSubcategoryId = data.AvatarExperience.Catalog.Categories.subcategoryId,
		deviceOrientation = data.DeviceOrientation,
		statusBarHeight = data.TopBar.statusBarHeight
	}
end

local function mapDispatchToProps(callback)
	return {
		resetAvatarCategories = function(p2)
			callback(module20(1, nil, p2))
		end,
		resetCatalogCategories = function(p2)
			callback(module21(1, nil, p2))
		end,
		setFullView = function(p2, p3, p4)
			callback(module18(p2, p3, p4))
		end,
		startPercievedCatalogTTITracker = function()
			callback(module25.PercievedTrackingStarted())
		end
	}
end

local v6 = module4(extended)

local v7 = roactServices.connect({
	avatarAnalytics = module,
	catalogAnalytics = module2,
	avatarExperienceAnalytics = avatarExperienceAnalyticsService,
	profilePictureEditorAnalytics = module3
})(v6)

local v8 = module15((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v7)))

local function AvatarExperienceLandingPageContainer(p2)
	local v9 = useRegistryEntry(focusNavigableSurfaceIdentifierEnum.NavBar)
	local v10 = useFirstFocusableDescendantRef(v9)
	local v11 = useDescendantHasFocus(v9)

	local clone = table.clone(p2)

	if not v9 then
		v10 = nil
	end

	clone.NextSelectionUp = v10
	clone.shouldCaptureFocus = not v11

	clone.focusNavigationBindingsRef = module23({ overlayClosedCallback = module24() })
	clone.is10ftUI = false

	local catalogSelectionStore = module30.getCatalogSelectionStore()
	local v13 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v14 = useSignalState(catalogSelectionStore.selectedSubcategoryId)

	clone.catalogCategoryId = v13
	clone.catalogSubcategoryId = v14

	return Roact.createElement(v8, clone)
end

return AvatarExperienceLandingPageContainer
