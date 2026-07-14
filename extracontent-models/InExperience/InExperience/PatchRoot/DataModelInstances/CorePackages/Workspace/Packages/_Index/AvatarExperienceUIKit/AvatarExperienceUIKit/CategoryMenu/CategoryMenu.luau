local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local Badge = Foundation.Badge
local Coachmark = Foundation.Coachmark
local IconButton = Foundation.IconButton
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local InputSize = Foundation.Enums.InputSize
local IconVariant = Foundation.Enums.IconVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local AvatarExperienceFlags = require(AvatarExperienceUIKitParent.AvatarExperienceFlags)
local FFlagAXResetSubcategoryRowOnCategoryChange = AvatarExperienceFlags.FFlagAXResetSubcategoryRowOnCategoryChange
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local v17 = game:DefineFastFlag("AXCategoryMenuBadgePositionTokens", false)
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

local function CategoryMenuButtonGroup(t4: {[any]: any}) -- line: 74
	-- upvalues: v17 (copy), Foundation (copy), React (copy), FFlagAXMigrateAllTabToSduiDev (copy), IconVariant (copy), View (copy), IconButton (copy), InputSize (copy), Badge (copy), BadgeVariant (copy)
	local v26 = if not v17 then nil else Foundation.Hooks.useTokens()
	local t4BackgroundColor3 = t4.BackgroundColor3
	local t4BackgroundTransparency = t4.BackgroundTransparency
	local v29 = React.useMemo(function() -- line: 80
		-- upvalues: React (copy), t4 (copy), v17 (copy), FFlagAXMigrateAllTabToSduiDev (copy), IconVariant (copy), View (copy), IconButton (copy), InputSize (copy), t4BackgroundColor3 (copy), t4BackgroundTransparency (copy), Badge (copy), BadgeVariant (copy), v26 (copy)
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
			for v49, v50 in t4.buttons do
				local v51 = `Button-{ v50.id }`

				if v17 then
					local badgeCount = v50.badgeCount
					local v53 = typeof(badgeCount) == "number" and badgeCount > 0
					local v54 = if not FFlagAXMigrateAllTabToSduiDev then IconVariant.Filled else IconVariant.Regular
					local v55 = v50.iconVariant or v54

					t5[v51] = React.createElement(View, {
						LayoutOrder = v49,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						IconButton = React.createElement(IconButton, {
							onActivated = v50.onActivated,
							icon = {
								name = v50.icon,
								variant = v55
							},
							size = InputSize.Small,
							isDisabled = v50.isDisabled,
							BackgroundColor3 = t4BackgroundColor3,
							BackgroundTransparency = t4BackgroundTransparency == nil and 1 or t4BackgroundTransparency
						}),
						CountBadge = if not v53 then nil else React.createElement(Badge, {
							ZIndex = 2,
							text = if not (badgeCount > 99) then tostring(badgeCount) else "99+",
							variant = BadgeVariant.Contrast,
							AnchorPoint = Vector2.new(1, 0),
							Position = if not v26 then UDim2.new(1, 0, 0, -4) else UDim2.new(1, v26.Gap.XXSmall, 0, -v26.Gap.XXSmall)
						})
					})
				else
					t5[v51] = React.createElement(IconButton, {
						onActivated = v50.onActivated,
						LayoutOrder = v49,
						icon = {
							name = v50.icon,
							variant = IconVariant.Filled
						},
						size = InputSize.Small,
						isDisabled = v50.isDisabled,
						BackgroundColor3 = t4BackgroundColor3,
						BackgroundTransparency = t4BackgroundTransparency == nil and 1 or t4BackgroundTransparency
					})
				end
			end
		end

		return t5
	end, {
		t4.buttons,
		t4BackgroundColor3,
		t4BackgroundTransparency,
		v26
	})

	return React.createElement(View, {
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = t4.LayoutOrder
	}, v29)
