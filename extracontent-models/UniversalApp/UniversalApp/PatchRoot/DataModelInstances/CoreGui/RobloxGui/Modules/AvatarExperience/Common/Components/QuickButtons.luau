local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local v15 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectShowColorQuickButton) else AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useNavigationFocus = require(CorePackages.Workspace.Packages.Navigation).useNavigationFocus
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local selectTopBarHeight = require(Modules.LuaApp.Components.TopBar.TopBar).selectTopBarHeight
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local SetSelectedAccessory = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetSelectedAccessory)
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage = require(Modules.AvatarExperience.Flags.GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage)
local useAccessoryAdjustmentQuickButtonDuringTryOn = require(Modules.AvatarExperience.Common.Hooks.useAccessoryAdjustmentQuickButtonDuringTryOn)
local RefinementEntryButton = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementEntryButton)
local ColorAdjustmentEntryButton = require(Modules.AvatarExperience.Common.Components.ColorAdjustmentEntryButton)
local AccessoryAdjustmentEntryButton = require(Modules.AvatarExperience.Common.Components.AccessoryAdjustmentEntryButton)
local UniversalAppCameraToggle = require(Modules.AvatarExperience.UniversalAppCamera.Components.UniversalAppCameraToggle)
local AXProfilePictureQuickButton = require(Modules.AvatarExperience.Common.Components.AXProfilePictureQuickButton)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXAlternateLandingPageIXP = require(Modules.AvatarExperience.Flags.AXAlternateLandingPageIXP)
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local GetFFlagCleanUpAXAlternativeLandingPageIXP = require(Modules.AvatarExperience.Flags.GetFFlagCleanUpAXAlternativeLandingPageIXP)
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

local function ProfilePictureQuickButton(p1) -- line: 95
	-- upvalues: React (copy), AXProfilePictureQuickButton (copy)
	return React.createElement(AXProfilePictureQuickButton, {
		isUIFullView = p1.isUIFullView,
		isSceneFullView = p1.isSceneFullView,
		layoutOrder = p1.layoutOrder,
		ref = p1.profilePictureButtonRef,
		NextSelectionLeft = p1.NextSelectionLeft,
		NextSelectionDown = p1.refinementButtonsRef
	})
end
local function RefinementEntryQuickButton(p2) -- line: 106
	-- upvalues: useAvatarRoute (copy), GetFFlagCleanUpAXAlternativeLandingPageIXP (copy), useUiModeInfo (copy), UiMode (copy), AvatarScreenProperties (copy), IxpUtils (copy), AXAlternateLandingPageIXP (copy), React (copy), RefinementEntryButton (copy)
	local v50 = useAvatarRoute()
	local v51 = nil

	if GetFFlagCleanUpAXAlternativeLandingPageIXP() then
		v51 = useUiModeInfo().uiMode == UiMode.TenFoot
	end

	local v52 = AvatarScreenProperties[v50.opaque.name]
	local v53 = not not v52 and not v52.isRefinementPage
	local v54 = if not GetFFlagCleanUpAXAlternativeLandingPageIXP() then IxpUtils.useTestVariables(AXAlternateLandingPageIXP.EnabledForUser) else not v51

	return v53 and React.createElement(RefinementEntryButton, {
		layoutOrder = p2.layoutOrder,
		ref = p2.refinementButtonsRef,
		NextSelectionUp = if not v54 then nil else p2.profilePictureButtonRef,
		NextSelectionLeft = p2.NextSelectionLeft,
		NextSelectionDown = p2.NextSelectionDown
	})
end
local function CameraQuickButton(p3) -- line: 132
	-- upvalues: IxpUtils (copy), UniversalAppCameraIXPTest (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), IsVRAppBuild (copy), React (copy), UniversalAppCameraToggle (copy)
	local v56 = IxpUtils.useTestVariables(UniversalAppCameraIXPTest.EnabledForUser)
	local v57 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v58 = useSignalState(v57.selectedCategoryInfo)

	if v56 and not IsVRAppBuild() then
		return (React.createElement(UniversalAppCameraToggle, {
			isUIFullView = p3.isUIFullView,
			isSceneFullView = p3.isSceneFullView,
			layoutOrder = p3.layoutOrder,
			selectedCategoryInfo = v58
		}))
	end

	return nil
end

