local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useLocalization = require(AvatarSwitcherParent.Localization).Hooks.useLocalization
local useSignalState = require(AvatarSwitcherParent.SignalsReact).useSignalState
local MessageCard = require(AvatarSwitcher.Components.Messages.MessageCard)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)

local function PendingAvatarSwitchMessage(t1: {[any]: any}) -- line: 18
	-- upvalues: useSignalState (copy), getAvatarSwitcherStore (copy), useLocalization (copy), React (copy), Foundation (copy), MessageCard (copy)
	local v11 = useSignalState(getAvatarSwitcherStore)
	local v12 = useSignalState(v11.getPendingAvatarName)
	local v13 = useLocalization({
		messageContent = "Feature.AvatarSwitcher.Message.SwitchingDeferred",
		messageHeader = {
			"Feature.AvatarSwitcher.Heading.AvatarSwitchedConfirmation",
			avatarName = v12
		}
	})

	if v12 == nil then
		return nil
	end

	return (React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y"
	}, {
		WarningMessage = React.createElement(MessageCard, {
			icon = "Info",
			headerText = v13.messageHeader,
			contentText = v13.messageContent,
			onClose = v11.clearPendingAvatarName,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = t1.LayoutOrder
		})
	}))
end

return PendingAvatarSwitchMessage
