local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local Coachmark = Foundation.Coachmark
local IconButton = Foundation.IconButton
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local IconVariant = Foundation.Enums.IconVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local TabGroup = require(AvatarExperienceUIKit.TabGroup.TabGroup)
local CategoryMenuButtonsLocationEnum = require(script.Parent.CategoryMenuButtonsLocationEnum)
local t1 = {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.Fill
}
local t2 = {
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}
local t3 = {
	FlexMode = Enum.UIFlexMode.Fill
}

local function CategoryMenuButtonGroup(t4: {[any]: any}) -- line: 58
	-- upvalues: React (copy), IconButton (copy), IconVariant (copy), InputSize (copy), View (copy)
	local t4BackgroundColor3 = t4.BackgroundColor3
	local t4BackgroundTransparency = t4.BackgroundTransparency
	local v22 = React.useMemo(function() -- line: 61
		-- upvalues: React (copy), t4 (copy), IconButton (copy), IconVariant (copy), InputSize (copy), t4BackgroundColor3 (copy), t4BackgroundTransparency (copy)
		local t5 = {
			FlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.None
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}

		if t4.buttons then
			for v39, v40 in t4.buttons do
				t5[`Button-{ v40.id }`] = React.createElement(IconButton, {
					onActivated = v40.onActivated,
					LayoutOrder = v39,
					icon = {
						name = v40.icon,
						variant = IconVariant.Filled
					},
					size = InputSize.Small,
					isDisabled = v40.isDisabled,
					BackgroundColor3 = t4BackgroundColor3,
					BackgroundTransparency = t4BackgroundTransparency == nil and 1 or t4BackgroundTransparency
				})
			end
		end

		return t5
	end, {
		t4.buttons,
		t4BackgroundColor3,
		t4BackgroundTransparency
	})

	return React.createElement(View, {
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = t4.LayoutOrder
	}, v22)
end
local function CategoryMenu(t6: {[any]: any}, p1) -- line: 140
	-- upvalues: React (copy), Foundation (copy), CategoryMenuButtonsLocationEnum (copy), View (copy), t2 (copy), t1 (copy), CategoryMenuButtonGroup (copy), t3 (copy), TabGroup (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	local v25 = React.useRef(nil)
	local v26 = Foundation.Hooks.useTokens()
	local activeTooltipIdx = t6.activeTooltipIdx
	local tooltips = t6.tooltips
	local v29 = if not activeTooltipIdx or not tooltips then nil else tooltips[activeTooltipIdx]
	local v30 = React.useMemo(function() -- line: 147
		-- upvalues: v29 (copy), t6 (copy), v25 (copy)
		local t7 = {}

		if v29 then
			for _, v43 in t6.categories do
				if v43.id == v29.anchorId then
					local v44 = table.clone(v43)

					v44.ref = v25
					table.insert(t7, v44)
				else
					table.insert(t7, v43)
				end
			end

			return t7
		end

		return t6.categories
	end, {
		t6.categories,
		v29
	})
	local v31 = if not t6.categoryBackgroundStyle then v26.Color.Common.NavigationBar else t6.categoryBackgroundStyle
	local v32 = if not t6.subcategoryBackgroundStyle then v26.Color.Common.NavigationBar else t6.subcategoryBackgroundStyle
	local v33 = if not t6.buttonsLocation then CategoryMenuButtonsLocationEnum.SubcategoriesStart else t6.buttonsLocation
	local v34 = not not t6.buttons and #t6.buttons > 0
	local subcategories = t6.subcategories
	local v36 = not not subcategories and #subcategories > 0
	local v37 = v36 or v34

	return React.createElement(View, {
		ref = p1,
		Position = t6.Position,
		LayoutOrder = t6.LayoutOrder,
		ZIndex = t6.ZIndex,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		layout = t2
	}, {
		CategoryRow = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = t1
		}, {
			ButtonsStart = if not v34 or v33 ~= CategoryMenuButtonsLocationEnum.CategoriesStart then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = t6.buttons,
				BackgroundColor3 = v31.Color3,
				BackgroundTransparency = v31.Transparency
			}),
			Categories = React.createElement(View, {
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = t3
			}, {
				TabGroup = React.createElement(TabGroup, {
					items = v30,
					activeTabId = t6.activeCategoryId,
					onTabActivated = t6.onCategoryActivated,
					tabFontStyle = t6.categoryFontStyle,
					tabPadding = t6.categoryPadding,
					tabTextStyle = t6.categoryTextStyle,
					tabActiveTextStyle = t6.categoryActiveTextStyle,
					BackgroundColor3 = v31.Color3,
					BackgroundTransparency = v31.Transparency
				})
			}),
			ButtonsEnd = if not v34 or v33 ~= CategoryMenuButtonsLocationEnum.CategoriesEnd then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = t6.buttons,
				BackgroundColor3 = v31.Color3,
				BackgroundTransparency = v31.Transparency
			})
		}),
		SubcategoryRow = if not v37 then nil else React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = t1
		}, {
			ButtonsStart = if not v34 or v33 ~= CategoryMenuButtonsLocationEnum.SubcategoriesStart then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = t6.buttons,
				BackgroundColor3 = v32.Color3,
				BackgroundTransparency = v32.Transparency
			}),
			Subcategories = if not v36 then nil else React.createElement(View, {
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = t3
			}, {
				TabGroup = React.createElement(TabGroup, {
					items = subcategories or {},
					activeTabId = t6.activeSubcategoryId,
					onTabActivated = t6.onSubcategoryActivated,
					tabFontStyle = t6.subcategoryFontStyle,
					tabPadding = t6.subcategoryPadding,
					tabTextStyle = t6.subcategoryTextStyle,
					tabActiveTextStyle = t6.subcategoryActiveTextStyle,
					BackgroundColor3 = v32.Color3,
					BackgroundTransparency = v32.Transparency
				})
			}),
			ButtonsEnd = if not v34 or v33 ~= CategoryMenuButtonsLocationEnum.SubcategoriesEnd then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = t6.buttons,
				BackgroundColor3 = v32.Color3,
				BackgroundTransparency = v32.Transparency
			})
		}),
		ToolTip = if not v29 then nil else React.createElement(Coachmark, {
			LayoutOrder = 3,
			title = v29.title,
			text = v29.text,
			isOpen = v29.isOpen,
			side = v29.side or PopoverSide.Bottom,
			align = v29.align or PopoverAlign.Center,
			anchorRef = v25,
			onClose = v29.onClose,
			actions = v29.actions
		})
	})
end

return React.forwardRef(CategoryMenu)
