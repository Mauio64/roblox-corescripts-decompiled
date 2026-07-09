local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local FitFrameVertical = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitFrameVertical
local PillsNavigation = require(Modules.AvatarExperience.Common.Components.NavBar.PillsNavigation)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local FFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters

local function PillsNavigationFrame(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), useStyle (copy), CatalogUtils (copy), FFlagAXCatalogSupportDisableFilters (copy), Focusable (copy), FitFrameVertical (copy), PillsNavigation (copy), FFlagAXCategoryPillPositionAnimation (copy)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(nil)
	local Theme = useStyle().Theme
	local v18 = React.useMemo(function() -- line: 52
		-- upvalues: CatalogUtils (copy), t1 (copy)
		return CatalogUtils.extractCategoryById(t1.selectedCategoryId, t1.categoryTable)
	end, {
		t1.selectedCategoryId,
		t1.categoryTable
	})
	local DisableFilters = nil

	if FFlagAXCatalogSupportDisableFilters then
		DisableFilters = v18.DisableFilters
	end

	local v20 = v18.Subcategories ~= nil
	local v21 = React.useCallback(function(p1) -- line: 63
		-- upvalues: t1 (copy)
		if t1.absoluteSizeChanged then
			t1.absoluteSizeChanged(p1.AbsoluteSize)
		end
	end, { t1.absoluteSizeChanged })

	return React.createElement(Focusable[FitFrameVertical], {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Vertical,
		BackgroundColor3 = Theme.BackgroundContrast.Color,
		BackgroundTransparency = Theme.BackgroundContrast.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrderMain,
		ZIndex = 3,
		[React.Change.AbsoluteSize] = v21,
		ref = t1.navigationFrameRef,
		defaultChild = v15,
		restorePreviousChildFocus = true
	}, {
		PillsNavigation = React.createElement(PillsNavigation, {
			zIndex = 1,
			layoutOrder = t1.layoutOrderMain,
			navHeight = t1.navHeightMain,
			categories = t1.categoryTable,
			selectedCategoryId = t1.selectedCategoryId,
			selectCategoryId = t1.selectCategoryId,
			selectedSubcategoryId = t1.selectedSubcategoryId,
			selectSubcategoryId = t1.selectSubcategoryId,
			subcategorySelected = t1.selectedSubcategoryId ~= nil and v20,
			shouldShowSubcategories = if not FFlagAXCategoryPillPositionAnimation then nil else v20,
			hideFilterButton = if not FFlagAXCatalogSupportDisableFilters then nil else DisableFilters,
			ref = v15,
			NextSelectionDown = if not v20 and t1.showingTopics then t1.NextSelectionDown else v16,
			NextSelectionUp = t1.NextSelectionUp
		})
	})
end

return React.memo(PillsNavigationFrame)
