local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Badge = Foundation.Badge
local Coachmark = Foundation.Coachmark
local IconButton = Foundation.IconButton
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local InputSize = Foundation.Enums.InputSize
local IconVariant = Foundation.Enums.IconVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local defineFastFlag = game:DefineFastFlag("AXCategoryMenuBadgePositionTokens2", false)

local TabGroup = require(AvatarExperienceUIKit.TabGroup.TabGroup)

local CategoryMenuButtonsLocationEnum = require(script.Parent.CategoryMenuButtonsLocationEnum)

local layout = {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.Fill
}

local layout2 = {
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}

local flexItem = { FlexMode = Enum.UIFlexMode.Fill }

local function CategoryMenuButtonGroup(props)
	local v

	if defineFastFlag then
		v = Foundation.Hooks.useTokens()
	else
		v = nil
	end

	local backgroundColor3 = props.BackgroundColor3
	local backgroundTransparency = props.BackgroundTransparency
	local v2 = React.useMemo(function()
		local children = {
			FlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.None }),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}

		if not props.buttons then
			return children
		end

		for k, button in props.buttons do
			local formatted = `Button-{button.id}`

			if defineFastFlag then
				local badgeCount = button.badgeCount
				local v2

				if typeof(badgeCount) == "number" then
					v2 = badgeCount > 0
				else
					v2 = false
				end

				local v3

				if FFlagAXMigrateAllTabToSduiDev then
					v3 = IconVariant.Regular
				else
					v3 = IconVariant.Filled
				end

				local iconVariant = button.iconVariant or v3

				local createElement = React.createElement
				local v4 = { LayoutOrder = k, AutomaticSize = Enum.AutomaticSize.XY }
				local v5 = {
					IconButton = React.createElement(IconButton, {
						onActivated = button.onActivated,
						icon = { name = button.icon, variant = iconVariant },
						size = InputSize.Medium,
						isDisabled = button.isDisabled,
						BackgroundColor3 = backgroundColor3,
						BackgroundTransparency = backgroundTransparency == nil and 1 or backgroundTransparency
					}),
					CountBadge = 0
				}
				local countBadge

				if v2 then
					local createElement2 = React.createElement
					local v6 = {
						text = badgeCount > 99 and "99+" or tostring(badgeCount),
						variant = BadgeVariant.Contrast,
						AnchorPoint = Vector2.new(1, 0),
						Position = 0,
						ZIndex = 2
					}
					local position

					if v then
						position = UDim2.new(1, v.Gap.XXSmall, 0, -v.Gap.XXSmall)
					else
						position = UDim2.new(1, 0, 0, -4)
					end

					v6.Position = position
					countBadge = createElement2(Badge, v6)
				end

				v5.CountBadge = countBadge
				children[formatted] = createElement(View, v4, v5)
			else
				children[formatted] = React.createElement(IconButton, {
					onActivated = button.onActivated,
					LayoutOrder = k,
					icon = { name = button.icon, variant = IconVariant.Filled },
					size = InputSize.Small,
					isDisabled = button.isDisabled,
					BackgroundColor3 = backgroundColor3,
					BackgroundTransparency = backgroundTransparency == nil and 1 or backgroundTransparency
				})
			end
		end

		return children
	end, { props.buttons, backgroundColor3, backgroundTransparency, v })
	local padding

	if defineFastFlag then
		local paddingRight = props.paddingRight
		padding = React.useMemo(function()
			if paddingRight then
				return { right = paddingRight }
			end

			return nil
		end, { paddingRight })
	end

	return React.createElement(
		View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = props.LayoutOrder,
			padding = padding
		},
		v2
	)
end

