local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent
local React = require(parent.React)

local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardComponents = AvatarExperienceUIKit.ItemCardComponents
local ItemCardBadge = ItemCardComponents.ItemCardBadge
local ItemCardIndicatorStack = ItemCardComponents.ItemCardIndicatorStack
local ItemCardStatus = ItemCardComponents.ItemCardStatus
local ItemCardIcon = ItemCardComponents.ItemCardIcon

require(AvatarExperienceCommon.Utils.shouldRenderIndicatorStack)

local function renderStatusContent(props)
	if props.type == "text" then
		return React.createElement(ItemCardStatus, { text = props.text })
	end

	if props.type == "badge" then
		return React.createElement(ItemCardBadge, {
			content = props.content,
			displayBorder = props.displayBorder
		})
	end

	return React.createElement(ItemCardIcon, { icon = props.icon })
end

local function IndicatorStack(p)
	local createElement = React.createElement
	local statusSlot

	if p.statusContent then
		statusSlot = renderStatusContent(p.statusContent)
	end

	local itemTypeSlot

	if p.itemTypeContent then
		itemTypeSlot = React.createElement(ItemCardBadge, { content = p.itemTypeContent })
	end

	return createElement(ItemCardIndicatorStack, {
		statusSlot = statusSlot,
		itemTypeSlot = itemTypeSlot
	})
end

return IndicatorStack
