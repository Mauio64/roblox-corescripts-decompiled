local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require("@luauforge/bundled/dHK")

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local module = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane
local module2 = require("@luauforge/deferred/goS")

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module3 = require("@luauforge/bundled/fuD")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local fFlagAXColorAdjustmentButtonShouldAccountForTryOns = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local v6

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v6 = AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton
else
	v6 = require("@luauforge/deferred/gqi")
end

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigationFocus
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module7 = require("@luauforge/bundled/gfm")
local selectTopBarHeight = require("@luauforge/bundled/fox").selectTopBarHeight
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local module8 = require("@luauforge/deferred/gqk")
local module9 = require("@luauforge/deferred/gqo")

local module10 = require("@luauforge/deferred/gqp")
local module11 = require("@luauforge/deferred/gqF")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module12 = require("@luauforge/bundled/dMB")
local module13 = require("@luauforge/bundled/gqG")
local module14 = require("@luauforge/bundled/fuJ")
local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local module15 = require("@luauforge/bundled/gqH")

local module16 = require("@luauforge/bundled/dPG")

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
	local v7 = useAvatarRoute()

	local v8 = if module15() then useUiModeInfo().uiMode == uiMode.TenFoot else nil

	local avatarScreenProperty = avatarScreenProperties[v7.opaque.name]
	local v9 = if avatarScreenProperty then not avatarScreenProperty.isRefinementPage else false

	local v10 = if module15() then not v8 else module12.useTestVariables(module13.EnabledForUser)

	if not v9 then
		return v9
	end

	local createElement = React.createElement
	local v12 = {
		layoutOrder = props.layoutOrder,
		ref = props.refinementButtonsRef,
		NextSelectionUp = 0,
		NextSelectionLeft = 0,
		NextSelectionDown = 0
	}
	local v13 = if v10 then props.profilePictureButtonRef else nil
	v12.NextSelectionUp = v13
	v12.NextSelectionLeft = props.NextSelectionLeft
	v12.NextSelectionDown = props.NextSelectionDown
	v9 = createElement(module8, v12)
	return v9
end

local function CameraQuickButton(props)
	local v7 = module12.useTestVariables(module14.EnabledForUser)

	local v8 = useSignalState(module16.getCatalogSelectionStore().selectedCategoryInfo)

	if v7 and not isVRAppBuild() then
		return (React.createElement(module10, {
			isUIFullView = props.isUIFullView,
			isSceneFullView = props.isSceneFullView,
			layoutOrder = props.layoutOrder,
			selectedCategoryInfo = v8
		}))
	end

	return nil
end

return (React.forwardRef(function(props, ref)
	local v7 = useTokens()
	local v8 = useAvatarRoute()
	local v9 = useNavigation()
	local v10 = useNavigationFocus()

	local v11 = if module15() then useUiModeInfo().uiMode == uiMode.TenFoot else nil

	local name = v8.opaque.name

	local avatarSceneButtonsVisible = module3.isAvatarSceneButtonsVisible(
		v8,
		v10,
		props.isUIFullView,
		props.isSceneFullView,
		v9
	)

	local v12 = useAppPolicy(function(p2)
		return p2.getAllowCameraMovements()
	end)

	local v13 = useSelector(module7, getUseSelectorDeepEquals())
	local v14 = useSelector(selectTopBarHeight, getUseSelectorDeepEquals())
	local v15 = useSelector(v6, getUseSelectorDeepEquals())
	local v16 = useSelector(selectColorAdjustmentButtonColor, getUseSelectorDeepEquals())

	local v17 = React.useCallback(function()
		v9.navigate(avatarScreen.ColorAdjustment)
	end, { v9 })
	local v18

	if v13 then
		v18 = 0
	else
		v18 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module.LandscapeNavWidth
	end

	local v19 = if module15() then not v11 else module12.useTestVariables(module13.EnabledForUser)

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local v20

	if v19 and (name == avatarScreen.AvatarEditor or name == avatarScreen.Catalog) then
		v20 = ref2
	else
		v20 = ref3
	end

	local v21 = (not axRecentlyViewedSearchItemsIXPTest.isEnabled() or name ~= avatarScreen.SearchLandingFocusedWidgetPage or not (v7 and v13))
		and 24
		or v7.Size.Size_400

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v22 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = 0,
		Size = 0,
		Visible = 0,
		ref = 0,
		defaultChild = 0
	}

	local newUDim2 = UDim2.new

	local v24 = if module2 and v7 and not v13 then v7.Size.Size_400 else v14 + 4
	v22.Position = newUDim2(v18, v21, 0, v24)

	v22.Size = UDim2.fromOffset(44, 0)
	v22.Visible = avatarSceneButtonsVisible
	v22.ref = ref
	v22.defaultChild = v20
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

	local v25 = if v19 and v12 then React.createElement(
		ProfilePictureQuickButton,
		Cryo.Dictionary.join(props, {
			layoutOrder = 1,
			profilePictureButtonRef = ref2,
			refinementButtonsRef = ref3
		})
	) else nil
	children.ProfilePictureButton = v25

	children.RefinementEntryButton = React.createElement(
		RefinementEntryQuickButton,
		Cryo.Dictionary.join(props, {
			layoutOrder = 2,
			profilePictureButtonRef = ref2,
			refinementButtonsRef = ref3,
			NextSelectionDown = if v15 then ref4 else nil
		})
	)

	children.UniversalAppCameraButton = React.createElement(
		CameraQuickButton,
		Cryo.Dictionary.join(props, { layoutOrder = 3 })
	)

	local v29 = if v15 then React.createElement(module9, {
		colors = { v16 },
		onActivated = v17,
		ref = ref4,
		LayoutOrder = 4,
		NextSelectionUp = ref3,
		NextSelectionLeft = props.NextSelectionLeft
	}) else nil
	children.ColorAdjustmentQuickButton = v29
	return createElement(frame, v22, children)
end))
