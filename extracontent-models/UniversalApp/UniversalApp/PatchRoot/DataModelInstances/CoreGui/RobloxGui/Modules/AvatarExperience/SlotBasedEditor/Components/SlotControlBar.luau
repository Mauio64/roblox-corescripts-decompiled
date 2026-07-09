local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceControlBar = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceExperiments = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments)
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AXEnableAccessoryAdjustmentDuringTryOnIXP = AvatarExperienceExperiments.AXEnableAccessoryAdjustmentDuringTryOnIXP
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local ContextualActionButton = AvatarExperienceCommon.Components.ContextualActionButton
local ColorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle
local v16 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectShowColorQuickButton) else AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local Constants = UserLib.Utils.Constants
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local SetSelectedAccessory = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetSelectedAccessory)
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage = require(Modules.AvatarExperience.Flags.GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local useNavigationFocus = require(CorePackages.Workspace.Packages.Navigation).useNavigationFocus
local useTokens = Foundation.Hooks.useTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local useAccessoryAdjustmentQuickButtonDuringTryOn = require(Modules.AvatarExperience.Common.Hooks.useAccessoryAdjustmentQuickButtonDuringTryOn)
local FFlagAXFixCatalogSearchRedirect = require(Modules.AvatarExperience.Flags.FFlagAXFixCatalogSearchRedirect)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local ContextualActions = require(Modules.AvatarExperience.SlotBasedEditor.Components.ContextualActions.ContextualActions)
local ItemView = AvatarExperienceSlotBasedEditor.Enums.ItemView
local NavigationParams = AvatarExperienceSlotBasedEditor.Enums.NavigationParams
local CustomizeControlBar = AvatarExperienceControlBar.CustomizeControlBar
local UndoRedoBar = AvatarExperienceControlBar.UndoRedoBar
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local FFlagAXMoveContextualActionButtons = AvatarExperienceFlags.FFlagAXMoveContextualActionButtons
local FFlagAXFixContextualActionVisibility = AvatarExperienceFlags.FFlagAXFixContextualActionVisibility
local FFlagAXMigrateSlotsSignals = AvatarExperienceFlags.FFlagAXMigrateSlotsSignals
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot

local function selectUserId(p1) -- line: 78
	return p1.LocalUserId
end
local function SlotControlBar(t1: {[any]: any}, p2) -- line: 94
	-- upvalues: useTokens (copy), useNavigationFocus (copy), useAvatarRoute (copy), useNavigation (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useSlotBasedEditorContext (copy), FFlagAXMigrateSlotsSignals (copy), FFlagAXMoveContextualActionButtons (copy), useSelector (copy), selectIsPortrait (copy), selectColorAdjustmentButtonColor (copy), v16 (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), useAccessoryAdjustmentQuickButtonDuringTryOn (copy), selectUserId (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), React (copy), Utils (copy), GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), SetCategoryAndSubcategory (copy), FFlagAXFixCatalogSearchRedirect (copy), AvatarScreen (copy), NavigationParams (copy), ItemView (copy), CustomizeControlBar (copy), FFlagAXResetAvatarButton (copy), UndoRedoBar (copy), FFlagAXFixContextualActionVisibility (copy), ContextualActions (copy), ContextualActionButton (copy), ColorGradientCircle (copy), GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage (copy), SetEntryPage (copy), SetSelectedAccessory (copy), Foundation (copy)
	local v56 = useTokens()
	local v57 = useNavigationFocus()
	local v58 = useAvatarRoute()
	local v59 = useNavigation()
	local v60 = useDispatch()
	local v61 = useRoactService(Analytics)
	local v62 = useSlotBasedEditorContext()
	local v63 = if not v62 then nil else if not FFlagAXMigrateSlotsSignals then v62.setSlotCategory else v62.signalStore.setSlotCategory
	local v64 = if not FFlagAXMoveContextualActionButtons then nil else useSelector(selectIsPortrait)
	local v65 = if not FFlagAXMoveContextualActionButtons then useSelector(selectColorAdjustmentButtonColor) else nil
	local v66 = if not FFlagAXMoveContextualActionButtons then useSelector(v16) else nil
	local shouldEnableAccessoryAdjustmentDuringTryOn = nil
	local adjustableLastTryOnItemId = nil
	local accessoryAdjustmentQuickButtonFtux = nil

	if not FFlagAXMoveContextualActionButtons and AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then
		local v70 = useAccessoryAdjustmentQuickButtonDuringTryOn()

		shouldEnableAccessoryAdjustmentDuringTryOn = v70.shouldEnableAccessoryAdjustmentDuringTryOn
		adjustableLastTryOnItemId = v70.adjustableLastTryOnItemId
		accessoryAdjustmentQuickButtonFtux = v70.accessoryAdjustmentQuickButtonFtux
	end

	local v71 = useSelector(selectUserId)
	local v72 = getRbxthumbWithTypeSizeAndOptions(v71, AvatarHeadShot, 150)
	local v73 = React.useMemo(function() -- line: 133
		-- upvalues: t1 (copy), Utils (copy), v58 (copy), v57 (copy), v59 (copy)
		return t1.showControlBar and Utils.isAvatarSceneButtonsVisible(v58, v57, t1.isUIFullView, t1.isSceneFullView, v59)
	end, {
		v58,
		v57,
		t1.isUIFullView,
		t1.isSceneFullView,
		v59,
		t1.showControlBar
	})
	local v74 = React.useCallback(function() -- line: 153
		-- upvalues: GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), v63 (copy), v60 (copy), SetCategoryAndSubcategory (copy), v61 (copy), v62 (copy), v58 (copy), FFlagAXFixCatalogSearchRedirect (copy), v59 (copy), AvatarScreen (copy), NavigationParams (copy), ItemView (copy)
		for _, v76 in (GetAvatarEditorCategories()) do
			if v76.NavigationKey == AvatarEditorCategories.All then
				if v63 then
					v63(v76.NavigationKey)
				end

				v60(SetCategoryAndSubcategory(v76.Category, nil, v61))

				break
			end
		end

		local v77 = if not v62 then v58.opaque.name else nil
		local v78 = if not FFlagAXFixCatalogSearchRedirect then nil else v59.state and v59.state.params
		local v79 = v58.current.name == AvatarScreen.LookDetails
		local v80 = v58.opaque.name == AvatarScreen.AvatarEditor

		v59.navigate(AvatarScreen.AvatarEditor, {
			[NavigationParams.itemView] = ItemView.AllItems,
			[NavigationParams.fromScreen] = v77,
			[NavigationParams.params] = if not FFlagAXFixCatalogSearchRedirect then nil else v78 or {}
		})

		if v80 and v79 then
			v59.navigate(AvatarScreen.LookDetails)
		end
	end, {
		v60,
		v61,
		v62,
		v59,
		v58
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		ref = p2,
		NextSelectionLeft = t1.NextSelectionLeft,
		LayoutOrder = t1.LayoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v56.Gap.Small)
		}),
		ControlBar = if not v73 then nil else React.createElement(CustomizeControlBar, {
			LayoutOrder = 1,
			onActiveMenuItemChanged = t1.onActiveMenuItemChanged,
			onInventoryActivated = v74,
			thumbnailUrl = v72,
			showUndoRedo = if not FFlagAXResetAvatarButton then nil else t1.showUndoRedo
		}),
		UndoRedoBar = if not t1.showUndoRedo or FFlagAXResetAvatarButton then nil else React.createElement(UndoRedoBar, {
			direction = "vertical",
			LayoutOrder = 2
		}),
		ContextualActions = if not FFlagAXMoveContextualActionButtons or (FFlagAXFixContextualActionVisibility and not v73 or v64) then nil else React.createElement(ContextualActions, {
			LayoutOrder = 3
		}),
		SkinColorButton = if FFlagAXMoveContextualActionButtons or (not v66 or not v65) then nil else React.createElement(ContextualActionButton, {
			LayoutOrder = 3,
			Selectable = true,
			size = UDim.new(0, v56.Size.Size_1100),
			onActivated = function() -- line: 227
				-- upvalues: v59 (copy), AvatarScreen (copy)
				v59.navigate(AvatarScreen.ColorAdjustment)
			end
		}, React.createElement(ColorGradientCircle, {
			Colors = { v65 },
			Size = UDim2.fromOffset(v56.Size.Size_500, v56.Size.Size_500),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})),
		AccessoryAdjustmentButton = if FFlagAXMoveContextualActionButtons or (not shouldEnableAccessoryAdjustmentDuringTryOn or (v58.opaque.name ~= AvatarScreen.Catalog or not adjustableLastTryOnItemId)) then nil else React.createElement(ContextualActionButton, {
			LayoutOrder = 4,
			Selectable = true,
			GroupTransparencyOverwrite = 0,
			size = UDim.new(0, v56.Size.Size_1100),
			onActivated = function() -- line: 247
				-- upvalues: accessoryAdjustmentQuickButtonFtux (ref), GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage (copy), v60 (copy), SetEntryPage (copy), v58 (copy), v59 (copy), AvatarScreen (copy), SetSelectedAccessory (copy), adjustableLastTryOnItemId (ref)
				if accessoryAdjustmentQuickButtonFtux and accessoryAdjustmentQuickButtonFtux.shouldShowFirstTimeGlow() then
					accessoryAdjustmentQuickButtonFtux.completeFirstTimeGlow()
				end

				if GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage() then
					v60(SetEntryPage(v58.opaque.name))
				end

				v59.navigate(AvatarScreen.AdjustAccessoryView, {
					fromRoute = v58.opaque.name
				})
				v60(SetSelectedAccessory(adjustableLastTryOnItemId))
			end,
			enableFocusAnimation = accessoryAdjustmentQuickButtonFtux and accessoryAdjustmentQuickButtonFtux.shouldShowFirstTimeGlow()
		}, {
			Icon = React.createElement(Foundation.View, {
				Visible = true,
				tag = "radius-circle position-center-center anchor-center-center clip",
				Size = UDim2.fromScale(1, 1)
			}, {
				IconImage = React.createElement(Foundation.Image, {
					Image = "icons/menu/transform",
					tag = "position-center-center anchor-center-center radius-circle content-emphasis",
					Size = UDim2.fromOffset(v56.Size.Size_800, v56.Size.Size_800),
					imageStyle = {
						Color3 = v56.Color.Content.Emphasis.Color3,
						Transparency = v56.Color.Content.Emphasis.Transparency
					}
				})
			})
		})
	})
end

return React.memo(React.forwardRef(SlotControlBar))
