local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local badge = Foundation.Badge
local coachmark = Foundation.Coachmark
local iconButton = Foundation.IconButton
local view = Foundation.View
local badgeVariant = Foundation.Enums.BadgeVariant
local inputSize = Foundation.Enums.InputSize
local iconVariant = Foundation.Enums.IconVariant
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local fFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local defineFastFlag = game:DefineFastFlag("AXCategoryMenuBadgePositionTokens2", false)

local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/TabGroup/TabGroup")

local CategoryMenuButtonsLocationEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/CategoryMenu/CategoryMenuButtonsLocationEnum")

local v5 = {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.Fill
}

local v6 = {
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder
}

local v7 = { FlexMode = Enum.UIFlexMode.Fill }

local function CategoryMenuButtonGroup(props)
	local v8 = if defineFastFlag then Foundation.Hooks.useTokens() else nil
	local backgroundColor3 = props.BackgroundColor3
	local backgroundTransparency = props.BackgroundTransparency
	local v9 = React.useMemo(function()
		local children = {
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

		if not props.buttons then
			return children
		end

		for k, button in props.buttons do
			local formatted = `Button-{button.id}`

			if defineFastFlag then
				local badgeCount = button.badgeCount
				local v10 = typeof(badgeCount) == "number" and badgeCount > 0

				local v11 = if fFlagAXMigrateAllTabToSduiDev then iconVariant.Regular else iconVariant.Filled
				local iconVariant2 = button.iconVariant or v11

				local createElement = React.createElement
				local v13 = { LayoutOrder = k, AutomaticSize = Enum.AutomaticSize.XY }
				local v14 = {
					IconButton = React.createElement(iconButton, {
						onActivated = button.onActivated,
						icon = { name = button.icon, variant = iconVariant2 },
						size = inputSize.Medium,
						isDisabled = button.isDisabled,
						BackgroundColor3 = backgroundColor3,
						BackgroundTransparency = backgroundTransparency == nil and 1 or backgroundTransparency
					}),
					CountBadge = 0
				}
				local v15

				if v10 then
					local createElement2 = React.createElement
					local v17 = {
						text = badgeCount > 99 and "99+" or tostring(badgeCount),
						variant = badgeVariant.Contrast,
						AnchorPoint = Vector2.new(1, 0),
						Position = 0,
						ZIndex = 2
					}

					local v18 = if v8 then UDim2.new(1, v8.Gap.XXSmall, 0, -v8.Gap.XXSmall) else UDim2.new(1, 0, 0, -4)
					v17.Position = v18
					v15 = createElement2(badge, v17)
				end

				v14.CountBadge = v15
				children[formatted] = createElement(view, v13, v14)
			else
				children[formatted] = React.createElement(iconButton, {
					onActivated = button.onActivated,
					LayoutOrder = k,
					icon = { name = button.icon, variant = iconVariant.Filled },
					size = inputSize.Small,
					isDisabled = button.isDisabled,
					BackgroundColor3 = backgroundColor3,
					BackgroundTransparency = backgroundTransparency == nil and 1 or backgroundTransparency
				})
			end
		end

		return children
	end, { props.buttons, backgroundColor3, backgroundTransparency, v8 })
	local v10

	if defineFastFlag then
		local paddingRight = props.paddingRight
		v10 = React.useMemo(function()
			if paddingRight then
				return { right = paddingRight }
			end

			return nil
		end, { paddingRight })
	end

	return React.createElement(
		view,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = props.LayoutOrder,
			padding = v10
		},
		v9
	)
end

