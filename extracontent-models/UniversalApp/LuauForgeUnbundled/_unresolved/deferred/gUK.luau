local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require("@luauforge/bundled/dKT")

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local module = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local module2 = require("@luauforge/deferred/gTv")

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local module3 = require("@luauforge/bundled/fCe")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectShowColorQuickButton = AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigationFocus
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module7 = require("@luauforge/bundled/gJS")
local selectTopBarHeight = require("@luauforge/bundled/fvR").selectTopBarHeight
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local module8 = require("@luauforge/deferred/gUL")
local module9 = require("@luauforge/deferred/gUP")

local module10 = require("@luauforge/deferred/gUQ")
local module11 = require("@luauforge/deferred/gVg")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module12 = require("@luauforge/bundled/dPR")
local module13 = require("@luauforge/bundled/gVh")
local module14 = require("@luauforge/bundled/fCk")
local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local module15 = require("@luauforge/bundled/gVi")

local module16 = require("@luauforge/bundled/dSW")

local function ProfilePictureQuickButton(props)
	return React.createElement(module11, {
		isUIFullView = props.isUIFullView,
		isSceneFullView = props.isSceneFullView,
		layoutOrder = props.layoutOrder,
		ref = props.profilePictureButtonRef,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionDown = props.refinementButtonsRef
	})
end

local function RefinementEntryQuickButton(props)
	local v6 = useAvatarRoute()

	local v7 = if module15() then useUiModeInfo().uiMode == uiMode.TenFoot else nil

	local avatarScreenProperty = avatarScreenProperties[v6.opaque.name]
	local v8 = if avatarScreenProperty then not avatarScreenProperty.isRefinementPage else false

	local v9 = if module15() then not v7 else module12.useTestVariables(module13.EnabledForUser)

	if not v8 then
		return v8
	end

	local createElement = React.createElement
	local v11 = {
		layoutOrder = props.layoutOrder,
		ref = props.refinementButtonsRef,
		NextSelectionUp = 0,
		NextSelectionLeft = 0,
		NextSelectionDown = 0
	}
	local v12 = if v9 then props.profilePictureButtonRef else nil
	v11.NextSelectionUp = v12
	v11.NextSelectionLeft = props.NextSelectionLeft
	v11.NextSelectionDown = props.NextSelectionDown
	v8 = createElement(module8, v11)
	return v8
end

local function CameraQuickButton(props)
	local v6 = module12.useTestVariables(module14.EnabledForUser)

	local v7 = useSignalState(module16.getCatalogSelectionStore().selectedCategoryInfo)

	if v6 and not isVRAppBuild() then
		return (React.createElement(module10, {
			isUIFullView = props.isUIFullView,
			isSceneFullView = props.isSceneFullView,
			layoutOrder = props.layoutOrder,
			selectedCategoryInfo = v7
		}))
	end

	return nil
end

return (React.forwardRef(function(props, ref)
	local v6 = useTokens()
	local v7 = useAvatarRoute()
	local v8 = useNavigation()
	local v9 = useNavigationFocus()

	local v10 = if module15() then useUiModeInfo().uiMode == uiMode.TenFoot else nil

	local name = v7.opaque.name

	local avatarSceneButtonsVisible = module3.isAvatarSceneButtonsVisible(
		v7,
		v9,
		props.isUIFullView,
		props.isSceneFullView,
		v8
	)

	local v11 = useAppPolicy(function(p2)
		return p2.getAllowCameraMovements()
	end)

	local v12 = useSelector(module7, getUseSelectorDeepEquals())
	local v13 = useSelector(selectTopBarHeight, getUseSelectorDeepEquals())
	local v14 = useSelector(selectShowColorQuickButton, getUseSelectorDeepEquals())
	local v15 = useSelector(selectColorAdjustmentButtonColor, getUseSelectorDeepEquals())

	local v16 = React.useCallback(function()
		v8.navigate(avatarScreen.ColorAdjustment)
	end, { v8 })
	local v17

	if v12 then
		v17 = 0
	else
		v17 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module.LandscapeNavWidth
	end

	local v18 = if module15() then not v10 else module12.useTestVariables(module13.EnabledForUser)

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local v19

	if v18 and (name == avatarScreen.AvatarEditor or name == avatarScreen.Catalog) then
		v19 = ref2
	else
		v19 = ref3
	end

	local v20 = (not axRecentlyViewedSearchItemsIXPTest.isEnabled() or name ~= avatarScreen.SearchLandingFocusedWidgetPage or not (v6 and v12))
		and 24
		or v6.Size.Size_400

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v21 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = 0,
		Size = 0,
		Visible = 0,
		ref = 0,
		defaultChild = 0
	}

	local newUDim2 = UDim2.new

	local v23 = if module2 and v6 and not v12 then v6.Size.Size_400 else v13 + 4
	v21.Position = newUDim2(v17, v20, 0, v23)

	v21.Size = UDim2.fromOffset(44, 0)
	v21.Visible = avatarSceneButtonsVisible
	v21.ref = ref
	v21.defaultChild = v19
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		ProfilePictureButton = 0,
		RefinementEntryButton = 0,
		UniversalAppCameraButton = 0,
		ColorAdjustmentQuickButton = 0
	}

	local v24 = if v18 and v11 then React.createElement(
		ProfilePictureQuickButton,
		Cryo.Dictionary.join(props, {
			layoutOrder = 1,
			profilePictureButtonRef = ref2,
			refinementButtonsRef = ref3
		})
	) else nil
	children.ProfilePictureButton = v24

	children.RefinementEntryButton = React.createElement(
		RefinementEntryQuickButton,
		Cryo.Dictionary.join(props, {
			layoutOrder = 2,
			profilePictureButtonRef = ref2,
			refinementButtonsRef = ref3,
			NextSelectionDown = if v14 then ref4 else nil
		})
	)

	children.UniversalAppCameraButton = React.createElement(
		CameraQuickButton,
		Cryo.Dictionary.join(props, { layoutOrder = 3 })
	)

	local v28 = if v14 then React.createElement(module9, {
		colors = { v15 },
		onActivated = v16,
		ref = ref4,
		LayoutOrder = 4,
		NextSelectionUp = ref3,
		NextSelectionLeft = props.NextSelectionLeft
	}) else nil
	children.ColorAdjustmentQuickButton = v28
	return createElement(frame, v21, children)
end))
