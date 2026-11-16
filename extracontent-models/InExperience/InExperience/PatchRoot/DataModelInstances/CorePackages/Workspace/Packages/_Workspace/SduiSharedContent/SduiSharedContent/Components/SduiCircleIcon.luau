local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
require(parent.SduiCompat)

local SduiView = require(script.Parent.SduiView)
local SduiIcon = require(script.Parent.SduiIcon)

local function SduiCircleIcon(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		tag = "radius-circle align-x-center align-y-center aspect-1-1",
		size = props.size or UDim2.fromScale(1, 1),
		backgroundStyle = props.backgroundStyle or v.Color.Surface.Surface_100,
		layoutOrder = props.layoutOrder,
		testId = props.testId
	}
	local icon

	if props.iconName then
		local createElement2 = React.createElement
		local v3 = { name = props.iconName, size = props.iconSize, testId = 0 }
		local testId

		if props.testId then
			testId = props.testId .. "-icon"
		end

		v3.testId = testId
		icon = createElement2(SduiIcon, v3)
	end

	return createElement(SduiView, v2, { Icon = icon })
end

return React.memo(SduiCircleIcon)