return (React.forwardRef(function(t1: {[any]: any}, p4) -- line: 149
	-- upvalues: AXRecentlyViewedSearchItemsIXPTest (copy), useTokens (copy), useAvatarRoute (copy), useNavigation (copy), useDispatch (copy), useNavigationFocus (copy), GetFFlagCleanUpAXAlternativeLandingPageIXP (copy), useUiModeInfo (copy), UiMode (copy), Utils (copy), useAppPolicy (copy), useSelector (copy), selectIsPortrait (copy), getUseSelectorDeepEquals (copy), selectTopBarHeight (copy), v15 (copy), selectColorAdjustmentButtonColor (copy), React (copy), AvatarScreen (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), useAccessoryAdjustmentQuickButtonDuringTryOn (copy), GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage (copy), SetEntryPage (copy), SetSelectedAccessory (copy), Constants (copy), IxpUtils (copy), AXAlternateLandingPageIXP (copy), RoactGamepad (copy), ProfilePictureQuickButton (copy), Cryo (copy), RefinementEntryQuickButton (copy), CameraQuickButton (copy), ColorAdjustmentEntryButton (copy), AccessoryAdjustmentEntryButton (copy)
	local v61 = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else useTokens()
	local v62 = useAvatarRoute()
	local v63 = useNavigation()
	local v64 = useDispatch()
	local v65 = useNavigationFocus()
	local v66 = nil

	if GetFFlagCleanUpAXAlternativeLandingPageIXP() then
		v66 = useUiModeInfo().uiMode == UiMode.TenFoot
	end

	local name = v62.opaque.name
	local v68 = Utils.isAvatarSceneButtonsVisible(v62, v65, t1.isUIFullView, t1.isSceneFullView, v63)
	local v69 = useAppPolicy(function(p5) -- line: 170
		return p5.getAllowCameraMovements()
	end)
	local v70 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v71 = useSelector(selectTopBarHeight, getUseSelectorDeepEquals())
	local v72 = useSelector(v15, getUseSelectorDeepEquals())
	local v73 = useSelector(selectColorAdjustmentButtonColor, getUseSelectorDeepEquals())
	local v74 = React.useCallback(function() -- line: 179
		-- upvalues: v63 (copy), AvatarScreen (copy)
		v63.navigate(AvatarScreen.ColorAdjustment)
	end, { v63 })
	local shouldEnableAccessoryAdjustmentDuringTryOn = nil
	local adjustableLastTryOnItemId = nil
	local accessoryAdjustmentQuickButtonFtux = nil

	if AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then
		local v78 = useAccessoryAdjustmentQuickButtonDuringTryOn()

		shouldEnableAccessoryAdjustmentDuringTryOn = v78.shouldEnableAccessoryAdjustmentDuringTryOn
		adjustableLastTryOnItemId = v78.adjustableLastTryOnItemId
		accessoryAdjustmentQuickButtonFtux = v78.accessoryAdjustmentQuickButtonFtux
	end

	local v79 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else React.useCallback(function() -- line: 194
		-- upvalues: accessoryAdjustmentQuickButtonFtux (ref), GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage (copy), v64 (copy), SetEntryPage (copy), name (copy), v63 (copy), AvatarScreen (copy), SetSelectedAccessory (copy), adjustableLastTryOnItemId (ref)
		if accessoryAdjustmentQuickButtonFtux and accessoryAdjustmentQuickButtonFtux.shouldShowFirstTimeGlow() then
			accessoryAdjustmentQuickButtonFtux.completeFirstTimeGlow()
		end

		if GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage() then
			v64(SetEntryPage(name))
		end

		v63.navigate(AvatarScreen.AdjustAccessoryView, {
			fromRoute = name
		})
		v64(SetSelectedAccessory(adjustableLastTryOnItemId))
	end, {
		v63,
		adjustableLastTryOnItemId,
		name,
		accessoryAdjustmentQuickButtonFtux
	})
	local v80 = if not v70 then Constants.LandscapeNavWidth else 0
	local v81 = if not GetFFlagCleanUpAXAlternativeLandingPageIXP() then IxpUtils.useTestVariables(AXAlternateLandingPageIXP.EnabledForUser) else not v66
	local v82 = React.useRef(nil)
	local v83 = React.useRef(nil)
	local v84 = React.useRef(nil)
	local v85 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else React.useRef(nil)
	local v86 = if not v81 or name ~= AvatarScreen.AvatarEditor and name ~= AvatarScreen.Catalog then v83 else v82
	local n1 = 24

	if AXRecentlyViewedSearchItemsIXPTest.isEnabled() and name == AvatarScreen.SearchLandingFocusedWidgetPage and v61 and v70 then
		n1 = v61.Size.Size_400
	end

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(v80, n1, 0, v71 + 4),
		Size = UDim2.fromOffset(44, 0),
		Visible = v68,
		ref = p4,
		defaultChild = v86
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		ProfilePictureButton = if not v81 or not v69 then nil else React.createElement(ProfilePictureQuickButton, Cryo.Dictionary.join(t1, {
			layoutOrder = 1,
			profilePictureButtonRef = v82,
			refinementButtonsRef = v83
		})),
		RefinementEntryButton = React.createElement(RefinementEntryQuickButton, Cryo.Dictionary.join(t1, {
			layoutOrder = 2,
			profilePictureButtonRef = v82,
			refinementButtonsRef = v83,
			NextSelectionDown = if not v72 then if not shouldEnableAccessoryAdjustmentDuringTryOn or not adjustableLastTryOnItemId then nil else v85 else v84
		})),
		UniversalAppCameraButton = React.createElement(CameraQuickButton, Cryo.Dictionary.join(t1, {
			layoutOrder = 3
		})),
		ColorAdjustmentQuickButton = if not v72 then nil else React.createElement(ColorAdjustmentEntryButton, {
			LayoutOrder = 4,
			colors = { v73 },
			onActivated = v74,
			ref = v84,
			NextSelectionUp = v83,
			NextSelectionLeft = t1.NextSelectionLeft
		}),
		AccessoryAdjustmentButton = if not shouldEnableAccessoryAdjustmentDuringTryOn or (v62.opaque.name ~= AvatarScreen.Catalog or not adjustableLastTryOnItemId) then nil else React.createElement(AccessoryAdjustmentEntryButton, {
			LayoutOrder = 5,
			colors = { v73 },
			onActivated = v79,
			ref = v85,
			NextSelectionUp = v83,
			NextSelectionLeft = t1.NextSelectionLeft,
			enableFocusAnimation = accessoryAdjustmentQuickButtonFtux and accessoryAdjustmentQuickButtonFtux.shouldShowFirstTimeGlow()
		})
	})
end))
