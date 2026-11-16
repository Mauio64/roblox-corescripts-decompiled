local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function hasChildren(items): boolean
	if items == nil then
		return false
	end

	if typeof(items) ~= "table" then
		return true
	end

	for k, item in items do
		if item ~= nil then
			return true
		end
	end

	return false
end

local function SubagentStatus(props)
	local v5 = useTokens()
	local testId = props.testId or "subagent-status"
	local isDisabled = props.isDisabled == true
	local children = props.children
	local flag

	if children == nil then
		flag = false
	elseif typeof(children) == "table" then
		local flag2 = true

		for k, child in children do
			if child ~= nil then
				flag = true
				flag2 = false
				break
			end
		end

		if flag2 then
			flag = false
		end
	else
		flag = true
	end

	local background = v5.Color.ActionStandard.Background
	local foreground = v5.Color.ActionStandard.Foreground

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		backgroundStyle = background,
		cursor = {
			radius = UDim.new(0, v5.Radius.Circle),
			offset = v5.Size.Size_200,
			borderWidth = math.floor(v5.Stroke.Thicker)
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
	local v10 = {
		LayoutOrder = 1,
		Text = props.text,
		padding = 0,
		tag = "shrink size-0-full auto-x text-label-medium text-truncate-end",
		textStyle = 0,
		testId = 0
	}
	local v11 = { left = UDim.new(0, v5.Padding.Medium), right = 0 }
	local v12 = if not flag then UDim.new(0, v5.Padding.Medium) else nil
	v11.right = v12
	v10.padding = v11

	v10.textStyle = foreground
	v10.testId = `{testId}-text`
	local v8 = { Text = createElement2(text, v10), Trailing = 0 }

	local v13 = if flag then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "row align-x-center align-y-center auto-xy padding-left-small padding-right-medium",
			testId = `{testId}-trailing`
		},
		props.children
	) else nil
	v8.Trailing = v13
	return createElement(view, v7, v8)
end

return React.memo(SubagentStatus)
