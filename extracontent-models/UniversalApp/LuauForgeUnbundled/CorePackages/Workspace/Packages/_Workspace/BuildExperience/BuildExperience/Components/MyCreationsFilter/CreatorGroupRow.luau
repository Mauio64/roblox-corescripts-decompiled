local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useAssetFetchStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.useAssetFetchStatus

local icon = Foundation.Icon
local list = Foundation.List

local useTokens = Foundation.Hooks.useTokens

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local listItemInputType = Foundation.Enums.ListItemInputType

local function CreatorGroupRow(props)
	local v5 = useTokens()
	local v6 = useAssetFetchStatus(props.icon)
	local v7

	if props.isSelected then
		v7 = React.createElement(icon, {
			name = iconName.CheckLarge,
			size = iconSize.Medium,
			style = v5.Color.Content.Emphasis
		})
	end

	local v8

	if v6 == Enum.AssetFetchStatus.Loading then
		v8 = iconName.Clock
	elseif v6 == Enum.AssetFetchStatus.Failure or v6 == Enum.AssetFetchStatus.TimedOut then
		v8 = iconName.ImageCircleSlash
	else
		v8 = props.icon
	end

	return React.createElement(list.Item, {
		LayoutOrder = props.LayoutOrder,
		leading = { iconName = v8 },
		title = props.name,
		trailing = v7,
		onActivated = props.onActivated,
		input = listItemInputType.None,
		testId = props.testId
	})
end

return CreatorGroupRow
