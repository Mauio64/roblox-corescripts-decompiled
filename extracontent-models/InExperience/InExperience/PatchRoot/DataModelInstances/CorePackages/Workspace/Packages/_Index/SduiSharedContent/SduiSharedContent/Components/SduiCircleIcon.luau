local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

require(Parent.SduiCompat)

local SduiView = require(script.Parent.SduiView)
local SduiIcon = require(script.Parent.SduiIcon)

local function SduiCircleIcon(t1: {[any]: any}) -- line: 33
	-- upvalues: useTokens (copy), React (copy), SduiView (copy), SduiIcon (copy)
	local v8 = useTokens()

	return React.createElement(SduiView, {
		tag = "radius-circle align-x-center align-y-center aspect-1-1",
		size = t1.size or UDim2.fromScale(1, 1),
		backgroundStyle = t1.backgroundStyle or v8.Color.Surface.Surface_100,
		layoutOrder = t1.layoutOrder,
		testId = t1.testId
	}, {
		Icon = if not t1.iconName then nil else React.createElement(SduiIcon, {
			name = t1.iconName,
			size = t1.iconSize,
			testId = if not t1.testId then nil else t1.testId .. "-icon"
		})
	})
end

return React.memo(SduiCircleIcon)
