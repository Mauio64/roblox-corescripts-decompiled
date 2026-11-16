local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function hasChildren(children): boolean -- 1 equivalent call inferred from this helper
	if children == nil then
		return false
	end

	if typeof(children) ~= "table" then
		return true
	end

	for _, item in children do
		if item ~= nil then
			return true
		end
	end

	return false
end

local function SubagentStatus(props)
	local v = useTokens()
	local testId = props.testId or "subagent-status"
	local isDisabled = props.isDisabled == true
	local children = hasChildren(props.children) -- inferred equivalent call
	local background = v.Color.ActionStandard.Background
	local foreground = v.Color.ActionStandard.Foreground

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		backgroundStyle = background,
		cursor = {
			radius = UDim.new(0, v.Radius.Circle),
			offset = v.Size.Size_200,
			borderWidth = math.floor(v.Stroke.Thicker)
		},
		GroupTransparency = isDisabled and 0.5 or 0,
		isDisabled = isDisabled,
		onActivated = props.onActivated,
		selection = {
			Selectable = not isDisabled
		},
		tag = "row align-x-center align-y-center size-0-800 auto-x radius-circle clip",
		testId = testId
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 1,
		Text = props.text,
		padding = 0,
		tag = "shrink size-0-full auto-x text-label-medium text-truncate-end",
		textStyle = 0,
		testId = 0
	}
	local padding = { left = UDim.new(0, v.Padding.Medium), right = 0 }
	local right

	if not children then
		right = UDim.new(0, v.Padding.Medium)
	end

	padding.right = right
	v4.padding = padding

	v4.textStyle = foreground
	v4.testId = `{testId}-text`
	local v3 = { Text = createElement2(Text, v4), Trailing = 0 }
	local trailing

	if children then
		trailing = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center auto-xy padding-left-small padding-right-medium",
				testId = `{testId}-trailing`
			},
			props.children
		)
	end

	v3.Trailing = trailing
	return createElement(View, v2, v3)
end

return React.memo(SubagentStatus)
