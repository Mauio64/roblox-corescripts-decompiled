local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local SduiText = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiText")
local useShimmerText = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useShimmerText")

local function SduiShimmerText(props)
	local v5 = useShimmerText({
		animationSpeed = props.animationSpeed,
		children = props.children,
		gradientOffset = props.gradientOffset,
		isShimmerEnabled = props.isShimmerEnabled,
		textStyle = props.textStyle
	})

	local v6 = React.useMemo(function()
		return Cryo.Dictionary.join(props, {
			animationSpeed = Cryo.None,
			children = Cryo.None,
			gradientOffset = Cryo.None,
			isShimmerEnabled = Cryo.None,
			textStyle = v5.textStyle
		})
	end, { props, v5.textStyle })

	return React.createElement(SduiText, v6, v5.children)
end

return SduiShimmerText
