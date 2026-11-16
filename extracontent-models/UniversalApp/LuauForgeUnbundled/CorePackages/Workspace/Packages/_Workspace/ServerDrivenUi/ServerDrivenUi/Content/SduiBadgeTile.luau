local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")

local SduiTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTile")

local function SduiBadgeTile(props)
	local v5 = useTokens()
	local imageCornerRadius = props.imageCornerRadius or 1000
	local imagePadding = props.imagePadding or v5.Padding.Medium

	local v6 = props.isContained == nil or props.isContained

	local joined = Cryo.Dictionary.join(props, {
		testId = "--sdui-badge-tile",
		imagePadding = imagePadding,
		imageCornerRadius = imageCornerRadius,
		isContained = v6
	})

	return React.createElement(SduiTile, joined)
end

return React.memo(SduiBadgeTile)
