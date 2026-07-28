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
local FFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local v17 = game:DefineFastFlag("AXCategoryMenuBadgePositionTokens2", false)
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

local function CategoryMenuButtonGroup(t4: {[any]: any}) -- line: 76
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
			for v52, v53 in t4.buttons do
				local v54 = `Button-{ v53.id }`

				if v17 then
					local badgeCount = v53.badgeCount
					local v56 = typeof(badgeCount) == "number" and badgeCount > 0
					local v57 = if not FFlagAXMigrateAllTabToSduiDev then IconVariant.Filled else IconVariant.Regular
					local v58 = v53.iconVariant or v57

					t5[v54] = React.createElement(View, {
						LayoutOrder = v52,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						IconButton = React.createElement(IconButton, {
							onActivated = v53.onActivated,
							icon = {
								name = v53.icon,
								variant = v58
							},
							size = InputSize.Medium,
							isDisabled = v53.isDisabled,
							BackgroundColor3 = t4BackgroundColor3,
							BackgroundTransparency = t4BackgroundTransparency == nil and 1 or t4BackgroundTransparency
						}),
						CountBadge = if not v56 then nil else React.createElement(Badge, {
							ZIndex = 2,
							text = if not (badgeCount > 99) then tostring(badgeCount) else "99+",
							variant = BadgeVariant.Contrast,
							AnchorPoint = Vector2.new(1, 0),
							Position = if not v26 then UDim2.new(1, 0, 0, -4) else UDim2.new(1, v26.Gap.XXSmall, 0, -v26.Gap.XXSmall)
						})
					})
				else
					t5[v54] = React.createElement(IconButton, {
						onActivated = v53.onActivated,
						LayoutOrder = v52,
						icon = {
							name = v53.icon,
							variant = IconVariant.Filled
						},
						size = InputSize.Small,
						isDisabled = v53.isDisabled,
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
	local v30 = nil

	if v17 then
		local paddingRight = t4.paddingRight

		v30 = React.useMemo(function() -- line: 155
			-- upvalues: paddingRight (copy)
			if paddingRight then
				return {
					right = paddingRight
				}
			end

			return nil
		end, { paddingRight })
	end

	return React.createElement(View, {
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = t4.LayoutOrder,
		padding = v30
	}, v29)
end
local function CategoryMenu(t6: {[any]: any}, p1) -- line: 210
	-- upvalues: React (copy), Foundation (copy), FFlagAXCategoryMenuVisualFixes (copy), CategoryMenuButtonsLocationEnum (copy), v17 (copy), View (copy), t2 (copy), t1 (copy), CategoryMenuButtonGroup (copy), t3 (copy), TabGroup (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	local v34 = React.useRef(nil)
	local v35 = Foundation.Hooks.useTokens()
	local v36 = nil

	if FFlagAXCategoryMenuVisualFixes then
		local v37 = React.useRef(nil)

		v36 = v37

		local v38 = React.useRef(false)

		React.useEffect(function() -- line: 223
			-- upvalues: v38 (copy), v37 (copy)
			if not v38.current then
				v38.current = true

				return
			end

			local current = v37.current

			if current then
				current.setOffset(0)
			end
		end, { t6.activeCategoryId })
	end

	local activeTooltipIdx = t6.activeTooltipIdx
	local tooltips = t6.tooltips
	local v41 = if not activeTooltipIdx or not tooltips then nil else tooltips[activeTooltipIdx]
	local v42 = React.useMemo(function() -- line: 238
		-- upvalues: v41 (copy), t6 (copy), v34 (copy)
		local t7 = {}

		if v41 then
			for _, v62 in t6.categories do
				if v62.id == v41.anchorId then
					local v63 = table.clone(v62)

					v63.ref = v34
					table.insert(t7, v63)
				else
					table.insert(t7, v62)
				end
			end

			return t7
		end

		return t6.categories
	end, {
		t6.categories,
		v41
	})
	local v43 = if not t6.categoryBackgroundStyle then v35.Color.Common.NavigationBar else t6.categoryBackgroundStyle
	local v44 = if not t6.subcategoryBackgroundStyle then v35.Color.Common.NavigationBar else t6.subcategoryBackgroundStyle
	local v45 = if not t6.buttonsLocation then CategoryMenuButtonsLocationEnum.SubcategoriesStart else t6.buttonsLocation
	local v46 = not not t6.buttons and #t6.buttons > 0
	local v47 = if not v17 then nil else UDim.new(0, v35.Padding.Medium)
	local subcategories = t6.subcategories
	local v49 = not not subcategories and #subcategories > 0
	local v50 = v49 or v46

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
			ButtonsStart = if not v46 or v45 ~= CategoryMenuButtonsLocationEnum.CategoriesStart then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = t6.buttons,
				BackgroundColor3 = v43.Color3,
				BackgroundTransparency = v43.Transparency
			}),
			Categories = React.createElement(View, {
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = t3
			}, {
				TabGroup = React.createElement(TabGroup, {
					items = v42,
					activeTabId = t6.activeCategoryId,
					onTabActivated = t6.onCategoryActivated,
					tabFontStyle = t6.categoryFontStyle,
					tabPadding = t6.categoryPadding,
					tabTextStyle = t6.categoryTextStyle,
					tabActiveTextStyle = t6.categoryActiveTextStyle,
					BackgroundColor3 = v43.Color3,
					BackgroundTransparency = v43.Transparency
				})
			}),
			ButtonsEnd = if not v46 or v45 ~= CategoryMenuButtonsLocationEnum.CategoriesEnd then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = t6.buttons,
				BackgroundColor3 = v43.Color3,
				BackgroundTransparency = v43.Transparency,
				paddingRight = v47
			})
		}),
		SubcategoryRow = if not v50 then nil else React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = t1
		}, {
			ButtonsStart = if not v46 or v45 ~= CategoryMenuButtonsLocationEnum.SubcategoriesStart then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = t6.buttons,
				BackgroundColor3 = v44.Color3,
				BackgroundTransparency = v44.Transparency
			}),
			Subcategories = if not v49 then nil else React.createElement(View, {
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
					BackgroundColor3 = v44.Color3,
					BackgroundTransparency = v44.Transparency,
					controllerRef = v36
				})
			}),
			ButtonsEnd = if not v46 or v45 ~= CategoryMenuButtonsLocationEnum.SubcategoriesEnd then nil else React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = t6.buttons,
				BackgroundColor3 = v44.Color3,
				BackgroundTransparency = v44.Transparency,
				paddingRight = v47
			})
		}),
		ToolTip = if not v41 then nil else React.createElement(Coachmark, {
			LayoutOrder = 3,
			title = v41.title,
			text = v41.text,
			isOpen = v41.isOpen,
			side = v41.side or PopoverSide.Bottom,
			align = v41.align or PopoverAlign.Center,
			anchorRef = v34,
			onClose = v41.onClose,
			actions = v41.actions
		})
	})
end

return React.forwardRef(CategoryMenu)
