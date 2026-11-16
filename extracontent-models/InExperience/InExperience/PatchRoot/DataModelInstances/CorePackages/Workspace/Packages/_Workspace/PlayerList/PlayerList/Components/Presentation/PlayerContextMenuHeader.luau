local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image

local PlayerVerifiedBadge = require(parent.Components.Presentation.PlayerVerifiedBadge)
local Constants = require(parent.Common.Constants)

local function PlayerContextMenuHeader(props)
	local header = props.header

	local v = {
		DisplayNameText = React.createElement(Text, {
			Text = header.displayName,
			tag = "shrink auto-xy text-title-medium text-wrap text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 1
		})
	}

	if props.player ~= nil then
		v.VerifiedBadge = React.createElement(PlayerVerifiedBadge, {
			player = props.player,
			layoutOrder = 2
		})
	end

	local v2 = {
		DisplayNameRow = React.createElement(
			View,
			{
				tag = "row align-x-left align-y-center gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1
			},
			v
		),
		Username = React.createElement(Text, {
			Text = header.username,
			tag = "size-full-0 auto-y text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default",
			LayoutOrder = 2
		})
	}

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-x-left align-y-center gap-medium size-full-1600 auto-y",
			selection = Constants.NOT_SELECTABLE
		},
		{
			Avatar = React.createElement(
				View,
				{
					tag = "size-1000-1000 radius-circle clip bg-shift-200",
					LayoutOrder = 1,
					testId = "player-context-menu-header-avatar"
				},
				{
					Image = React.createElement(Image, {
						Image = header.thumbnail or "",
						tag = "size-full radius-circle"
					})
				}
			),
			NameColumn = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col align-x-left fill auto-y"
			}, v2)
		}
	)
end

return React.memo(PlayerContextMenuHeader)
