local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local FitFrameVertical = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameVertical
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local CloseableHeader = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Components.CloseableHeader
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogCategories = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.CatalogCategories
local FilterButtonLayout = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButtonLayout)
local MainNavigation = require(Modules.AvatarExperience.Common.Components.NavBar.MainNavigation)
local SubNavigation = require(Modules.AvatarExperience.Common.Components.NavBar.SubNavigation)
local AXCatalogHeadCategoryCombineIXP = require(Modules.AvatarExperience.Experiments.AXCatalogHeadCategoryCombineIXP)
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

local function NavigationFrame(t1: {[any]: any}) -- line: 81
	-- upvalues: useNavigation (copy), React (copy), useStyle (copy), useTokens (copy), CatalogUtils (copy), FFlagAXCatalogSupportDisableFilters (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), AvatarScreen (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), useLocalization (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), CatalogCategories (copy), Focusable (copy), FitFrameVertical (copy), CloseableHeader (copy), Constants (copy), MainNavigation (copy), FFlagAXCustomizeMakeupSupport (copy), FilterButtonLayout (copy), SubNavigation (copy), AXCatalogHeadCategoryCombineIXP (copy), NavigationEvents (copy)
	local v30 = useNavigation()
	local v31 = React.useRef(nil)
	local v32 = React.useRef(nil)
	local v33, v34 = React.useState(false)
	local v35 = useStyle()
	local v36 = useTokens()
	local Theme = v35.Theme
	local v38 = nil
	local v39

	if t1.shouldUseCategoryId and t1.selectedCategoryId then
		v39 = React.useMemo(function() -- line: 95
			-- upvalues: CatalogUtils (copy), t1 (copy)
			return CatalogUtils.extractCategoryById(t1.selectedCategoryId, t1.categoryTable)
		end, {
			t1.selectedCategoryId,
			t1.categoryTable
		})

		if FFlagAXCatalogSupportDisableFilters then
			v38 = React.useMemo(function() -- line: 100
				-- upvalues: t1 (copy), CatalogUtils (copy)
				if t1.selectedSubcategoryId and t1.subcategoryTable then
					return CatalogUtils.extractSubcategoryById(t1.selectedSubcategoryId, t1.subcategoryTable)
				end

				return nil
			end, {
				t1.selectedSubcategoryId,
				t1.subcategoryTable
			})
		end
	else
		v39 = t1.categoryTable[t1.selectedCategoryIndex]

		if FFlagAXCatalogSupportDisableFilters then
			v38 = t1.subcategoryTable and t1.subcategoryTable[t1.selectedSubcategoryIndex]
		end
	end

	local v40 = v39.Subcategories ~= nil
	local v41 = nil

	if FFlagAXMoveCatalogFilterToL1Navigation then
		if v30.state.routeName == AvatarScreen.CatalogSearch then
			v41 = true
		elseif GetFFlagAXEnableInventorySortsAndFilters() or v30.state.routeName == AvatarScreen.Catalog then
			v41 = not t1.showingTopics
		end
	else
		v41 = if not GetFFlagAXEnableInventorySortsAndFilters() then not t1.showingTopics and v30.state.routeName == AvatarScreen.Catalog else not t1.showingTopics
	end

	local v42 = useLocalization({
		selectedCategoryTitle = if not FFlagAXCatalogCategoriesSDUI or not v39.LocalizedTitle then v39.Title else nil
	})
	local v43 = React.useCallback(function(p1) -- line: 135
		-- upvalues: t1 (copy)
		if t1.absoluteSizeChanged then
			t1.absoluteSizeChanged(p1.AbsoluteSize)
		end
	end, { t1.absoluteSizeChanged })

	if FFlagAXCatalogSupportDisableFilters then
		if (v38 or v39).DisableFilters then
			v41 = false
		end
	elseif FFlagAXRemoveCatalogCategoryNavKey then
		if v39.Id == CatalogCategories.Avatars:rawValue() then
			v41 = false
		end
	elseif v39.NavigationKey == CatalogCategories.Avatars then
		v41 = false
	end

	return React.createElement(Focusable[FitFrameVertical], {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Vertical,
		BackgroundColor3 = if not t1.replaceMainNavigationWithCloseableHeader then Theme.BackgroundContrast.Color else v36.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = if not t1.replaceMainNavigationWithCloseableHeader then Theme.BackgroundContrast.Transparency else v36.Color.Surface.Surface_0.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrderMain,
		ZIndex = 3,
		[React.Change.AbsoluteSize] = v43,
		ref = t1.navigationFrameRef,
		defaultChild = v31,
		restorePreviousChildFocus = true
	}, {
		MainNavigation = if not t1.replaceMainNavigationWithCloseableHeader then React.createElement(MainNavigation, {
			zIndex = 1,
			layoutOrder = t1.layoutOrderMain,
			navHeight = t1.navHeightMain,
			categories = t1.categoryTable,
			selectedCategoryIndex = t1.selectedCategoryIndex,
			selectCategory = t1.selectCategory,
			selectedCategoryId = t1.selectedCategoryId,
			selectCategoryId = t1.selectCategoryId,
			shouldUseCategoryId = t1.selectedCategoryId ~= nil or nil,
			subcategorySelected = t1.selectedSubcategoryId ~= nil and v40,
			supportFilterButton = FFlagAXMoveCatalogFilterToL1Navigation and true,
			showFilterButton = FFlagAXMoveCatalogFilterToL1Navigation and v41,
			ref = v31,
			NextSelectionDown = if not v40 and t1.showingTopics then t1.NextSelectionDown else v32,
			NextSelectionUp = t1.NextSelectionUp
		}) else React.createElement(CloseableHeader, {
			ZIndex = 1,
			Size = UDim2.new(1, 0, 0, t1.navHeightMain),
			LayoutOrder = t1.layoutOrderMain,
			text = if not FFlagAXCatalogCategoriesSDUI or not v39.LocalizedTitle then v42.selectedCategoryTitle else v39.LocalizedTitle,
			onClose = t1.onCloseableHeaderClosed,
			ref = v31,
			padding = {
				left = Constants.WidgetListHorizontalMargin,
				right = Constants.WidgetListHorizontalMargin
			},
			NextSelectionDown = if not v40 and t1.showingTopics then t1.NextSelectionDown else v32,
			NextSelectionUp = t1.NextSelectionUp
		}),
		SubNavigation = if not FFlagAXCustomizeMakeupSupport or not v39.ShowSubcategoriesAsSubnavigation then React.createElement(FilterButtonLayout, {
			height = not v40 and (FFlagAXMoveCatalogFilterToL1Navigation or not v41) and 0 or t1.navHeightSub,
			isContentEmpty = not v40,
			layoutOrder = t1.layoutOrderSub,
			showFilterButton = not FFlagAXMoveCatalogFilterToL1Navigation and v41,
			layoutRef = v32,
			NextSelectionUp = v31,
			NextSelectionDown = t1.NextSelectionDown
		}, {
			SubNavigation = React.createElement(SubNavigation, {
				layoutOrder = 1,
				navHeight = t1.navHeightSub,
				subcategories = t1.subcategoryTable,
				onSubNavigationPropsDidUpdate = t1.onSubNavigationPropsDidUpdate,
				selectedCategoryIndex = t1.selectedCategoryIndex,
				selectedSubcategoryIndex = t1.selectedSubcategoryIndex,
				selectSubcategory = t1.selectSubcategory,
				selectedCategoryId = t1.selectedCategoryId,
				selectedSubcategoryId = t1.selectedSubcategoryId,
				selectSubcategoryId = t1.selectSubcategoryId,
				shouldUseCategoryId = t1.selectedCategoryId ~= nil or nil,
				isHidden = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else not v33,
				BackgroundTransparency = if not t1.replaceMainNavigationWithCloseableHeader then nil else 1
			})
		}) else nil,
		NavigationFrameNavEvents = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else React.createElement(NavigationEvents, {
			onDidFocus = function() -- line: 265
				-- upvalues: v34 (copy)
				v34(true)
			end,
			onWillBlur = function() -- line: 268
				-- upvalues: v34 (copy)
				v34(false)
			end
		})
	})
end

return React.memo(NavigationFrame)