end
local function CategoryMenu(t6: {[any]: any}, p1) -- line: 202
	-- upvalues: React (copy), Foundation (copy), FFlagAXResetSubcategoryRowOnCategoryChange (copy), CategoryMenuButtonsLocationEnum (copy), View (copy), t2 (copy), t1 (copy), CategoryMenuButtonGroup (copy), t3 (copy), TabGroup (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	local v32 = React.useRef(nil)
	local v33 = Foundation.Hooks.useTokens()
	local v34 = nil

	if FFlagAXResetSubcategoryRowOnCategoryChange then
		local v35 = React.useRef(nil)

		v34 = v35

		local v36 = React.useRef(false)

		React.useEffect(function() -- line: 215
			-- upvalues: v36 (copy), v35 (copy)
			if not v36.current then
				v36.current = true

				return
			end

			local current = v35.current

			if current then
				current.setOffset(0)
			end
		end, { t6.activeCategoryId })
	end

	local activeTooltipIdx = t6.activeTooltipIdx
	local tooltips = t6.tooltips
	local v39 = if not activeTooltipIdx or not tooltips then nil else tooltips[activeTooltipIdx]
	local v40 = React.useMemo(function() -- line: 230
		-- upvalues: v39 (copy), t6 (copy), v32 (copy)
		local t7 = {}

		if v39 then
			for _, v59 in t6.categories do
				if v59.id == v39.anchorId then
					local v60 = table.clone(v59)

					v60.ref = v32
					table.insert(t7, v60)
				else
					table.insert(t7, v59)
				end
			end

			return t7
		end

		return t6.categories
	end, {
		t6.categories,
		v39
	})
	local v41 = if not t6.categoryBackgroundStyle then v33.Color.Common.NavigationBar else t6.categoryBackgroundStyle
	local v42 = if not t6.subcategoryBackgroundStyle then v33.Color.Common.NavigationBar else t6.subcategoryBackgroundStyle
	local v43 = if not t6.buttonsLocation then CategoryMenuButtonsLocationEnum.SubcategoriesStart else t6.buttonsLocation
	local v44 = not not t6.buttons and #t6.buttons > 0
	local subcategories = t6.subcategories
	local v46 = not not subcategories and #subcategories > 0
	local v47 = v46 or v44

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
			ButtonsStart = if not v44 or v43 ~= CategoryMenuButtonsLocationEnum.CategoriesStart then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = t6.buttons,
				BackgroundColor3 = v41.Color3,
				BackgroundTransparency = v41.Transparency
			}),
			Categories = React.createElement(View, {
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = t3
			}, {
				TabGroup = React.createElement(TabGroup, {
					items = v40,
					activeTabId = t6.activeCategoryId,
					onTabActivated = t6.onCategoryActivated,
					tabFontStyle = t6.categoryFontStyle,
					tabPadding = t6.categoryPadding,
					tabTextStyle = t6.categoryTextStyle,
					tabActiveTextStyle = t6.categoryActiveTextStyle,
					BackgroundColor3 = v41.Color3,
					BackgroundTransparency = v41.Transparency
				})
			}),
			ButtonsEnd = if not v44 or v43 ~= CategoryMenuButtonsLocationEnum.CategoriesEnd then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = t6.buttons,
				BackgroundColor3 = v41.Color3,
				BackgroundTransparency = v41.Transparency
			})
		}),
		SubcategoryRow = if not v47 then nil else React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = t1
		}, {
			ButtonsStart = if not v44 or v43 ~= CategoryMenuButtonsLocationEnum.SubcategoriesStart then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = t6.buttons,
				BackgroundColor3 = v42.Color3,
				BackgroundTransparency = v42.Transparency
			}),
			Subcategories = if not v46 then nil else React.createElement(View, {
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
					BackgroundColor3 = v42.Color3,
					BackgroundTransparency = v42.Transparency,
					controllerRef = v34
				})
			}),
			ButtonsEnd = if not v44 or v43 ~= CategoryMenuButtonsLocationEnum.SubcategoriesEnd then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = t6.buttons,
				BackgroundColor3 = v42.Color3,
				BackgroundTransparency = v42.Transparency
			})
		}),
		ToolTip = if not v39 then nil else React.createElement(Coachmark, {
			LayoutOrder = 3,
			title = v39.title,
			text = v39.text,
			isOpen = v39.isOpen,
			side = v39.side or PopoverSide.Bottom,
			align = v39.align or PopoverAlign.Center,
			anchorRef = v32,
			onClose = v39.onClose,
			actions = v39.actions
		})
	})
end

return React.forwardRef(CategoryMenu)
