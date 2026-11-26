local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical

local module = require("@luauforge/deferred/hgB")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dVl")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation
local fFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters

local function PillsNavigationFrame(props)
	local ref = React.useRef(nil)
	local v5 = React.useRef(nil)
	local theme = useStyle().Theme

	local v6 = React.useMemo(function()
		return module2.extractCategoryById(props.selectedCategoryId, props.categoryTable)
	end, { props.selectedCategoryId, props.categoryTable })

	local disableFilters = if fFlagAXCatalogSupportDisableFilters then v6.DisableFilters else nil

	local v7 = v6.Subcategories ~= nil

	local v8 = React.useCallback(function(p2)
		if props.absoluteSizeChanged then
			props.absoluteSizeChanged(p2.AbsoluteSize)
		end
	end, { props.absoluteSizeChanged })

	local createElement = React.createElement
	local v9 = focusable[fitFrameVertical]
	local v10 = {
		width = UDim.new(1, 0),
		FillDirection = Enum.FillDirection.Vertical,
		BackgroundColor3 = theme.BackgroundContrast.Color,
		BackgroundTransparency = theme.BackgroundContrast.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrderMain,
		ZIndex = 3,
		[React.Change.AbsoluteSize] = v8,
		ref = props.navigationFrameRef,
		defaultChild = ref,
		restorePreviousChildFocus = true
	}

	local createElement2 = React.createElement
	local v13 = {
		layoutOrder = props.layoutOrderMain,
		navHeight = props.navHeightMain,
		zIndex = 1,
		categories = props.categoryTable,
		selectedCategoryId = props.selectedCategoryId,
		selectCategoryId = props.selectCategoryId,
		selectedSubcategoryId = props.selectedSubcategoryId,
		selectSubcategoryId = props.selectSubcategoryId,
		subcategorySelected = props.selectedSubcategoryId ~= nil and v7,
		shouldShowSubcategories = if fFlagAXCategoryPillPositionAnimation then v7 else nil,
		hideFilterButton = 0,
		ref = 0,
		NextSelectionDown = 0,
		NextSelectionUp = 0
	}

	if not fFlagAXCatalogSupportDisableFilters then
		disableFilters = nil
	end

	v13.hideFilterButton = disableFilters

	v13.ref = ref

	if not v7 and props.showingTopics then
		v5 = props.NextSelectionDown
	end

	v13.NextSelectionDown = v5

	v13.NextSelectionUp = props.NextSelectionUp
	return createElement(v9, v10, { PillsNavigation = createElement2(module, v13) })
end

return React.memo(PillsNavigationFrame)
