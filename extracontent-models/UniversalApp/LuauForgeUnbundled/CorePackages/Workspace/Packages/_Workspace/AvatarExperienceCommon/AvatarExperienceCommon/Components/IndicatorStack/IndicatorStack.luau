local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local itemCardComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit").ItemCardComponents
local itemCardBadge = itemCardComponents.ItemCardBadge
local itemCardIndicatorStack = itemCardComponents.ItemCardIndicatorStack
local itemCardStatus = itemCardComponents.ItemCardStatus
local itemCardIcon = itemCardComponents.ItemCardIcon

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/shouldRenderIndicatorStack")

local function renderStatusContent(props)
	if props.type == "text" then
		return React.createElement(itemCardStatus, { text = props.text })
	end

	if props.type == "badge" then
		return React.createElement(itemCardBadge, {
			content = props.content,
			displayBorder = props.displayBorder
		})
	end

	return React.createElement(itemCardIcon, { icon = props.icon })
end

local function IndicatorStack(p2)
	local createElement = React.createElement
	local v7 = if p2.statusContent then renderStatusContent(p2.statusContent) else nil
	local v8 = if p2.itemTypeContent then React.createElement(itemCardBadge, {
		content = p2.itemTypeContent
	}) else nil
	return createElement(itemCardIndicatorStack, { statusSlot = v7, itemTypeSlot = v8 })
end

return IndicatorStack
