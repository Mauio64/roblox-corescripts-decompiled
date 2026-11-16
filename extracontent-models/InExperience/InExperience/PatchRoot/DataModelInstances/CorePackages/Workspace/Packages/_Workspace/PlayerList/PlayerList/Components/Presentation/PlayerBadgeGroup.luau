local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local View = Foundation.View

local PlayerBadge = require(parent.Components.Presentation.PlayerBadge)
local PlayerVerifiedBadge = require(parent.Components.Presentation.PlayerVerifiedBadge)

local function PlayerBadgeGroup(p)
	return React.createElement(View, {
		tag = "row align-y-center gap-xsmall auto-xy",
		LayoutOrder = p.layoutOrder
	}, {
		Badge = React.createElement(PlayerBadge, { player = p.player, layoutOrder = 1 }),
		VerifiedBadge = React.createElement(PlayerVerifiedBadge, {
			player = p.player,
			layoutOrder = 2
		})
	})
end

return React.memo(PlayerBadgeGroup)
