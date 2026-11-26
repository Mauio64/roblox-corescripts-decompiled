local CorePackages = game:GetService("CorePackages")

local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameHorizontal = AvatarExperienceDeps.RoactFitComponents.FitFrameHorizontal
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local module = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ScrollingListWithArrowsAndGradient")
local module2 = require("@luauforge/bundled/dPN")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dPt").Enums.CatalogCategories

local findValueKeyInRefCache = AvatarExperienceCommon.Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation

local module5 = require("@luauforge/bundled/dFs")

local module6 = require("@luauforge/deferred/hgC")

local module7 = require("@luauforge/deferred/hgD")

local categoryPillCloseButton = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CategoryPillCloseButton

local module8 = require("@luauforge/bundled/dVl")

local module9 = require("@luauforge/deferred/heU")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local fFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local fFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local forwardRef = React.forwardRef(function(props, ref)
	local v5 = RoactGamepad.useRefCache()
	local v6 = RoactGamepad.useRefCache()
	local ref2 = React.useRef(nil)

	local v7 = useTokens()
	local size_1300 = v7.Size.Size_1300
	local size_600 = v7.Size.Size_600

	local v8 = useFocusGuiObject()

	local v13 = useTableWrappedCallbackRef((module9({
		onTabBackward = React.useCallback(function(p2)
			p2.cancelled = true
			local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v5)

			if valueKeyInRefCache and valueKeyInRefCache > 1 and v8 then
				v8(v5[valueKeyInRefCache - 1].current)
			end
		end, { v8 }),
		onTabForward = React.useCallback(function(p2)
			p2.cancelled = true
			local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v5)

			if valueKeyInRefCache and valueKeyInRefCache < #v5 and v8 then
				v8(v5[valueKeyInRefCache + 1].current)
			end
		end, { v8 }),
		onNavigateBack = React.useCallback(function(p2)
			p2.cancelled = true

			if v8 and props.NextSelectionUp and props.NextSelectionUp.current then
				v8(props.NextSelectionUp.current)
			end
		end, { v8, props.NextSelectionUp })
	}, ref2)))

	if fFlagAXCategoryPillPositionAnimation then
		React.useEffect(function()
			local current = ref2.current

			if current then
				current.CanvasPosition = Vector2.new(0, current.CanvasPosition.Y)
			end
		end, { props.selectedCategoryId })
	else
		local v14 = React.useCallback(function(value, p2)
			local current = ref2.current

			local v15 = (value or 0) - 50

			if current then
				local x = current.AbsoluteWindowSize.X

				if not x or x == 0 then
					return
				end

				local v16 = value + p2 > 0 and value + p2 < x
				local v17 = value > 0 and value < x

				if not (v17 or v16) then
					current.CanvasPosition = Vector2.new(v15, current.CanvasPosition.Y)
				end
			end
		end, {})

		local v15 = React.useCallback(function(): boolean
			local current = if props.selectedCategoryId then v6[props.selectedCategoryId].current else nil

			if current == nil then
				return false
			end

			v14(current.AbsolutePosition.X, current.AbsoluteSize.X)

			return true
		end, { props.selectedCategoryId })

		React.useEffect(function()
			v15()

			if ref2.current then
				ref2.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function()
					v15()
				end)
			end
		end, {})

		React.useEffect(function()
			v15()
		end, { v15 })
	end

	local v14 = React.useCallback(function(props2, layoutOrder, pillIndex)
		local isSubcategory = props2.isSubcategory

		local v16 = (if isSubcategory then props.selectedSubcategoryId else props.selectedCategoryId) == props2.Id
		local selectCategoryId = props.selectCategoryId
		local selectSubcategoryId = props.selectSubcategoryId

		local createElement = React.createElement
		local v17 = focusable[module6]
		local v18 = {
			id = props2.Id,
			title = props2.Title,
			localizedTitle = 0,
			isChecked = 0,
			onActivated = 0,
			layoutOrder = 0,
			pillIndex = 0,
			isSubcategory = 0,
			categoryButtonRefs = 0,
			navButtonRefs = 0,
			categories = 0,
			navBarHeight = 0,
			avatarScreenOfOrigin = 0,
			categoryTooltipKey = 0,
			categoryTooltipLocalizationKey = 0,
			categoryLocalizedTooltipBody = 0
		}
		local v19 = if fFlagAXCatalogCategoriesSDUI then props2.LocalizedTitle else nil
		v18.localizedTitle = v19
		v18.isChecked = v16
		function v18.onActivated()
			if props2.isSubcategory then
				if v16 then
					selectSubcategoryId(props.selectedCategoryId, nil)
				else
					selectSubcategoryId(props.selectedCategoryId, props2.Id)
				end
			else
				if v16 then
					selectCategoryId(module2.DefaultCatalogCategoryId)
				else
					selectCategoryId(props2.Id)
				end

				if ref2.current then
					ref2.current.CanvasPosition = Vector2.new(0, ref2.current.CanvasPosition.Y)
				end
			end
		end
		v18.layoutOrder = layoutOrder
		v18.pillIndex = pillIndex
		v18.isSubcategory = isSubcategory
		v18.categoryButtonRefs = v6
		v18.navButtonRefs = v5
		v18.categories = props.categories
		v18.navBarHeight = props.navHeight
		v18.avatarScreenOfOrigin = avatarScreen.Catalog
		v18.categoryTooltipKey = props2.TooltipKey

		local v20 = if fFlagAXMigrateCategoryTooltip then props2.TooltipLocalizationKey else nil
		v18.categoryTooltipLocalizationKey = v20

		local v21 = if fFlagAXCatalogCategoriesSDUI then props2.TooltipBody else nil
		v18.categoryLocalizedTooltipBody = v21
		return createElement(v17, v18)
	end, {
		props.selectedCategoryId,
		props.selectedSubcategoryId,
		props.selectCategoryId,
		props.selectSubcategoryId
	})

	local v15 = React.useCallback(function(p2, p3)
		local selectCategoryId = props.selectCategoryId

		return React.createElement(focusable[categoryPillCloseButton], {
			layoutOrder = p2,
			pillIndex = p3,
			onActivated = function()
				selectCategoryId(module2.DefaultCatalogCategoryId)
			end,
			categoryButtonRefs = v6,
			navButtonRefs = v5
		})
	end, { props.selectCategoryId })

	local v16 = React.useCallback(function(p2)
		local x = p2.AbsoluteSize.X or 0

		if ref2.current then
			ref2.current.CanvasSize = UDim2.new(0, x, 1, 0)
		end
	end, {})

	local v17 = React.useCallback(function()
		local categories = props.categories

		local children = {}

		local categoryById = module8.extractCategoryById(props.selectedCategoryId, categories)

		if categoryById then
			local v18 = 1
			local v19 = 1

			children.LeftPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, v7.Padding.Small, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = v19,
				ref = v6.LeftPadding
			})

			local v20 = v19 + 1

			if categoryById.Subcategories then
				children.CloseButton = v15(v20, v18)

				local v21 = v18 + 1
				local v22 = v20 + 1

				if categoryById.Id == nil then
					module5("Selected category does not have an ID" .. categoryById.Name)
				else
					children[categoryById.Id] = v14(categoryById, v22, v21)
				end

				local v23 = v21 + 1
				v20 = v22 + 1

				for k, subcategory in categoryById.Subcategories do
					if subcategory.Id == nil then
						module5("Selected subcategory does not have an ID" .. subcategory.Name)
					else
						children[subcategory.Id] = v14(subcategory, v20, v23)
					end

					v23 += 1
					v20 += 1
				end
			else
				for k, category in categories do
					if category.Id == nil then
						module5("Selected category does not have an ID" .. category.Name)
					else
						children[category.Id] = v14(category, v20, v18)
					end

					v18 += 1
					v20 += 1
				end
			end

			children.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, size_1300 + size_600, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = v20,
				ref = v6.RightPadding
			})
		else
			module5("Selected category does not exist in categories list" .. props.selectedCategoryId)
		end

		return {
			NavFrame = React.createElement(focusable[fitFrameHorizontal], {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				[React.Change.AbsoluteSize] = v16,
				contentPadding = UDim.new(0, 6)
			}, children)
		}
	end, { props.subcategorySelected, v16, props.categories, v14, v15 })

	local v18 = React.useCallback(function()
		local children = {}

		children.LeftPadding = React.createElement(Foundation.View, {
			tag = "auto-xy",
			Size = UDim2.new(0, v7.Padding.Small, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ref = v6.LeftPadding
		})

		children.MainContents = React.createElement(module7, {
			navHeight = props.navHeight,
			categories = props.categories,
			selectedCategoryId = props.selectedCategoryId,
			selectCategoryId = props.selectCategoryId,
			selectedSubcategoryId = props.selectedSubcategoryId,
			selectSubcategoryId = props.selectSubcategoryId,
			shouldShowSubcategories = props.shouldShowSubcategories or props.shouldShowSubcategories and true or false,
			layoutOrder = 2,
			navButtonRefs = v5,
			scrollingFrameRef = ref2,
			categoryButtonRefs = v6
		})

		children.RightPadding = React.createElement(Foundation.View, {
			tag = "auto-xy",
			Size = UDim2.new(0, size_1300 + size_600, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			ref = v6.RightPadding
		})

		return {
			NavFrame = React.createElement(focusable[fitFrameHorizontal], {
				height = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				[React.Change.AbsoluteSize] = v16,
				contentPadding = UDim.new(0, 6)
			}, children)
		}
	end, {
		v16,
		props.navHeight,
		props.categories,
		props.selectedCategoryId,
		props.selectCategoryId,
		props.selectedSubcategoryId,
		props.selectSubcategoryId,
		props.shouldShowSubcategories
	})

	local categoryIndexById = module8.findCategoryIndexById(props.categories, props.selectedCategoryId)

	local v19 = v7.Color.Surface.Surface_0.Color3

	if fFlagAXCategoryPillPositionAnimation then
		v19 = v7.Color.Surface.Surface_0
	end

	local v20

	if fFlagAXCatalogSupportDisableFilters then
		v20 = props.hideFilterButton or false
	else
		v20 = props.selectedCategoryId == catalogCategories.Avatars:rawValue()
	end

	local createElement = React.createElement
	local frame = focusable.Frame

	local v22 = if fFlagAXCategoryPillPositionAnimation then v19.Color3 else v19

	local v23 = if fFlagAXCategoryPillPositionAnimation then v19.Transparency else v7.Color.Surface.Surface_0.Transparency
	local v21 = {
		ClipsDescendants = true,
		BackgroundColor3 = v22,
		BackgroundTransparency = v23,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, props.navHeight),
		ZIndex = props.zIndex,
		ref = ref,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		defaultChild = v5[categoryIndexById]
	}

	local createElement2 = React.createElement

	if fFlagAXCategoryPillPositionAnimation then
		v17 = v18
	end

	local v26 = {
		getScollingListContent = v17,
		listHeight = props.navHeight,
		scrollingFrameRef = v13,
		buttonRefs = v6,
		buttonPadding = 0,
		backgroundColor = 0,
		supportFilterButton = true,
		hideFilterButton = 0,
		filterButtonWidth = 0,
		filterButtonGradientWidth = 0
	}

	if fFlagAXCategoryPillPositionAnimation then
		v19 = v19.Color3
	end

	v26.backgroundColor = v19

	v26.hideFilterButton = v20
	v26.filterButtonWidth = size_1300
	v26.filterButtonGradientWidth = size_600
	return createElement(frame, v21, {
		ScrollingListWithArrowsAndGradient = createElement2(module, v26)
	})
end)

return React.memo(forwardRef)
