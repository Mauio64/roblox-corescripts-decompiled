local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local EnumCustomEntryTypes = require(AppChat.Components.ChatConversation.EnumCustomEntryTypes)

local OsaContextCardOneToOneContainer = require(AppChat.Components.ChatConversation.ConversationCards.OsaContextCardOneToOneContainer)

local function CustomMessageEntryContainer(props)
	if props.customEntryType == EnumCustomEntryTypes.OsaContextCardOneToOne then
		return (React.createElement(OsaContextCardOneToOneContainer, {
			conversationId = props.conversationId,
			openViewProfile = props.openViewProfile
		}))
	end

	return nil
end

return React.memo(CustomMessageEntryContainer)
