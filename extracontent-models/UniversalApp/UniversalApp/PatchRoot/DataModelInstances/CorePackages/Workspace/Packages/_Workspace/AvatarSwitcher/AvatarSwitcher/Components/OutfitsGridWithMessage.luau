local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local AvatarsUnsupportedMessage = require(AvatarSwitcher.Components.Messages.AvatarsUnsupportedMessage)
local PendingAvatarSwitchMessage = require(AvatarSwitcher.Components.Messages.PendingAvatarSwitchMessage)
local OutfitsGridContainer = require(AvatarSwitcher.Components.OutfitsGrid.OutfitsGridContainer)

local function OutfitsGridWithMessage() -- line: 17
	-- upvalues: React (copy), Foundation (copy), AvatarsUnsupportedMessage (copy), PendingAvatarSwitchMessage (copy), OutfitsGridContainer (copy)
	return (React.createElement(Foundation.View, {
		tag = "size-full-full col gap-large"
	}, {
		AvatarsUnsupportedMessage = React.createElement(AvatarsUnsupportedMessage, {
			LayoutOrder = 1
		}),
		PendingAvatarSwitchMessage = React.createElement(PendingAvatarSwitchMessage, {
			LayoutOrder = 2
		}),
		GridContainer = React.createElement(Foundation.View, {
			tag = "size-full-0 grow",
			LayoutOrder = 3
		}, {
			OutfitsGridContainer = React.createElement(OutfitsGridContainer)
		})
	}))
end

return OutfitsGridWithMessage
