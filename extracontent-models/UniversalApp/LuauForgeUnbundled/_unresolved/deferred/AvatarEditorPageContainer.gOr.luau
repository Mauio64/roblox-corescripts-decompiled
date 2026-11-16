local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module4 = require("@luauforge/bundled/fvF")
local module5 = require("@luauforge/deferred/goQ")
local module6 = require("@luauforge/deferred/gOs")

local module7 = require("@luauforge/deferred/gfe")

local module8 = require("@luauforge/deferred/gmV")
local module9 = require("@luauforge/bundled/dTM")
local module10 = require("@luauforge/deferred/fuT")
local module11 = require("@luauforge/bundled/gnZ")
local fullView = AvatarExperienceCommon.Enums.FullView
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local externalEventConnection = RoactUtils.ExternalEventConnection
local isGamepadInput = RoactUtils.isGamepadInput
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local module13 = require("@luauforge/bundled/gfm")
local module14 = require("@luauforge/bundled/goe")

local module15 = require("@luauforge/bundled/fuD")

local module16 = require("@luauforge/deferred/gTe")
local module17 = require("@luauforge/bundled/dNa")
local module18 = require("@luauforge/deferred/gmB")

local module19 = require("@luauforge/deferred/gqf")

local module20 = require("@luauforge/deferred/gTf")
local module21 = require("@luauforge/deferred/gmj")
local module22 = require("@luauforge/deferred/gmk")
local module23 = require("@luauforge/deferred/gml")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local useRoactService = RobloxAppHooks.useRoactService
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local module25 = require("@luauforge/bundled/dMB")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

local module26 = require("@luauforge/deferred/gTg")

local module27 = require("@luauforge/bundled/fuJ")
local module28 = require("@luauforge/deferred/gmC")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module29 = require("@luauforge/bundled/dMx")

local module30 = require("@luauforge/deferred/gTr")

local module31 = require("@luauforge/deferred/gTs")

local module32 = require("@luauforge/deferred/gTt")

local module33 = require("@luauforge/deferred/gTu")

local fFlagAXTimeoutAcknowledgementGating = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXTimeoutAcknowledgementGating

local module34 = require("@luauforge/deferred/gTv")

local extended = Roact.PureComponent:extend("AvatarEditorPage")

function extended:init()
	self.topBarRef = Roact.createRef()
	self.sceneUIContainerRef = Roact.createRef()
	self.refinementButtonsRef = Roact.createRef()
	self.quickButtonsRef = Roact.createRef()

	self:setState({
		lastInputIsGamepad = isGamepadInput((UserInputService:GetLastInputType()))
	})

	function self.changeView()
		local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics

		local newFullViewEnum = module15.getNewFullViewEnum(self.props.fullView)
		self.props.setFullView(
			avatarExperienceAnalytics,
			self.props.avatarRoute.opaque.name,
			newFullViewEnum
		)
	end

	self.defaultChildRef = Roact.createRef()

	function self.lastInputTypeChangedCallback(p2)
		local gamepadInput = isGamepadInput(p2)

		if gamepadInput ~= self.state.lastInputIsGamepad then
			self:setState({ lastInputIsGamepad = gamepadInput })
		end
	end

	sendAXCounterV2(module29.Counter.TopLevelPageInitialView.Editor)
end

if module31 then
	function extended.didMount(p2)
		local logLayerExposure = module25.logLayerExposure

		local v5 = if module32 then module33() else appUserLayers.AvatarExperienceUAAllViews
		logLayerExposure(v5)
	end
end

