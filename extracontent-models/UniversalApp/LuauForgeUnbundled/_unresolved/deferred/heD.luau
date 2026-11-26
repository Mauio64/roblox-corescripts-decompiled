local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local navigationEvents = RoactNavigation.NavigationEvents
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local closeableHeader = require("@luauforge/bundled/fCn").Components.CloseableHeader
local module = require("@luauforge/bundled/dPN")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dPt").Enums.CatalogCategories

local module2 = require("@luauforge/deferred/heE")
local module3 = require("@luauforge/deferred/heJ")
local module4 = require("@luauforge/deferred/heV")
local module5 = require("@luauforge/bundled/dRF")

local module6 = require("@luauforge/deferred/haU")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation

local module8 = require("@luauforge/bundled/dVl")

local function NavigationFrame(props)
	local v5 = useNavigation()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local state, setState = React.useState(false)
	local v6 = useStyle()
	local v7 = useTokens()

	local theme = v6.Theme

	local v8 = nil
	local v9

	if props.shouldUseCategoryId and props.selectedCategoryId then
		v9 = React.useMemo(function()
			return module8.extractCategoryById(props.selectedCategoryId, props.categoryTable)
		end, { props.selectedCategoryId, props.categoryTable })

		if fFlagAXCatalogSupportDisableFilters then
			v8 = React.useMemo(function()
				if props.selectedSubcategoryId and props.subcategoryTable then
					return module8.extractSubcategoryById(
						props.selectedSubcategoryId,
						props.subcategoryTable
					)
				end

				return nil
			end, { props.selectedSubcategoryId, props.subcategoryTable })
		end
	else
		v9 = props.categoryTable[props.selectedCategoryIndex]

		if fFlagAXCatalogSupportDisableFilters then
			v8 = props.subcategoryTable and props.subcategoryTable[props.selectedSubcategoryIndex]
		end
	end

	local v10 = v9.Subcategories ~= nil
	local v11 = nil

	if fFlagAXMoveCatalogFilterToL1Navigation then
		if v5.state.routeName == avatarScreen.CatalogSearch then
			v11 = true
		elseif module6() or v5.state.routeName == avatarScreen.Catalog then
			v11 = not props.showingTopics
		end
	elseif module6() then
		v11 = not props.showingTopics
	else
		v11 = not props.showingTopics and v5.state.routeName == avatarScreen.Catalog
	end

	local v14 = if not (fFlagAXCatalogCategoriesSDUI and v9.LocalizedTitle) then v9.Title else nil
	local v15 = useLocalization({ selectedCategoryTitle = v14 })

	local v16 = React.useCallback(function(p2)
		if props.absoluteSizeChanged then
			props.absoluteSizeChanged(p2.AbsoluteSize)
		end
	end, { props.absoluteSizeChanged })

	if fFlagAXCatalogSupportDisableFilters then
		if (v8 or v9).DisableFilters then
			v11 = false
		end
	elseif v9.Id == catalogCategories.Avatars:rawValue() then
		v11 = false
	end

	local createElement = React.createElement
	local v17 = focusable[fitFrameVertical]
	local v18 = {}
	v18.width = UDim.new(1, 0)

	v18.FillDirection = Enum.FillDirection.Vertical

	local v19 = if props.replaceMainNavigationWithCloseableHeader then v7.Color.Surface.Surface_0.Color3 else theme.BackgroundContrast.Color
	v18.BackgroundColor3 = v19

	local v20 = if props.replaceMainNavigationWithCloseableHeader then v7.Color.Surface.Surface_0.Transparency else theme.BackgroundContrast.Transparency
	v18.BackgroundTransparency = v20

	v18.BorderSizePixel = 0
	v18.LayoutOrder = props.layoutOrderMain
	v18.ZIndex = 3

	v18[React.Change.AbsoluteSize] = v16

	v18.ref = props.navigationFrameRef
	v18.defaultChild = ref
	v18.restorePreviousChildFocus = true
	local v22

	if props.replaceMainNavigationWithCloseableHeader then
		local createElement2 = React.createElement
		local v24 = {
			Size = UDim2.new(1, 0, 0, props.navHeightMain),
			ZIndex = 1,
			LayoutOrder = props.layoutOrderMain,
			text = 0,
			onClose = 0,
			ref = 0,
			padding = 0,
			NextSelectionDown = 0,
			NextSelectionUp = 0
		}

		local v25 = if fFlagAXCatalogCategoriesSDUI and v9.LocalizedTitle then v9.LocalizedTitle else v15.selectedCategoryTitle
		v24.text = v25

		v24.onClose = props.onCloseableHeaderClosed
		v24.ref = ref
		v24.padding = {
			left = module.WidgetListHorizontalMargin,
			right = module.WidgetListHorizontalMargin
		}

		local v26 = if v10 or not props.showingTopics then ref2 else props.NextSelectionDown
		v24.NextSelectionDown = v26

		v24.NextSelectionUp = props.NextSelectionUp
		v22 = createElement2(closeableHeader, v24)
	else
		local createElement2 = React.createElement
		local v24 = {
			layoutOrder = props.layoutOrderMain,
			navHeight = props.navHeightMain,
			zIndex = 1,
			categories = props.categoryTable,
			selectedCategoryIndex = props.selectedCategoryIndex,
			selectCategory = props.selectCategory,
			selectedCategoryId = props.selectedCategoryId,
			selectCategoryId = props.selectCategoryId,
			shouldUseCategoryId = props.selectedCategoryId ~= nil or nil,
			subcategorySelected = props.selectedSubcategoryId ~= nil and v10,
			supportFilterButton = fFlagAXMoveCatalogFilterToL1Navigation and true,
			showFilterButton = fFlagAXMoveCatalogFilterToL1Navigation and v11,
			ref = ref,
			NextSelectionDown = 0,
			NextSelectionUp = 0
		}

		local v26 = if v10 or not props.showingTopics then ref2 else props.NextSelectionDown
		v24.NextSelectionDown = v26

		v24.NextSelectionUp = props.NextSelectionUp
		v22 = createElement2(module3, v24)
	end

	local v23

	if not v9.ShowSubcategoriesAsSubnavigation then
		local createElement2 = React.createElement
		local v25 = {
			height = not v10 and (fFlagAXMoveCatalogFilterToL1Navigation or not v11) and 0 or props.navHeightSub,
			isContentEmpty = not v10,
			layoutOrder = props.layoutOrderSub,
			showFilterButton = not fFlagAXMoveCatalogFilterToL1Navigation and v11,
			layoutRef = ref2,
			NextSelectionUp = ref,
			NextSelectionDown = props.NextSelectionDown
		}

		local createElement3 = React.createElement
		local v28 = {
			layoutOrder = 1,
			navHeight = props.navHeightSub,
			subcategories = props.subcategoryTable,
			onSubNavigationPropsDidUpdate = props.onSubNavigationPropsDidUpdate,
			selectedCategoryIndex = props.selectedCategoryIndex,
			selectedSubcategoryIndex = props.selectedSubcategoryIndex,
			selectSubcategory = props.selectSubcategory,
			selectedCategoryId = props.selectedCategoryId,
			selectedSubcategoryId = props.selectedSubcategoryId,
			selectSubcategoryId = props.selectSubcategoryId,
			shouldUseCategoryId = props.selectedCategoryId ~= nil or nil,
			isHidden = 0,
			BackgroundTransparency = 0
		}

		local v29 = if module5.isEnabled() then not state else nil
		v28.isHidden = v29
		v28.BackgroundTransparency = props.replaceMainNavigationWithCloseableHeader and 1 or nil
		v23 = createElement2(module2, v25, {
			SubNavigation = createElement3(module4, v28)
		})
	end

	local v24

	if module5.isEnabled() then
		v24 = React.createElement(navigationEvents, {
			onDidFocus = function()
				setState(true)
			end,
			onWillBlur = function()
				setState(false)
			end
		})
	end

	return createElement(v17, v18, {
		MainNavigation = v22,
		SubNavigation = v23,
		NavigationFrameNavEvents = v24
	})
end

return React.memo(NavigationFrame)