local function CategoryMenu(props, p2)
	local ref = React.useRef(nil)
	local v8 = Foundation.Hooks.useTokens()
	local ref2

	if fFlagAXCategoryMenuVisualFixes then
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
	local v9 = if activeTooltipIdx and tooltips then tooltips[activeTooltipIdx] else nil
	local v10 = React.useMemo(function()
		local result = {}

		if not v9 then
			return props.categories
		end

		for k, category in props.categories do
			if category.id == v9.anchorId then
				local clone = table.clone(category)
				clone.ref = ref
				table.insert(result, clone)
			else
				table.insert(result, category)
			end
		end

		return result
	end, { props.categories, v9 })
	local v11

	if props.categoryBackgroundStyle then
		v11 = props.categoryBackgroundStyle
	else
		v11 = v8.Color.Common.NavigationBar
	end

	local v12

	if props.subcategoryBackgroundStyle then
		v12 = props.subcategoryBackgroundStyle
	else
		v12 = v8.Color.Common.NavigationBar
	end

	local v13 = if props.buttonsLocation then props.buttonsLocation else CategoryMenuButtonsLocationEnum.SubcategoriesStart

	local v14 = if props.buttons then #props.buttons > 0 else false

	local udim = if defineFastFlag then UDim.new(0, v8.Padding.Medium) else nil

	local subcategories = props.subcategories
	local v15 = if subcategories then #subcategories > 0 else false

	local createElement = React.createElement
	local v18 = {
		ref = p2,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		layout = v6
	}

	local createElement2 = React.createElement
	local v21 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		layout = v5
	}

	local v23 = if v14 and v13 == CategoryMenuButtonsLocationEnum.CategoriesStart then React.createElement(CategoryMenuButtonGroup, {
		LayoutOrder = 1,
		buttons = props.buttons,
		BackgroundColor3 = v11.Color3,
		BackgroundTransparency = v11.Transparency
	}) else nil
	local v22 = {
		ButtonsStart = v23,
		Categories = React.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = v7
			},
			{
				TabGroup = React.createElement(module4, {
					items = v10,
					activeTabId = props.activeCategoryId,
					onTabActivated = props.onCategoryActivated,
					tabFontStyle = props.categoryFontStyle,
					tabPadding = props.categoryPadding,
					tabTextStyle = props.categoryTextStyle,
					tabActiveTextStyle = props.categoryActiveTextStyle,
					BackgroundColor3 = v11.Color3,
					BackgroundTransparency = v11.Transparency
				})
			}
		),
		ButtonsEnd = 0
	}

	local v24 = if v14 and v13 == CategoryMenuButtonsLocationEnum.CategoriesEnd then React.createElement(CategoryMenuButtonGroup, {
		LayoutOrder = 3,
		buttons = props.buttons,
		BackgroundColor3 = v11.Color3,
		BackgroundTransparency = v11.Transparency,
		paddingRight = udim
	}) else nil
	v22.ButtonsEnd = v24
	local v19 = {
		CategoryRow = createElement2(view, v21, v22),
		SubcategoryRow = 0,
		ToolTip = 0
	}
	local v25

	if v15 or v14 then
		local createElement3 = React.createElement
		local v27 = {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			layout = v5
		}

		local v29 = if v14 and v13 == CategoryMenuButtonsLocationEnum.SubcategoriesStart then React.createElement(CategoryMenuButtonGroup, {
			LayoutOrder = 1,
			buttons = props.buttons,
			BackgroundColor3 = v12.Color3,
			BackgroundTransparency = v12.Transparency
		}) else nil

		local v30 = if v15 then React.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				flexItem = v7
			},
			{
				TabGroup = React.createElement(module4, {
					items = subcategories or {},
					activeTabId = props.activeSubcategoryId,
					onTabActivated = props.onSubcategoryActivated,
					tabFontStyle = props.subcategoryFontStyle,
					tabPadding = props.subcategoryPadding,
					tabTextStyle = props.subcategoryTextStyle,
					tabActiveTextStyle = props.subcategoryActiveTextStyle,
					BackgroundColor3 = v12.Color3,
					BackgroundTransparency = v12.Transparency,
					controllerRef = ref2
				})
			}
		) else nil

		local v31 = if v14 and v13 == CategoryMenuButtonsLocationEnum.SubcategoriesEnd then React.createElement(CategoryMenuButtonGroup, {
			LayoutOrder = 3,
			buttons = props.buttons,
			BackgroundColor3 = v12.Color3,
			BackgroundTransparency = v12.Transparency,
			paddingRight = udim
		}) else nil
		v25 = createElement3(view, v27, {
			ButtonsStart = v29,
			Subcategories = v30,
			ButtonsEnd = v31
		})
	end

	v19.SubcategoryRow = v25

	local v26 = if v9 then React.createElement(coachmark, {
		LayoutOrder = 3,
		title = v9.title,
		text = v9.text,
		isOpen = v9.isOpen,
		side = v9.side or popoverSide.Bottom,
		align = v9.align or popoverAlign.Center,
		anchorRef = ref,
		onClose = v9.onClose,
		actions = v9.actions
	}) else nil
	v19.ToolTip = v26
	return createElement(view, v18, v19)
end

return React.forwardRef(CategoryMenu)
