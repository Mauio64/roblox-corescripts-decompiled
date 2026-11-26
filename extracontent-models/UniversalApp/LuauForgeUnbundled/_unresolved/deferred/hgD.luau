local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local module = require("@luauforge/bundled/dPN")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module3 = require("@luauforge/bundled/dFs")

local module4 = require("@luauforge/deferred/hgC")
local categoryPillCloseButton = AvatarExperienceCommon.Components.CategoryPillCloseButton
local animatedCategoryPill = AvatarExperienceCommon.Components.AnimatedCategoryPill
local animatedSubcategoryPill = AvatarExperienceCommon.Components.AnimatedSubcategoryPill
local useSubcategoryPillAnimation = AvatarExperienceCommon.Hooks.useSubcategoryPillAnimation

local module5 = require("@luauforge/bundled/dVl")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

return function(props)
	local shouldShowSubcategories = props.shouldShowSubcategories

	local v5 = React.useMemo(function()
		return module5.extractCategoryById(props.selectedCategoryId, props.categories)
	end, { props.selectedCategoryId, props.categories })

	local v6 = useTokens()
	local surface_0 = v6.Color.Surface.Surface_0

	local navButtonRefs = props.navButtonRefs
	local categoryButtonRefs = props.categoryButtonRefs

	local ref = React.useRef(nil)
	local ref2 = React.useRef({})
	local ref3 = React.useRef(0)

	local v7 = useSubcategoryPillAnimation(v5)
	local subcategoriesState = v7.subcategoriesState
	local isFadingOut = v7.isFadingOut

	local v8 = React.useCallback(function()
		props.selectCategoryId(module.DefaultCatalogCategoryId)
	end, { props.selectCategoryId })

	local v9 = React.useCallback(function()
		return React.createElement(focusable[categoryPillCloseButton], {
			pillIndex = 1,
			onActivated = v8,
			categoryButtonRefs = categoryButtonRefs,
			navButtonRefs = navButtonRefs
		})
	end, { v8 })

	local v10 = React.useCallback(function(props2, pillIndex, isSelectable)
		local isSubcategory = props2.isSubcategory
		local v12 = (if isSubcategory then props.selectedSubcategoryId else props.selectedCategoryId) == props2.Id
		local selectCategoryId = props.selectCategoryId
		local selectSubcategoryId = props.selectSubcategoryId

		local createElement = React.createElement
		local v13 = focusable[module4]
		local v14 = {
			id = props2.Id,
			title = props2.Title,
			localizedTitle = 0,
			isChecked = 0,
			onActivated = 0,
			pillIndex = 0,
			isSubcategory = 0,
			categoryButtonRefs = 0,
			navButtonRefs = 0,
			categories = 0,
			isSelectable = 0,
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
			elseif v12 then
				selectCategoryId(module.DefaultCatalogCategoryId)
			else
				selectCategoryId(props2.Id)
			end
		end
		v14.pillIndex = pillIndex
		v14.isSubcategory = isSubcategory
		v14.categoryButtonRefs = categoryButtonRefs
		v14.navButtonRefs = navButtonRefs
		v14.categories = props.categories
		v14.isSelectable = isSelectable
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
		props.selectSubcategoryId,
		props.navHeight
	})

	local xSmall = v6.Padding.XSmall

	local createElement = React.createElement
	local view = Foundation.View
	local v11 = {
		tag = "auto-xy",
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local children = {
		CloseButtonFrame = React.createElement(Foundation.View, {
			tag = "auto-xy radius-circle align-x-center align-y-center",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			ZIndex = 3,
			backgroundStyle = surface_0,
			ref = ref,
			Visible = shouldShowSubcategories
		}, { CloseButton = v9() }),
		CategoriesFrame = 0,
		SubcategoriesFrame = 0
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v12 = {
		tag = "auto-xy",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ZIndex = 1
	}
	local v13 = 0
	local v14 = 2
	local children2 = {}

	for k, category in props.categories do
		if category.Id == nil then
			module3("AnimatedPillsScrollableContent: Selected category does not have an ID" .. category.Name)
		else
			local v15 = not (ref.current and ref.current.AbsoluteSize) and 0 or ref.current.AbsoluteSize.X

			local v16 = props.selectedCategoryId == category.Id and props.shouldShowSubcategories

			local v17 = if v16 then v15 + xSmall else v13

			children2[category.Id] = React.createElement(animatedCategoryPill, {
				catInfo = category,
				pillIndex = v14,
				isSelected = props.selectedCategoryId == category.Id,
				shouldShowSubcategories = props.shouldShowSubcategories,
				closeButtonWidth = v15,
				targetX = v17,
				renderCategoryPill = v10,
				onRef = function(p2)
					if p2 then
						ref2.current[category.Id] = p2
					end
				end
			})

			local v18 = not (ref2.current[category.Id] and ref2.current[category.Id].AbsoluteSize) and 0
				or ref2.current[category.Id].AbsoluteSize.X

			v13 = v13 + xSmall + v18

			if v16 then
				ref3.current = v17 + xSmall + v18
			end

			v14 += 1
		end
	end

	children.CategoriesFrame = createElement2(view2, v12, children2)

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v15 = {
		tag = "auto-xy",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, ref3.current, 0.5, 0),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ZIndex = 2,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, xSmall),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}
	local v16 = 3
	local children3 = {}

	for k, v17 in subcategoriesState do
		if v17.Id == nil then
			module3("AnimatedPillsScrollableContent: Selected subcategory does not have an ID" .. v17.Name)
		else
			children3[v17.Id] = React.createElement(animatedSubcategoryPill, {
				subcategory = v17,
				pillIndex = v16,
				renderCategoryPill = v10,
				isFadingOut = isFadingOut,
				isSelectable = not isFadingOut
			})

			v16 += 1
		end
	end

	children.SubcategoriesFrame = createElement3(view3, v15, children3)
	return createElement(view, v11, children)
end