local function CategoryMenu(props, ref4)
	local ref = React.useRef(nil)
	local v = Foundation.Hooks.useTokens()
	local ref2

	if FFlagAXCategoryMenuVisualFixes then
		ref2 = React.useRef(nil)

		local ref3 = React.useRef(false)
		React.useEffect(function()
			if not ref3.current then
				ref3.current = true
				return
			end

			local current = ref2.current

			if current then
				current.setOffset(0)
			end
		end, { props.activeCategoryId })
	else
		ref2 = nil
	end

	local activeTooltipIdx = props.activeTooltipIdx
	local tooltips = props.tooltips
	local v2

	if activeTooltipIdx and tooltips then
		v2 = tooltips[activeTooltipIdx]
	else
		v2 = nil
	end

	local items = React.useMemo(function()
		local result = {}

		if not v2 then
			return props.categories
		end

		for _, category in props.categories do
			if category.id == v2.anchorId then
				local clone = table.clone(category)
				clone.ref = ref
				table.insert(result, clone)
			else
				table.insert(result, category)
			end
		end

		return result
	end, { props.categories, v2 })
	local v3

	if props.categoryBackgroundStyle then
		v3 = props.categoryBackgroundStyle
	else
		v3 = v.Color.Common.NavigationBar
	end

	local v4

	if props.subcategoryBackgroundStyle then
		v4 = props.subcategoryBackgroundStyle
	else
		v4 = v.Color.Common.NavigationBar
	end

	local v5

	if props.buttonsLocation then
		v5 = props.buttonsLocation
	else
		v5 = CategoryMenuButtonsLocationEnum.SubcategoriesStart
	end

	local v6

	if props.buttons then
		v6 = #props.buttons > 0
	else
		v6 = false
	end

	local udim

	if defineFastFlag then
		udim = UDim.new(0, v.Padding.Medium)
	end

	local subcategories = props.subcategories
	local v7

	if subcategories then
		v7 = #subcategories > 0
	else
		v7 = false
	end

	local createElement = React.createElement
	local v8 = {
		ref = ref4,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		layout = layout2
	}

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		layout = layout
	}
	local buttonsStart

	if v6 and v5 == CategoryMenuButtonsLocationEnum.CategoriesStart then
		buttonsStart = React.createElement(CategoryMenuButtonGroup, {
			LayoutOrder = 1,
			buttons = props.buttons,
			BackgroundColor3 = v3.Color3,
			BackgroundTransparency = v3.Transparency
		})
	end

	local v10 = {
		ButtonsStart = buttonsStart,
		Categories = React.createElement(
			View,
			{
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = flexItem
			},
			{
				TabGroup = React.createElement(TabGroup, {
					items = items,
					activeTabId = props.activeCategoryId,
					onTabActivated = props.onCategoryActivated,
					tabFontStyle = props.categoryFontStyle,
					tabPadding = props.categoryPadding,
					tabTextStyle = props.categoryTextStyle,
					tabActiveTextStyle = props.categoryActiveTextStyle,
					BackgroundColor3 = v3.Color3,
					BackgroundTransparency = v3.Transparency
				})
			}
		),
		ButtonsEnd = 0
	}
	local buttonsEnd

	if v6 and v5 == CategoryMenuButtonsLocationEnum.CategoriesEnd then
		buttonsEnd = React.createElement(CategoryMenuButtonGroup, {
			LayoutOrder = 3,
			buttons = props.buttons,
			BackgroundColor3 = v3.Color3,
			BackgroundTransparency = v3.Transparency,
			paddingRight = udim
		})
	end

	v10.ButtonsEnd = buttonsEnd
	local v11 = { CategoryRow = createElement2(View, v9, v10), SubcategoryRow = 0, ToolTip = 0 }
	local subcategoryRow

	if v7 or v6 then
		local createElement3 = React.createElement
		local v12 = {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = layout
		}
		local buttonsStart2

		if v6 and v5 == CategoryMenuButtonsLocationEnum.SubcategoriesStart then
			buttonsStart2 = React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 1,
				buttons = props.buttons,
				BackgroundColor3 = v4.Color3,
				BackgroundTransparency = v4.Transparency
			})
		end

		local subcategories2

		if v7 then
			subcategories2 = React.createElement(
				View,
				{
					LayoutOrder = 2,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					flexItem = flexItem
				},
				{
					TabGroup = React.createElement(TabGroup, {
						items = subcategories or {},
						activeTabId = props.activeSubcategoryId,
						onTabActivated = props.onSubcategoryActivated,
						tabFontStyle = props.subcategoryFontStyle,
						tabPadding = props.subcategoryPadding,
						tabTextStyle = props.subcategoryTextStyle,
						tabActiveTextStyle = props.subcategoryActiveTextStyle,
						BackgroundColor3 = v4.Color3,
						BackgroundTransparency = v4.Transparency,
						controllerRef = ref2
					})
				}
			)
		end

		local buttonsEnd2

		if v6 and v5 == CategoryMenuButtonsLocationEnum.SubcategoriesEnd then
			buttonsEnd2 = React.createElement(CategoryMenuButtonGroup, {
				LayoutOrder = 3,
				buttons = props.buttons,
				BackgroundColor3 = v4.Color3,
				BackgroundTransparency = v4.Transparency,
				paddingRight = udim
			})
		end

		subcategoryRow = createElement3(View, v12, {
			ButtonsStart = buttonsStart2,
			Subcategories = subcategories2,
			ButtonsEnd = buttonsEnd2
		})
	end

	v11.SubcategoryRow = subcategoryRow
	local toolTip

	if v2 then
		toolTip = React.createElement(Coachmark, {
			LayoutOrder = 3,
			title = v2.title,
			text = v2.text,
			isOpen = v2.isOpen,
			side = v2.side or PopoverSide.Bottom,
			align = v2.align or PopoverAlign.Center,
			anchorRef = ref,
			onClose = v2.onClose,
			actions = v2.actions
		})
	end

	v11.ToolTip = toolTip
	return createElement(View, v8, v11)
end

return React.forwardRef(CategoryMenu)
