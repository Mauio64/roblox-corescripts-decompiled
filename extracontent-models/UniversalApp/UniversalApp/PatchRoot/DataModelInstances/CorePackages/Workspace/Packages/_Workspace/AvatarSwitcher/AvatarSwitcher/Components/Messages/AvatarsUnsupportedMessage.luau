local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useLocalization = require(AvatarSwitcherParent.Localization).Hooks.useLocalization
local useSignalState = require(AvatarSwitcherParent.SignalsReact).useSignalState
local MessageCard = require(AvatarSwitcher.Components.Messages.MessageCard)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local FFlagAvatarSwitcherUiFixes = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherUiFixes

local function AvatarsUnsupportedMessage(t1: {[any]: any}) -- line: 21
	-- upvalues: useSignalState (copy), getAvatarSwitcherStore (copy), useLocalization (copy), FFlagAvatarSwitcherUiFixes (copy), ExperienceAvatarSupportType (copy), React (copy), Foundation (copy), MessageCard (copy)
	local v13 = useSignalState(getAvatarSwitcherStore)
	local v14 = useSignalState(v13.getExperienceAvatarSupportType)
	local v15 = useLocalization(if not FFlagAvatarSwitcherUiFixes then {
		messageHeader = "Feature.AvatarSwitcher.Heading.Unsupported",
		messageContent = "Feature.AvatarSwitcher.Message.Unsupported"
	} else {
		messageHeader = "Feature.AvatarSwitcher.Heading.PresetAvatars"
	})

	if v14 ~= ExperienceAvatarSupportType.NoSupport then
		return nil
	end

	return (React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		WarningMessage = React.createElement(MessageCard, {
			icon = "Info",
			headerText = v15.messageHeader,
			contentText = if not FFlagAvatarSwitcherUiFixes then v15.messageContent else nil,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	}))
end

return AvatarsUnsupportedMessage
