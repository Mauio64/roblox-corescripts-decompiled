local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
require(parent.SduiCompat)

local SduiText = require(script.Parent.SduiText)
local useShimmerText = require(script.Parent.useShimmerText)

local function SduiShimmerText(props)
	local v = useShimmerText({
		animationSpeed = props.animationSpeed,
		children = props.children,
		gradientOffset = props.gradientOffset,
		isShimmerEnabled = props.isShimmerEnabled,
		textStyle = props.textStyle
	})

	local v2 = React.useMemo(function()
		return Cryo.Dictionary.join(props, {
			animationSpeed = Cryo.None,
			children = Cryo.None,
			gradientOffset = Cryo.None,
			isShimmerEnabled = Cryo.None,
			textStyle = v.textStyle
		})
	end, { props, v.textStyle })

	return React.createElement(SduiText, v2, v.children)
end

return SduiShimmerText
