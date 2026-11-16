local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local MessageCard = require(AvatarSwitcher.Components.Messages.MessageCard)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)

local function PendingAvatarSwitchMessage(p)
	local v = useSignalState(getAvatarSwitcherStore)
	local avatarName = useSignalState(v.getPendingAvatarName)

	local v2 = useLocalization({
		messageHeader = {
			"Feature.AvatarSwitcher.Heading.AvatarSwitchedConfirmation",
			avatarName = avatarName
		},
		messageContent = "Feature.AvatarSwitcher.Message.SwitchingDeferred"
	})

	if avatarName == nil then
		return nil
	end

	return (React.createElement(Foundation.View, { tag = "size-full-0 auto-y" }, {
		WarningMessage = React.createElement(MessageCard, {
			icon = "Info",
			headerText = v2.messageHeader,
			contentText = v2.messageContent,
			onClose = v.clearPendingAvatarName,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p.LayoutOrder
		})
	}))
end

return PendingAvatarSwitchMessage
