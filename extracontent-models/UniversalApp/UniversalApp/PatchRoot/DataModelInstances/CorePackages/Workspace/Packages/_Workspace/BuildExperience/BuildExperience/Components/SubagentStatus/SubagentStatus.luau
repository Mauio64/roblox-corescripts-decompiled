local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function hasChildren(p1) -- line: 26
	if p1 == nil then
		return false
	end

	if typeof(p1) ~= "table" then
		return true
	end

	for _, v11 in p1 do
		if v11 ~= nil then
			return true
		end
	end

	return false
end
local function SubagentStatus(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy)
	local v13 = useTokens()
	local v14 = t1.testId or "subagent-status"
	local v15 = t1.isDisabled == true
	local children = t1.children
	local v17, g20

	if children == nil then
		v17 = false
	elseif typeof(children) ~= "table" then
		v17 = true
	else
		g20 = nil
		v17 = nil

		for _, v19 in children do
			if v19 ~= nil then
				v17 = true
				g20 = true
			end

			if g20 then
				break
			end
		end

		if not g20 then
			v17 = false
		end
	end

	g20 = false

	local Background = v13.Color.ActionStandard.Background
	local Foreground = v13.Color.ActionStandard.Foreground

	return React.createElement(View, {
		tag = "row align-x-center align-y-center size-0-800 auto-x radius-circle clip",
		LayoutOrder = t1.layoutOrder,
		backgroundStyle = Background,
		cursor = {
			radius = UDim.new(0, v13.Radius.Circle),
			offset = v13.Size.Size_200,
			borderWidth = math.floor(v13.Stroke.Thicker)
		},
		GroupTransparency = not v15 and 0 or 0.5,
		isDisabled = v15,
		onActivated = t1.onActivated,
		selection = {
			Selectable = not v15
		},
		testId = v14
	}, {
		Text = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "shrink size-0-full auto-x text-label-medium text-truncate-end",
			Text = t1.text,
			padding = {
				left = UDim.new(0, v13.Padding.Medium),
				right = if not v17 then UDim.new(0, v13.Padding.Medium) else nil
			},
			textStyle = Foreground,
			testId = `{ v14 }-text`
		}),
		Trailing = if not v17 then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-center align-y-center auto-xy padding-left-small padding-right-medium",
			testId = `{ v14 }-trailing`
		}, t1.children)
	})
end

return React.memo(SubagentStatus)
