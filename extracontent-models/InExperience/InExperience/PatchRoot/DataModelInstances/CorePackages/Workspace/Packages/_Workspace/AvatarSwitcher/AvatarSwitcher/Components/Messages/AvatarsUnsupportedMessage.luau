local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local MessageCard = require(AvatarSwitcher.Components.Messages.MessageCard)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherUiFixes = AvatarExperienceFlags.FFlagAvatarSwitcherUiFixes

local function AvatarsUnsupportedMessage(p)
	local v = useSignalState(useSignalState(getAvatarSwitcherStore).getExperienceAvatarSupportType)

	local v2 = useLocalization(FFlagAvatarSwitcherUiFixes and {
		messageHeader = "Feature.AvatarSwitcher.Heading.PresetAvatars"
	} or {
		messageHeader = "Feature.AvatarSwitcher.Heading.Unsupported",
		messageContent = "Feature.AvatarSwitcher.Message.Unsupported"
	})

	if v ~= ExperienceAvatarSupportType.NoSupport then
		return nil
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = { tag = "size-full-0 auto-y", LayoutOrder = p.LayoutOrder }

	local createElement2 = React.createElement
	local v4 = {
		icon = "Info",
		headerText = v2.messageHeader,
		contentText = 0,
		Size = 0,
		AutomaticSize = 0
	}
	local contentText

	if not FFlagAvatarSwitcherUiFixes then
		contentText = v2.messageContent
	end

	v4.contentText = contentText
	v4.Size = UDim2.new(1, 0, 0, 0)
	v4.AutomaticSize = Enum.AutomaticSize.Y
	return (createElement(view, v3, {
		WarningMessage = createElement2(MessageCard, v4)
	}))
end

return AvatarsUnsupportedMessage
