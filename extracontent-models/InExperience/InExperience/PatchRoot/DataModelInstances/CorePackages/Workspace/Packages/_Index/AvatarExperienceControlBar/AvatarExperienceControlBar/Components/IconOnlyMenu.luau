local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)

require(AvatarExperienceControlBar.ControlBarTypes)

local IconItem = require(AvatarExperienceControlBar.Components.Items.IconItem)
local ImageItem = require(AvatarExperienceControlBar.Components.Items.ImageItem)
local ColorItem = require(AvatarExperienceControlBar.Components.Items.ColorItem)
local FFlagAXAddToolTipToIconItemMenu = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXAddToolTipToIconItemMenu
local FFlagAXMigrateBuilderIcons = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXMigrateBuilderIcons
local FFlagAXResetAvatarButton = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXResetAvatarButton

local function IconOnlyMenu(t1: {[any]: any}, p1) -- line: 27
	-- upvalues: useSemanticTokens (copy), React (copy), FFlagAXResetAvatarButton (copy), ImageItem (copy), IconItem (copy), FFlagAXMigrateBuilderIcons (copy), FFlagAXAddToolTipToIconItemMenu (copy), ColorItem (copy), Foundation (copy)
	local v15 = useSemanticTokens()
	local v16 = React.useCallback(function(t2: {[any]: any}) -- line: 30
		-- upvalues: FFlagAXResetAvatarButton (copy), React (copy), ImageItem (copy), IconItem (copy), FFlagAXMigrateBuilderIcons (copy), FFlagAXAddToolTipToIconItemMenu (copy), t1 (copy), ColorItem (copy), Foundation (copy)
		local item = t2.item
		local isActive = t2.isActive
		local onItemActivated = t2.onItemActivated
		local v22 = (not FFlagAXResetAvatarButton or item.type ~= "divider") and function() -- line: 43
			-- upvalues: onItemActivated (copy), item (copy)
			if onItemActivated then
				onItemActivated(item.id)
			end

			if item.onActivated then
				item.onActivated()
			end
		end or nil

		if item.type == "image" then
			return React.createElement(ImageItem, {
				thumbnailUrl = item.thumbnailUrl,
				isActive = isActive,
				onActivated = v22,
				disabled = item.disabled,
				ref = item.ref,
				enableFocusAnimation = item.enableFocusAnimation,
				Visible = item.visible,
				LayoutOrder = t2.index,
				hideIndicator = item.hideIndicator
			})
		end

		if item.type == "icon" then
			return React.createElement(IconItem, {
				icon = item.icon,
				activeIcon = item.activeIcon,
				iconSize = item.iconSize,
				iconVariant = if not FFlagAXMigrateBuilderIcons then nil else item.iconVariant,
				activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else item.activeIconVariant,
				isActive = isActive,
				animate = not item.disableAnimation,
				onActivated = v22,
				disabled = item.disabled,
				toolTipConfig = if not FFlagAXAddToolTipToIconItemMenu or (t1.activeItemId == "" or not item.toolTipConfig) then item.toolTipConfig else nil,
				ref = item.ref,
				Visible = item.visible,
				LayoutOrder = t2.index
			})
		end

		if item.type == "color" then
			return React.createElement(ColorItem, {
				colors = item.colors,
				colorSize = item.colorSize,
				isActive = item.isActive,
				size = item.size,
				onActivated = v22,
				disabled = item.disabled,
				ref = item.ref,
				Visible = item.visible,
				LayoutOrder = t2.index,
				Selectable = item.Selectable
			})
		end

		if FFlagAXResetAvatarButton and item.type == "divider" then
			return React.createElement(Foundation.Divider, {
				variant = item.variant,
				ref = item.ref,
				Visible = item.visible,
				LayoutOrder = t2.index
			})
		end

		return nil
	end, { if not FFlagAXAddToolTipToIconItemMenu then nil else t1.activeItemId })
	local v17 = React.useMemo(function() -- line: 110
		-- upvalues: React (copy), t1 (copy), v15 (copy), v16 (copy)
		local t3 = {
			IconOnlyMenuListLayout = React.createElement("UIListLayout", {
				FillDirection = if t1.direction ~= "horizontal" then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v15.iconOnlyMenuItemGap)
			})
		}

		for v24, v25 in t1.items do
			local v26 = if v25.type ~= "divider" then if v25.isActive == nil then v25.id == t1.activeItemId else v25.isActive else nil

			t3[`MenuItem-{ v25.id }`] = v16({
				item = v25,
				isActive = v26,
				onItemActivated = t1.onItemActivated,
				index = v24
			})
		end

		return t3
	end, {
		t1.items,
		t1.activeItemId,
		t1.onItemActivated,
		t1.direction,
		v16
	})

	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle padding-xsmall",
		backgroundStyle = v15.menuBackgroundStyle,
		ref = p1,
		Visible = #t1.items > 0,
		LayoutOrder = t1.LayoutOrder,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		Position = t1.Position
	}, v17)
end

return React.memo(React.forwardRef(IconOnlyMenu))
