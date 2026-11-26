local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local view = Foundation.View
local text = Foundation.Text
local avatarGroup = Foundation.AvatarGroup
local icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens

local function AccessoryComponent(props)
	local layoutOrder = props.LayoutOrder

	if props.accessory.type == "AvatarGroup" then
		local accessory = props.accessory
		return React.createElement(avatarGroup, {
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
	return React.createElement(icon, {
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

	local v5 = useTokens()

	local textStyle = props.textStyle or v5.Color.Content.Emphasis
	local v6 = not props.fontStyle and "text-caption-large" or nil

	local v7 = props.leading and 2 or 1
	local v8 = props.leading and 3 or 2

	local testId = props.testId or "--sdui-text-accessory-row"

	local v9 = React.useMemo(function()
		return {
			["row align-y-center auto-xy"] = true,
			["gap-small"] = not props.gap
		}
	end, { props.gap })

	local createElement = React.createElement
	local v11 = {
		tag = v9,
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Size = size,
		Position = position,
		onActivated = props.onActivated,
		testId = testId,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}

	local v13 = if props.gap then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, props.gap)
	}) else nil

	local v14 = if props.leading then React.createElement(memo, {
		accessory = props.leading,
		LayoutOrder = 1,
		testIdPrefix = testId,
		position = "leading"
	}) else nil

	local v15 = if props.text then React.createElement(text, {
		Text = props.text,
		textStyle = textStyle,
		fontStyle = props.fontStyle,
		tag = `auto-xy {v6 or ""}`,
		LayoutOrder = v7,
		testId = `{testId}--text`,
		RichText = true
	}) else nil

	local v16 = if props.trailing then React.createElement(memo, {
		accessory = props.trailing,
		LayoutOrder = v8,
		testIdPrefix = testId,
		position = "trailing"
	}) else nil
	return createElement(view, v11, {
		ListLayout = v13,
		LeadingAccessory = v14,
		TextElement = v15,
		TrailingAccessory = v16
	})
end

return React.memo(SduiTextAccessoryRow)
