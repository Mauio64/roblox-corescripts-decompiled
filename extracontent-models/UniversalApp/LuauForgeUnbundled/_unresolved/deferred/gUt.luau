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
local module2 = require("@luauforge/bundled/dMx")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dMd").Enums.CatalogCategories

local findValueKeyInRefCache = AvatarExperienceCommon.Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCategoryPillPositionAnimation = AvatarExperienceFlags.FFlagAXCategoryPillPositionAnimation

local module5 = require("@luauforge/bundled/dCn")

local module6 = require("@luauforge/deferred/gUu")

local module7 = require("@luauforge/deferred/gUv")

local categoryPillCloseButton = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CategoryPillCloseButton

local module8 = require("@luauforge/bundled/dRQ")

local module9 = require("@luauforge/deferred/gSM")

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

	local v9 = useTableWrappedCallbackRef((module9({
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
		local v10 = React.useCallback(function(value, p2)
			local current = ref2.current

			local v11 = (value or 0) - 50

			if current then
				local x = current.AbsoluteWindowSize.X

				if not x or x == 0 then
					return
				end

				local v12 = value + p2 > 0 and value + p2 < x
				local v13 = value > 0 and value < x

				if not (v13 or v12) then
					current.CanvasPosition = Vector2.new(v11, current.CanvasPosition.Y)
				end
			end
		end, {})

		local v11 = React.useCallback(function(): boolean
			local current = if props.selectedCategoryId then v6[props.selectedCategoryId].current else nil

			if current == nil then
				return false
			end

			v10(current.AbsolutePosition.X, current.AbsoluteSize.X)

			return true
		end, { props.selectedCategoryId })

		React.useEffect(function()
			v11()

			if ref2.current then
				ref2.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function()
					v11()
				end)
			end
		end, {})

		React.useEffect(function()
			v11()
		end, { v11 })
	end

	local v10 = React.useCallback(function(props2, layoutOrder, pillIndex)
		local isSubcategory = props2.isSubcategory

		local v12 = (if isSubcategory then props.selectedSubcategoryId else props.selectedCategoryId) == props2.Id
		local selectCategoryId = props.selectCategoryId
		local selectSubcategoryId = props.selectSubcategoryId

		local createElement = React.createElement
		local v13 = focusable[module6]
		local v14 = {
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
		local v15 = if fFlagAXCatalogCategoriesSDUI then props2.LocalizedTitle else nil
		v14.localizedTitle = v15
		v14.isChecked = v12
		function v14.onActivated()
			if props2.isSubcategory then
				if v12 then
					selectSubcategoryId(props.selectedCategoryId, nil)
				else
					selectSubcategoryId(props.selectedCategoryId, props2.Id)
				end
			else
				if v12 then
					selectCategoryId(module2.DefaultCatalogCategoryId)
				else
					selectCategoryId(props2.Id)
				end

				if ref2.current then
					ref2.current.CanvasPosition = Vector2.new(0, ref2.current.CanvasPosition.Y)
				end
			end
		end
		v14.layoutOrder = layoutOrder
		v14.pillIndex = pillIndex
		v14.isSubcategory = isSubcategory
		v14.categoryButtonRefs = v6
		v14.navButtonRefs = v5
		v14.categories = props.categories
		v14.navBarHeight = props.navHeight
		v14.avatarScreenOfOrigin = avatarScreen.Catalog
		v14.categoryTooltipKey = props2.TooltipKey

		local v16 = if fFlagAXMigrateCategoryTooltip then props2.TooltipLocalizationKey else nil
		v14.categoryTooltipLocalizationKey = v16

		local v17 = if fFlagAXCatalogCategoriesSDUI then props2.TooltipBody else nil
		v14.categoryLocalizedTooltipBody = v17
		return createElement(v13, v14)
	end, {
		props.selectedCategoryId,
		props.selectedSubcategoryId,
		props.selectCategoryId,
		props.selectSubcategoryId
	})

	local v11 = React.useCallback(function(p2, p3)
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

	local v12 = React.useCallback(function(p2)
		local x = p2.AbsoluteSize.X or 0

		if ref2.current then
			ref2.current.CanvasSize = UDim2.new(0, x, 1, 0)
		end
	end, {})

	local v13 = React.useCallback(function()
		local categories = props.categories

		local children = {}

		local categoryById = module8.extractCategoryById(props.selectedCategoryId, categories)

		if categoryById then
			local v14 = 1
			local v15 = 1

			children.LeftPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, v7.Padding.Small, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = v15,
				ref = v6.LeftPadding
			})

			local v16 = v15 + 1

			if categoryById.Subcategories then
				children.CloseButton = v11(v16, v14)

				local v17 = v14 + 1
				local v18 = v16 + 1

				if categoryById.Id == nil then
					module5("Selected category does not have an ID" .. categoryById.Name)
				else
					children[categoryById.Id] = v10(categoryById, v18, v17)
				end

				local v19 = v17 + 1
				v16 = v18 + 1

				for k, subcategory in categoryById.Subcategories do
					if subcategory.Id == nil then
						module5("Selected subcategory does not have an ID" .. subcategory.Name)
					else
						children[subcategory.Id] = v10(subcategory, v16, v19)
					end

					v19 += 1
					v16 += 1
				end
			else
				for k, category in categories do
					if category.Id == nil then
						module5("Selected category does not have an ID" .. category.Name)
					else
						children[category.Id] = v10(category, v16, v14)
					end

					v14 += 1
					v16 += 1
				end
			end

			children.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, size_1300 + size_600, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = v16,
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
				[React.Change.AbsoluteSize] = v12,
				contentPadding = UDim.new(0, 6)
			}, children)
		}
	end, { props.subcategorySelected, v12, props.categories, v10, v11 })

	local v14 = React.useCallback(function()
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
				[React.Change.AbsoluteSize] = v12,
				contentPadding = UDim.new(0, 6)
			}, children)
		}
	end, {
		v12,
		props.navHeight,
		props.categories,
		props.selectedCategoryId,
		props.selectCategoryId,
		props.selectedSubcategoryId,
		props.selectSubcategoryId,
		props.shouldShowSubcategories
	})

	local categoryIndexById = module8.findCategoryIndexById(props.categories, props.selectedCategoryId)

	local v15 = v7.Color.Surface.Surface_0.Color3

	if fFlagAXCategoryPillPositionAnimation then
		v15 = v7.Color.Surface.Surface_0
	end

	local v16

	if fFlagAXCatalogSupportDisableFilters then
		v16 = props.hideFilterButton or false
	else
		v16 = props.selectedCategoryId == catalogCategories.Avatars:rawValue()
	end

	local createElement = React.createElement
	local frame = focusable.Frame

	local v18 = if fFlagAXCategoryPillPositionAnimation then v15.Color3 else v15

	local v19 = if fFlagAXCategoryPillPositionAnimation then v15.Transparency else v7.Color.Surface.Surface_0.Transparency
	local v17 = {
		ClipsDescendants = true,
		BackgroundColor3 = v18,
		BackgroundTransparency = v19,
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
		v13 = v14
	end

	local v22 = {
		getScollingListContent = v13,
		listHeight = props.navHeight,
		scrollingFrameRef = v9,
		buttonRefs = v6,
		buttonPadding = 0,
		backgroundColor = 0,
		supportFilterButton = true,
		hideFilterButton = 0,
		filterButtonWidth = 0,
		filterButtonGradientWidth = 0
	}

	if fFlagAXCategoryPillPositionAnimation then
		v15 = v15.Color3
	end

	v22.backgroundColor = v15

	v22.hideFilterButton = v16
	v22.filterButtonWidth = size_1300
	v22.filterButtonGradientWidth = size_600
	return createElement(frame, v17, {
		ScrollingListWithArrowsAndGradient = createElement2(module, v22)
	})
end)

return React.memo(forwardRef)
