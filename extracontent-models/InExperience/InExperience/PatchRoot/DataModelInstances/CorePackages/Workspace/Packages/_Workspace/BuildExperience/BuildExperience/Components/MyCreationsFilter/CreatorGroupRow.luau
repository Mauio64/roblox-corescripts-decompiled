local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useAssetFetchStatus = RoactUtils.Hooks.useAssetFetchStatus

local Icon = Foundation.Icon
local List = Foundation.List

local useTokens = Foundation.Hooks.useTokens

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ListItemInputType = Foundation.Enums.ListItemInputType

local function CreatorGroupRow(props)
	local v = useTokens()
	local v2 = useAssetFetchStatus(props.icon)
	local trailing

	if props.isSelected then
		trailing = React.createElement(Icon, {
			name = IconName.CheckLarge,
			size = IconSize.Medium,
			style = v.Color.Content.Emphasis
		})
	end

	local iconName

	if v2 == Enum.AssetFetchStatus.Loading then
		iconName = IconName.Clock
	elseif v2 == Enum.AssetFetchStatus.Failure or v2 == Enum.AssetFetchStatus.TimedOut then
		iconName = IconName.ImageCircleSlash
	else
		iconName = props.icon
	end

	return React.createElement(List.Item, {
		LayoutOrder = props.LayoutOrder,
		leading = { iconName = iconName },
		title = props.name,
		trailing = trailing,
		onActivated = props.onActivated,
		input = ListItemInputType.None,
		testId = props.testId
	})
end

return CreatorGroupRow
