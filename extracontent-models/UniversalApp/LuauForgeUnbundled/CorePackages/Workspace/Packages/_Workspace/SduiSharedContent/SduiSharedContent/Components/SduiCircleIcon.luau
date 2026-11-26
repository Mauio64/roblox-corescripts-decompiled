local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation").Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local SduiView = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiView")
local SduiIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiIcon")

local function SduiCircleIcon(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		tag = "radius-circle align-x-center align-y-center aspect-1-1",
		size = props.size or UDim2.fromScale(1, 1),
		backgroundStyle = props.backgroundStyle or v5.Color.Surface.Surface_100,
		layoutOrder = props.layoutOrder,
		testId = props.testId
	}
	local v9

	if props.iconName then
		local createElement2 = React.createElement
		local v11 = { name = props.iconName, size = props.iconSize, testId = 0 }
		local v12 = if props.testId then props.testId .. "-icon" else nil
		v11.testId = v12
		v9 = createElement2(SduiIcon, v11)
	end

	return createElement(SduiView, v7, { Icon = v9 })
end

return React.memo(SduiCircleIcon)
