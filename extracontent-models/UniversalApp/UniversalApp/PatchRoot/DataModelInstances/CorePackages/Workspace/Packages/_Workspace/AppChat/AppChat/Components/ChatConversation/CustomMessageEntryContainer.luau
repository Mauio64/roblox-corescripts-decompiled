local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local EnumCustomEntryTypes = require(AppChat.Components.ChatConversation.EnumCustomEntryTypes)
local OsaContextCardOneToOneContainer = require(AppChat.Components.ChatConversation.ConversationCards.OsaContextCardOneToOneContainer)

local function CustomMessageEntryContainer(t1: {[any]: any}) -- line: 15
	-- upvalues: EnumCustomEntryTypes (copy), React (copy), OsaContextCardOneToOneContainer (copy)
	if t1.customEntryType == EnumCustomEntryTypes.OsaContextCardOneToOne then
		return (React.createElement(OsaContextCardOneToOneContainer, {
			conversationId = t1.conversationId,
			openViewProfile = t1.openViewProfile
		}))
	end

	return nil
end

return React.memo(CustomMessageEntryContainer)
