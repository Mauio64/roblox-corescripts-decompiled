local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local View = Foundation.View
local Text = Foundation.Text
local AvatarGroup = Foundation.AvatarGroup
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens

local function AccessoryComponent(props)
	local layoutOrder = props.LayoutOrder

	if props.accessory.type == "AvatarGroup" then
		local accessory = props.accessory
		return React.createElement(AvatarGroup, {
			LayoutOrder = layoutOrder,
			avatars = accessory.avatars,
			type = accessory.groupType,
			max = accessory.max,
			backplateStyle = props.accessory.backplateStyle,
			size = accessory.size,
			testId = `{props.testIdPrefix}--{props.position}-avatar-group`
		})
	end

	if props.accessory.type ~= "Icon" then
		return nil
	end

	local accessory = props.accessory
	return React.createElement(Icon, {
		LayoutOrder = layoutOrder,
		name = accessory.name,
		variant = accessory.variant,
		size = accessory.size,
		style = accessory.style,
		testId = `{props.testIdPrefix}--{props.position}-icon`
	})
end

local memo = React.memo(AccessoryComponent)

local function SduiTextAccessoryRow(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local size = props.size
	local position = props.position

	local v = useTokens()

	local textStyle = props.textStyle or v.Color.Content.Emphasis
	local v2 = not props.fontStyle and "text-caption-large" or nil

	local layoutOrder2 = props.leading and 2 or 1
	local layoutOrder3 = props.leading and 3 or 2

	local testId = props.testId or "--sdui-text-accessory-row"

	local tag = React.useMemo(function()
		return {
			["row align-y-center auto-xy"] = true,
			["gap-small"] = not props.gap
		}
	end, { props.gap })

	local createElement = React.createElement
	local v3 = {
		tag = tag,
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Size = size,
		Position = position,
		onActivated = props.onActivated,
		testId = testId,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}
	local listLayout

	if props.gap then
		listLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, props.gap)
		})
	end

	local leadingAccessory

	if props.leading then
		leadingAccessory = React.createElement(memo, {
			accessory = props.leading,
			LayoutOrder = 1,
			testIdPrefix = testId,
			position = "leading"
		})
	end

	local textElement

	if props.text then
		textElement = React.createElement(Text, {
			Text = props.text,
			textStyle = textStyle,
			fontStyle = props.fontStyle,
			tag = `auto-xy {v2 or ""}`,
			LayoutOrder = layoutOrder2,
			testId = `{testId}--text`,
			RichText = true
		})
	end

	local trailingAccessory

	if props.trailing then
		trailingAccessory = React.createElement(memo, {
			accessory = props.trailing,
			LayoutOrder = layoutOrder3,
			testIdPrefix = testId,
			position = "trailing"
		})
	end

	return createElement(View, v3, {
		ListLayout = listLayout,
		LeadingAccessory = leadingAccessory,
		TextElement = textElement,
		TrailingAccessory = trailingAccessory
	})
end

return React.memo(SduiTextAccessoryRow)
