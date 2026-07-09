local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local FitFrameHorizontal = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameHorizontal
local useInputType = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useInputType
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local ScrollingListWithArrowsAndGradient = require(Modules.AvatarExperience.Common.Components.ScrollingListWithArrowsAndGradient)
local Constants = require(Modules.LuaApp.Constants)
local NavHighlight = require(Modules.AvatarExperience.Common.Components.NavBar.NavHighlight)
local DEPRECATED_CategoryButton = require(Modules.AvatarExperience.Common.Components.NavBar.DEPRECATED_CategoryButton)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local findValueKeyInRefCache = AvatarExperienceCommon.Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateMainNavigationInputBindings = AvatarExperienceFlags.FFlagAXMigrateMainNavigationInputBindings
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local useTabNavigationFocusNavigationBindings = require(script.Parent.useTabNavigationFocusNavigationBindings)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXEnableEditorCategoryDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableEditorCategoryDeepLink
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v39 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FFlagAXCategoryUnifiedLogging = AvatarExperienceFlags.FFlagAXCategoryUnifiedLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local sendUnifiedEventLogForInstance = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventLogForInstance
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXReduceCatalogFilterWidth = AvatarExperienceFlags.FFlagAXReduceCatalogFilterWidth
local v50 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 102
	-- upvalues: React (copy), RoactGamepad (copy), useTokens (copy), useInputType (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagSignalsNavP3gAvatarExperience (copy), v39 (copy), useSignalState (copy), AvatarScreenProperties (copy), FFlagAXCategoryUnifiedLogging (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), useFocusGuiObject (copy), FFlagAXMigrateMainNavigationInputBindings (copy), findValueKeyInRefCache (copy), GuiService (copy), useTabNavigationFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), getUseSelectorDeepEquals (copy), FFlagAXEnableEditorCategoryDeepLink (copy), GetAvatarEditorCategories (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), Constants3 (copy), Constants2 (copy), Focusable (copy), DEPRECATED_CategoryButton (copy), FFlagAXCatalogCategoriesSDUI (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), AvatarScreen (copy), FFlagAXMigrateCategoryTooltip (copy), FFlagAXCatalogCategoryTooltip (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), FFlagAXReduceCatalogFilterWidth (copy), Constants (copy), Foundation (copy), FitFrameHorizontal (copy), NavHighlight (copy), CatalogUtils (copy), ScrollingListWithArrowsAndGradient (copy)
	local v53, v54 = React.useState(nil)
	local v55 = RoactGamepad.useRefCache()
	local v56 = RoactGamepad.useRefCache()
	local v57 = React.useRef(nil)
	local v58 = useTokens()
	local v59 = useInputType()
	local v60 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
	local u64

	if FFlagSignalsNavP3gAvatarExperience then
		local v61 = v39(false)
		local v62 = useSignalState(v61.getCurrentRoute)
		local v63 = v62 and AvatarScreenProperties[v62.routeName]

		u64 = if not FFlagAXCategoryUnifiedLogging or (not v63 or not v63.analyticsData) then nil else v63.analyticsData.unifiedLoggingSurface
	else
		u64 = useSelector(function(p2) -- line: 124
			-- upvalues: FFlagAXCategoryUnifiedLogging (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy)
			if not FFlagAXCategoryUnifiedLogging then
				return nil
			end

			local v82 = if not FFlagUseNavigationSelectors then p2.Navigation and p2.Navigation.currentRoute else Selectors.selectCurrentRoactNavigationRoute(p2)
			local v83 = v82 and AvatarScreenProperties[v82.routeName]

			if v83 and v83.analyticsData then
				return v83.analyticsData.unifiedLoggingSurface
			end

			return nil
		end)
	end

	local v65 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useFocusGuiObject()
	local v66 = v57

	if FFlagAXMigrateMainNavigationInputBindings then
		local v67 = React.useCallback(function(p3) -- line: 145
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v55 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v65 (copy), v60 (copy)
			p3.cancelled = true

			local v85 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v55)

			if v85 and v85 > 1 then
				if FFlagAXMigrateAXToGlobalAutofocus then
					if v65 then
						v65(v55[v85 - 1].current)

						return
					end
				else
					v60.moveFocusLeft()
				end
			end
		end, { if not FFlagAXMigrateAXToGlobalAutofocus then v60 else v65 })
		local v68 = React.useCallback(function(p4) -- line: 159
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v55 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v65 (copy), v60 (copy)
			p4.cancelled = true

			local v87 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v55)

			if v87 and v87 < #v55 then
				if FFlagAXMigrateAXToGlobalAutofocus then
					if v65 then
						v65(v55[v87 + 1].current)

						return
					end
				else
					v60.moveFocusRight()
				end
			end
		end, { if not FFlagAXMigrateAXToGlobalAutofocus then v60 else v65 })
		local v69 = React.useCallback(function(p5) -- line: 173
			-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), v65 (copy), t1 (copy), v60 (copy)
			p5.cancelled = true

			if FFlagAXMigrateAXToGlobalAutofocus then
				if v65 and t1.NextSelectionUp and t1.NextSelectionUp.current then
					v65(t1.NextSelectionUp.current)

					return
				end
			else
				v60.moveFocusUp()
			end
		end, {
			if not FFlagAXMigrateAXToGlobalAutofocus then v60 else v65,
			if not FFlagAXMigrateAXToGlobalAutofocus then nil else t1.NextSelectionUp
		})
		local v70 = useTabNavigationFocusNavigationBindings({
			onTabBackward = v67,
			onTabForward = v68,
			onNavigateBack = v69
		}, v57)

		v66 = useTableWrappedCallbackRef(v70)
	end

	local v71 = useSelector(function(p6) -- line: 196
		return p6.AvatarExperience.AvatarEditor.NewItemNotifications
	end, getUseSelectorDeepEquals())
	local v72 = React.useCallback(function(p7, p8) -- line: 200
		-- upvalues: v57 (copy)
		local current = v57.current
		local v93 = (p7 or 0) - 50

		if current then
			local AbsoluteWindowSizeX = current.AbsoluteWindowSize.X

			if not AbsoluteWindowSizeX or AbsoluteWindowSizeX == 0 then
				return
			end

			local v95 = p7 + p8 > 0 and AbsoluteWindowSizeX > p7 + p8

			if (not (p7 > 0) or not (p7 < AbsoluteWindowSizeX)) and not v95 then
				current.CanvasPosition = Vector2.new(v93, current.CanvasPosition.Y)
			end
		end
	end, {})
	local v73 = React.useCallback(function() -- line: 224
		-- upvalues: t1 (copy), v56 (copy), v72 (copy), v54 (copy)
		local v96 = if not t1.shouldUseCategoryId then if not t1.selectedCategoryIndex then nil else v56[t1.selectedCategoryIndex].current else if not t1.selectedCategoryId then nil else v56[t1.selectedCategoryId].current

		if v96 == nil then
			return false
		end

		v72(v96.AbsolutePosition.X, v96.AbsoluteSize.X)
		v54(v96)

		return true
	end, {
		t1.selectedCategoryIndex,
		t1.selectedCategoryId
	})

	if not FFlagAXEnableEditorCategoryDeepLink then
		React.useEffect(function() -- line: 246
			-- upvalues: v73 (copy), v57 (copy)
			v73()

			if v57.current then
				v57.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function() -- line: 249
					-- upvalues: v73 (copy)
					v73()
				end)
			end
		end, {})
	end

	React.useEffect(function() -- line: 256
		-- upvalues: v73 (copy)
		v73()
	end, { v73 })

	local v74 = React.useCallback(function(p9) -- line: 260
		-- upvalues: t1 (copy), GetAvatarEditorCategories (copy), GetFFlagAXEnableSlotBasedEditor (copy), Utils (copy), v71 (copy), Constants3 (copy), Constants2 (copy)
		if t1.categories ~= GetAvatarEditorCategories() then
			return false
		end

		local v98 = t1.categories[p9]

		if GetFFlagAXEnableSlotBasedEditor() then
			return Utils.shouldNotifyCategory(v98, v71)
		end

		if v98.Name == Constants3.CharacterKey or v98.Name == "Body" then
			return v71[Constants2.NewOutfitNotificationKey]
		end

		if v98.Name == Constants3.HeadAndBody and v71[Constants2.NewDHOutfitNotificationKey] then
			return true
		end

		local Subcategories = v98.Subcategories

		if Subcategories then
			for _, v101 in Subcategories do
				local AssetTypeIdStrings = v101.AssetTypeIdStrings

				if AssetTypeIdStrings and Utils.shouldNotifyAssetTypes(AssetTypeIdStrings, v71) then
					return true
				end
			end
		else
			local AssetTypeIdStrings = v98.AssetTypeIdStrings

			if AssetTypeIdStrings and Utils.shouldNotifyAssetTypes(AssetTypeIdStrings, v71) then
				return true
			end
		end

		return false
	end, {
		t1.categories,
		v71
	})
	local v75 = React.useCallback(function(p10, p11) -- line: 305
		-- upvalues: t1 (copy), React (copy), Focusable (copy), DEPRECATED_CategoryButton (copy), FFlagAXCatalogCategoriesSDUI (copy), v74 (copy), v56 (copy), FFlagAXCategoryUnifiedLogging (copy), v55 (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), u64 (ref), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateMainNavigationInputBindings (copy), v60 (copy), RoactGamepad (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), AvatarScreen (copy), FFlagAXMigrateCategoryTooltip (copy), FFlagAXCatalogCategoryTooltip (copy)
		local v106 = if not t1.shouldUseCategoryId then p10 == t1.selectedCategoryIndex else t1.selectedCategoryId == p11.Id

		return React.createElement(Focusable[DEPRECATED_CategoryButton], {
			categoryIndex = p10,
			categoryId = p11.Id,
			categoryTitle = p11.Title,
			localizedCategoryTitle = if not FFlagAXCatalogCategoriesSDUI then nil else p11.LocalizedTitle,
			layoutOrder = p10,
			isSelected = v106,
			hasNewItemNotification = v74(p10),
			frameRef = v56[if not t1.shouldUseCategoryId then p10 else p11.Id],
			onActivate = function() -- line: 322
				-- upvalues: FFlagAXCategoryUnifiedLogging (copy), v55 (copy), p10 (copy), sendUnifiedEventLogForInstance (copy), UnifiedEventLogEnums (copy), p11 (copy), u64 (ref), t1 (copy)
				if FFlagAXCategoryUnifiedLogging then
					local v112 = v55[p10]

					if v112 and v112.current then
						sendUnifiedEventLogForInstance(v112.current, {
							action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
							elementName = "SELECT_CATEGORY_" .. string.upper(p11.Name),
							surface = u64
						})
					end
				end

				if t1.shouldUseCategoryId and t1.selectCategoryId then
					t1.selectCategoryId(p11.Id)

					return
				end

				t1.selectCategory(p10)
			end,
			ref = v55[p10],
			NextSelectionLeft = if not (p10 > 1) then nil else v55[p10 - 1],
			NextSelectionRight = if not (p10 < #t1.categories) then nil else v55[p10 + 1],
			inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateMainNavigationInputBindings then if v60 == nil then nil else {
				ShiftLeft = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL1, function() -- line: 348
					-- upvalues: p10 (copy), v60 (copy)
					if p10 > 1 then
						v60.moveFocusLeft()
					end
				end),
				ShiftRight = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR1, function() -- line: 353
					-- upvalues: p10 (copy), t1 (copy), v60 (copy)
					if p10 < #t1.categories then
						v60.moveFocusRight()
					end
				end)
			} else nil,
			navigationKey = if FFlagAXRemoveCatalogCategoryNavKey then nil else p11.NavigationKey,
			navBarHeight = t1.navHeight,
			avatarScreenOfOrigin = AvatarScreen.Catalog,
			categoryTooltipKey = if not FFlagAXMigrateCategoryTooltip and not FFlagAXCatalogCategoryTooltip then nil else p11.TooltipKey,
			categoryTooltipLocalizationKey = if not FFlagAXMigrateCategoryTooltip then nil else p11.TooltipLocalizationKey,
			categoryLocalizedTooltipBody = if not FFlagAXCatalogCategoriesSDUI then nil else p11.TooltipBody
		})
	end, {
		t1.selectedCategoryIndex,
		t1.selectedCategoryId,
		v74,
		t1.selectCategory,
		t1.selectCategoryId,
		t1.shouldUseCategoryId,
		t1.categories,
		if not FFlagAXMigrateAXToGlobalAutofocus then v60 else nil
	})
	local v76 = React.useCallback(function(p12) -- line: 384
		-- upvalues: v57 (copy)
		if v57.current then
			v57.current.CanvasSize = UDim2.new(0, p12.AbsoluteSize.X, 1, 0)
		end
	end, {})
	local u77 = nil
	local Size_600 = nil

	if FFlagAXMoveCatalogFilterToL1Navigation then
		u77 = if not FFlagAXReduceCatalogFilterWidth then v58.Size.Size_1400 else v58.Size.Size_1300
		Size_600 = v58.Size.Size_600
	end

	local v79 = React.useCallback(function() -- line: 401
		-- upvalues: v59 (copy), Constants (copy), t1 (copy), v75 (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), React (copy), Foundation (copy), u77 (ref), Size_600 (ref), v56 (copy), Focusable (copy), FitFrameHorizontal (copy), v76 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXMigrateMainNavigationInputBindings (copy), RoactGamepad (copy), v60 (copy), NavHighlight (copy), v57 (copy), v53 (copy)
		local v108 = v59 ~= Constants.InputType.Gamepad or t1.subcategorySelected
		local t2 = {}

		for v110, v111 in t1.categories do
			t2[v111.Name] = v75(v110, v111)
		end

		if FFlagAXMoveCatalogFilterToL1Navigation and t1.supportFilterButton and t1.showFilterButton then
			t2.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, u77 + Size_600, 1, 0),
				LayoutOrder = #t1.categories + 1,
				ref = v56.RightPadding
			})
		end

		return {
			NavFrame = React.createElement(Focusable[FitFrameHorizontal], {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = v76,
				inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateMainNavigationInputBindings then {
					ToTopBar = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 429
						-- upvalues: v60 (copy)
						v60.moveFocusUp()
					end)
				} else nil
			}, t2),
			Highlight = v108 and React.createElement(NavHighlight, {
				scrollingFrameRef = v57,
				useArrowHighlight = t1.subcategorySelected,
				selectedCategoryButtonInstance = v53
			})
		}
	end, {
		v59,
		t1.subcategorySelected,
		v75,
		v76,
		if not FFlagAXMigrateAXToGlobalAutofocus then v60 else nil,
		v53,
		t1.categories,
		t1.supportFilterButton,
		t1.showFilterButton,
		FFlagAXMoveCatalogFilterToL1Navigation
	})
	local selectedCategoryIndex = t1.selectedCategoryIndex

	if t1.shouldUseCategoryId then
		selectedCategoryIndex = CatalogUtils.findCategoryIndexById(t1.categories, t1.selectedCategoryId)
	end

	return React.createElement(Focusable.Frame, {
		ClipsDescendants = true,
		BorderSizePixel = 0,
		BackgroundColor3 = v58.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v58.Color.Surface.Surface_0.Transparency,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, t1.navHeight),
		ZIndex = t1.zIndex,
		ref = p1,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		defaultChild = v55[selectedCategoryIndex]
	}, {
		ScrollingListWithArrowsAndGradient = React.createElement(ScrollingListWithArrowsAndGradient, {
			buttonPadding = 0,
			getScollingListContent = v79,
			listHeight = t1.navHeight,
			scrollingFrameRef = v66,
			buttonRefs = v56,
			onSizeChanged = if not FFlagAXEnableEditorCategoryDeepLink then nil else v73,
			backgroundColor = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else v58.Color.Surface.Surface_0.Color3,
			supportFilterButton = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else t1.supportFilterButton,
			hideFilterButton = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else not t1.showFilterButton,
			filterButtonWidth = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else u77,
			filterButtonGradientWidth = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else Size_600
		})
	})
end)

return React.memo(v50)