function extended.render(props)
	local v5 = props.props.fullView == fullView.SceneFullView
	local v6 = props.props.fullView == fullView.UIFullView

	local quickButtonsRef = props.quickButtonsRef

	local createElement = Roact.createElement
	local refsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Ref] = props.ref
	}
	local children = {
		UniversalAppCameraExposure = Roact.createElement(module18, {
			ixpTest = module27
		}),
		OnFocusExperimentExposureLogger = 0,
		EditorExposure = 0,
		LastInputTypeChangedConnection = 0,
		NavigationEventsLogger = 0,
		AvatarExperienceView = 0
	}

	local createElement2 = Roact.createElement

	local v11 = if module16.isEnabled() then module16 else nil
	local v12 = if module17.isEnabled() then module17 else nil
	children.OnFocusExperimentExposureLogger = createElement2(module19, {
		ixpTests = { v11, v12 }
	})

	local v13 = if not module30() then Roact.createElement(module18, {
		ixpTest = module28.Editor
	}) else nil
	children.EditorExposure = v13

	children.LastInputTypeChangedConnection = Roact.createElement(externalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = props.lastInputTypeChangedCallback
	})

	children.NavigationEventsLogger = Roact.createElement(module7, {
		pageName = "AvatarEditor"
	})

	children.AvatarExperienceView = Roact.createElement(module5, {
		allowAdaptiveScrolling = true,
		bottomBarEnabled = false,
		changeViewFunction = props.changeView,
		isSceneFullView = v5,
		isUIFullView = v6,
		topBar = React.createElement(module26, {
			showManageOutfitButton = props.props.showManageOutfitButton,
			overlayClosedCallback = props.props.overlayClosedCallback,
			topBarRef = props.topBarRef,
			NextSelectionDown = props.defaultChildRef,
			NextSelectionRight = props.sceneUIContainerRef,
			navigation = props.props.navigation,
			avatarRoute = props.props.avatarRoute
		}),
		refinementButtonsRef = props.refinementButtonsRef,
		quickButtonsRef = props.quickButtonsRef,
		ref = props.sceneUIContainerRef,
		NextSelectionDown = props.defaultChildRef,
		NextSelectionLeft = props.topBarRef,
		defaultChildRef = props.defaultChildRef
	}, {
		AvatarNavigationItemsView = Roact.createElement(module6, {
			defaultChildRef = props.defaultChildRef,
			NextSelectionUp = props.topBarRef,
			NextSelectionRight = quickButtonsRef
		})
	})
	return createElement("Frame", refsByRef, children)
end

local v5 = roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService
})(extended)

local v6 = module8((RoactRodux.connect(function(p2, p3)
	local avatarEditorCategoryInfoFromState = module15.getAvatarEditorCategoryInfoFromState(p2)

	return {
		fullView = module14(p2, avatarScreen.AvatarEditor),
		isPortrait = module13(p2),
		itemDetailsExpanded = p2.AvatarExperience.Common.ItemDetailsExpanded,
		showManageOutfitButton = avatarEditorCategoryInfoFromState.ManageOutfitsEnabled == true,
		isCurrentUserAllowedToCreateShares = p2.AvatarExperience.Catalog.Metadata.isCurrentUserAllowedToCreateShares
	}
end, function(callback)
	return {
		setFullView = function(p2, p3, p4)
			callback(module11(p2, p3, p4))
		end
	}
end)(v5)))

local function AvatarEditorPageContainer(p2)
	React.useEffect(function()
		local v7 = module34(false)

		if v7 then
			v7.getInventory(false)
		end
	end, {})

	local v7 = module23()

	local v8 = useDispatch()
	local v9 = useRoactService(module4)
	local v10 = useRoactService(module)
	local v11 = module22()
	local v12 = useAvatarRoute()
	local v13 = v12.current.name == avatarScreen.ItemDetails

	if fFlagAXTimeoutAcknowledgementGating then
		AvatarExperienceCommon.Hooks.useAvatarChangeAcknowledgementPrompt(v12.isVisible and module15.isRouteInAvatarEditor(v12))
	end

	local v14 = module21(v7)

	local v15 = React.useCallback(function(p3)
		p3.cancelled = true
		module9.closeFocusedScreen(p2.navigation)
	end, { p2.navigation })

	local v16 = React.useCallback(function()
		v8(module10(v10, v9, v7, p2.navigation, v12))
	end, { v8, v10, v9, v7, p2.navigation, v12 })

	local v17 = React.useCallback(function()
		p2.navigation.navigate(avatarScreen.CatalogContextMenu, {
			itemId = v12.current.params.itemId,
			itemType = v12.current.params.itemType,
			onOverlayClosed = v7
		})
	end, { p2.navigation, v12, v7 })

	if not v11 then
		v14 = nil
	end

	if not v13 then
		v16 = nil
	end

	if not v13 then
		v17 = nil
	end

	local v20 = module20({
		onNavigateBack = v15,
		onOpenQuickMenu = v14,
		onOpenBuyItemPrompt = v16,
		onOpenContextMenu = v17
	})

	local joined = Cryo.Dictionary.join(p2, {
		overlayClosedCallback = v7,
		is10ftUI = useUiModeInfo().uiMode == uiMode.TenFoot
	})

	return React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ref = v20 },
		React.createElement(v6, joined)
	)
end

return AvatarEditorPageContainer
