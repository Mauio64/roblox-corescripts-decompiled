local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)

require(AvatarExperienceControlBar.ControlBarTypes)
local IconItem = require(AvatarExperienceControlBar.Components.Items.IconItem)
local ImageItem = require(AvatarExperienceControlBar.Components.Items.ImageItem)
local ImageItemWithTooltip = require(AvatarExperienceControlBar.Components.Items.ImageItemWithTooltip)
local ColorItem = require(AvatarExperienceControlBar.Components.Items.ColorItem)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddToolTipToIconItemMenu = AvatarExperienceFlags.FFlagAXAddToolTipToIconItemMenu
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags2.FFlagAXMigrateBuilderIcons
local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
local FFlagAXResetAvatarButton = AvatarExperienceFlags3.FFlagAXResetAvatarButton
local AvatarExperienceFlags4 = require(parent.AvatarExperienceFlags)
local FFlagMeProfileEntryTooltipEnabled = AvatarExperienceFlags4.FFlagMeProfileEntryTooltipEnabled

local function IconOnlyMenu(props, ref)
	local v = useSemanticTokens()

	local useCallback = React.useCallback
	local function fn(props2)
		local item = props2.item
		local isActive = props2.isActive
		local onItemActivated = props2.onItemActivated

		local fn2 = (not FFlagAXResetAvatarButton or item.type ~= "divider") and function()
			if onItemActivated then
				onItemActivated(item.id)
			end

			if item.onActivated then
				item.onActivated()
			end
		end or nil

		if item.type == "image" then
			local createElement = React.createElement
			local v2

			if FFlagMeProfileEntryTooltipEnabled and item.toolTipConfig then
				v2 = ImageItemWithTooltip
			else
				v2 = ImageItem
			end

			local v3 = {
				thumbnailUrl = item.thumbnailUrl,
				isActive = isActive,
				onActivated = fn2,
				disabled = item.disabled,
				ref = item.ref,
				enableFocusAnimation = item.enableFocusAnimation,
				Visible = item.visible,
				LayoutOrder = props2.index,
				hideIndicator = item.hideIndicator,
				toolTipConfig = 0
			}
			local toolTipConfig

			if FFlagMeProfileEntryTooltipEnabled then
				toolTipConfig = item.toolTipConfig
			end

			v3.toolTipConfig = toolTipConfig
			return createElement(v2, v3)
		elseif item.type == "icon" then
			local createElement = React.createElement
			local v2 = {
				icon = item.icon,
				activeIcon = item.activeIcon,
				iconSize = item.iconSize,
				iconVariant = 0,
				activeIconVariant = 0,
				isActive = 0,
				animate = 0,
				onActivated = 0,
				disabled = 0,
				toolTipConfig = 0,
				ref = 0,
				Visible = 0,
				LayoutOrder = 0
			}
			local iconVariant

			if FFlagAXMigrateBuilderIcons then
				iconVariant = item.iconVariant
			end

			v2.iconVariant = iconVariant
			local activeIconVariant

			if FFlagAXMigrateBuilderIcons then
				activeIconVariant = item.activeIconVariant
			end

			v2.activeIconVariant = activeIconVariant
			v2.isActive = isActive
			v2.animate = not item.disableAnimation
			v2.onActivated = fn2
			v2.disabled = item.disabled
			local toolTipConfig

			if not (FFlagAXAddToolTipToIconItemMenu and props.activeItemId ~= "" and item.toolTipConfig) then
				toolTipConfig = item.toolTipConfig
			end

			v2.toolTipConfig = toolTipConfig

			v2.ref = item.ref
			v2.Visible = item.visible
			v2.LayoutOrder = props2.index
			return createElement(IconItem, v2)
		else
			if item.type == "color" then
				return React.createElement(ColorItem, {
					colors = item.colors,
					colorSize = item.colorSize,
					isActive = item.isActive,
					size = item.size,
					onActivated = fn2,
					disabled = item.disabled,
					ref = item.ref,
					Visible = item.visible,
					LayoutOrder = props2.index,
					Selectable = item.Selectable
				})
			end

			if FFlagAXResetAvatarButton and item.type == "divider" then
				return React.createElement(Foundation.Divider, {
					variant = item.variant,
					ref = item.ref,
					Visible = item.visible,
					LayoutOrder = props2.index
				})
			end

			return nil
		end
	end

	local v2

	if FFlagAXAddToolTipToIconItemMenu then
		v2 = props.activeItemId
	end

	local v3 = useCallback(fn, { v2 })

	local v4 = React.useMemo(function()
		local createElement = React.createElement
		local fillDirection

		if props.direction == "horizontal" then
			fillDirection = Enum.FillDirection.Horizontal
		else
			fillDirection = Enum.FillDirection.Vertical
		end

		local result = {
			IconOnlyMenuListLayout = createElement("UIListLayout", {
				FillDirection = fillDirection,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v.iconOnlyMenuItemGap)
			})
		}

		for k, item in props.items do
			local isActive

			if item.type ~= "divider" then
				if item.isActive == nil then
					isActive = item.id == props.activeItemId
				else
					isActive = item.isActive
				end
			end

			result[`MenuItem-{item.id}`] = v3({
				item = item,
				isActive = isActive,
				onItemActivated = props.onItemActivated,
				index = k
			})
		end

		return result
	end, { props.items, props.activeItemId, props.onItemActivated, props.direction, v3 })

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle padding-xsmall",
		backgroundStyle = v.menuBackgroundStyle,
		ref = ref,
		Visible = #props.items > 0,
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		Position = props.Position
	}, v4)
end

return React.memo(React.forwardRef(IconOnlyMenu))
