local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local View = Foundation.View
local FoundationText = Foundation.Text
local AvatarGroup = Foundation.AvatarGroup
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens

local function AccessoryComponent(t1: {[any]: any}) -- line: 65
	-- upvalues: React (copy), AvatarGroup (copy), Icon (copy)
	local t1LayoutOrder = t1.LayoutOrder

	if t1.accessory.type == "AvatarGroup" then
		local accessory = t1.accessory

		return React.createElement(AvatarGroup, {
			LayoutOrder = t1LayoutOrder,
			avatars = accessory.avatars,
			type = accessory.groupType,
			max = accessory.max,
			backplateStyle = t1.accessory.backplateStyle,
			size = accessory.size,
			testId = `{ t1.testIdPrefix }--{ t1.position }-avatar-group`
		})
	end

	if t1.accessory.type == "Icon" then
		local accessory = t1.accessory

		return React.createElement(Icon, {
			LayoutOrder = t1LayoutOrder,
			name = accessory.name,
			variant = accessory.variant,
			size = accessory.size,
			style = accessory.style,
			testId = `{ t1.testIdPrefix }--{ t1.position }-icon`
		})
	end

	return nil
end

local v10 = React.memo(AccessoryComponent)

local function SduiTextAccessoryRow(t2: {[any]: any}) -- line: 96
	-- upvalues: useTokens (copy), React (copy), View (copy), Foundation (copy), v10 (copy), FoundationText (copy)
	local layoutOrder = t2.layoutOrder
	local anchorPoint = t2.anchorPoint
	local size = t2.size
	local position = t2.position
	local v21 = useTokens()
	local v22 = t2.textStyle or v21.Color.Content.Emphasis
	local v23 = not t2.fontStyle and "text-caption-large" or nil
	local v24 = not t2.leading and 1 or 2
	local v25 = not t2.leading and 2 or 3
	local v26 = t2.testId or "--sdui-text-accessory-row"
	local v27 = React.useMemo(function() -- line: 114
		-- upvalues: t2 (copy)
		return {
			["row align-y-center auto-xy"] = true,
			["gap-small"] = not t2.gap
		}
	end, { t2.gap })

	return React.createElement(View, {
		tag = v27,
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Size = size,
		Position = position,
		onActivated = t2.onActivated,
		testId = v26,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		}
	}, {
		ListLayout = if not t2.gap then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, t2.gap)
		}),
		LeadingAccessory = if not t2.leading then nil else React.createElement(v10, {
			LayoutOrder = 1,
			position = "leading",
			accessory = t2.leading,
			testIdPrefix = v26
		}),
		TextElement = if not t2.text then nil else React.createElement(FoundationText, {
			RichText = true,
			Text = t2.text,
			textStyle = v22,
			fontStyle = t2.fontStyle,
			tag = `auto-xy { v23 or "" }`,
			LayoutOrder = v24,
			testId = `{ v26 }--text`
		}),
		TrailingAccessory = if not t2.trailing then nil else React.createElement(v10, {
			position = "trailing",
			accessory = t2.trailing,
			LayoutOrder = v25,
			testIdPrefix = v26
		})
	})
end

return React.memo(SduiTextAccessoryRow)
