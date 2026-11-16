local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local PlayerBadgeGroup = require(parent.Components.Presentation.PlayerBadgeGroup)

local function PeopleCell(props)
	local textTag = props.textTag
		or props.truncate and "text-body-small text-align-x-left content-default text-truncate-end shrink auto-xy"
		or "auto-xy text-body-small text-align-x-left content-default"

	local v = {
		NameText = React.createElement(Text, {
			Text = props.displayName,
			tag = textTag,
			LayoutOrder = 1
		})
	}

	if props.player then
		v.Badge = React.createElement(PlayerBadgeGroup, { player = props.player, layoutOrder = 2 })
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-x-left align-y-center fill size-0-full clip gap-medium"
		},
		v
	)
end

return React.memo(PeopleCell)
