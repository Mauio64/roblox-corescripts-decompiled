local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")
local IconItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Items/IconItem")
local ImageItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Items/ImageItem")
local ImageItemWithTooltip = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Items/ImageItemWithTooltip")
local ColorItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Items/ColorItem")
local fFlagAXAddToolTipToIconItemMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXAddToolTipToIconItemMenu
local fFlagAXMigrateBuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXMigrateBuilderIcons
local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXResetAvatarButton
local fFlagMeProfileEntryTooltipEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagMeProfileEntryTooltipEnabled

local function IconOnlyMenu(props, p2)
	local v5 = useSemanticTokens()

	local function fn(props2)
		local item = props2.item
		local isActive = props2.isActive
		local onItemActivated = props2.onItemActivated

		local fn2 = (not fFlagAXResetAvatarButton or item.type ~= "divider") and function()
			if onItemActivated then
				onItemActivated(item.id)
			end

			if item.onActivated then
				item.onActivated()
			end
		end or nil

		if item.type == "image" then
			local createElement = React.createElement
			local v6 = if fFlagMeProfileEntryTooltipEnabled and item.toolTipConfig then ImageItemWithTooltip else ImageItem
			local v7 = {
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
			local v8 = if fFlagMeProfileEntryTooltipEnabled then item.toolTipConfig else nil
			v7.toolTipConfig = v8
			return createElement(v6, v7)
		elseif item.type == "icon" then
			local createElement = React.createElement
			local v7 = {
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
			local v8 = if fFlagAXMigrateBuilderIcons then item.iconVariant else nil
			v7.iconVariant = v8
			local v9 = if fFlagAXMigrateBuilderIcons then item.activeIconVariant else nil
			v7.activeIconVariant = v9
			v7.isActive = isActive
			v7.animate = not item.disableAnimation
			v7.onActivated = fn2
			v7.disabled = item.disabled

			local v10 = if not fFlagAXAddToolTipToIconItemMenu or props.activeItemId == "" or not item.toolTipConfig then item.toolTipConfig else nil
			v7.toolTipConfig = v10

			v7.ref = item.ref
			v7.Visible = item.visible
			v7.LayoutOrder = props2.index
			return createElement(IconItem, v7)
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

			if fFlagAXResetAvatarButton and item.type == "divider" then
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

	local v8 = React.useCallback(fn, {
		if fFlagAXAddToolTipToIconItemMenu then props.activeItemId else nil
	})

	local v9 = React.useMemo(function()
		local createElement = React.createElement
		local v12 = if props.direction == "horizontal" then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical
		local result = {
			IconOnlyMenuListLayout = createElement("UIListLayout", {
				FillDirection = v12,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v5.iconOnlyMenuItemGap)
			})
		}

		for k, item in props.items do
			local v13

			if item.type ~= "divider" then
				v13 = if item.isActive == nil then item.id == props.activeItemId else item.isActive
			end

			result[`MenuItem-{item.id}`] = v8({
				item = item,
				isActive = v13,
				onItemActivated = props.onItemActivated,
				index = k
			})
		end

		return result
	end, { props.items, props.activeItemId, props.onItemActivated, props.direction, v8 })

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle padding-xsmall",
		backgroundStyle = v5.menuBackgroundStyle,
		ref = p2,
		Visible = #props.items > 0,
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		Position = props.Position
	}, v9)
end

return React.memo(React.forwardRef(IconOnlyMenu))
