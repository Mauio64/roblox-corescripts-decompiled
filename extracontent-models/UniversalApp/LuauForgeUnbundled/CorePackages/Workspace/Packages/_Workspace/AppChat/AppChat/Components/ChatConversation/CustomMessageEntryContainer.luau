local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local EnumCustomEntryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumCustomEntryTypes")

local OsaContextCardOneToOneContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationCards/OsaContextCardOneToOneContainer")

local function CustomMessageEntryContainer(props)
	if props.customEntryType == EnumCustomEntryTypes.OsaContextCardOneToOne then
		return React.createElement(OsaContextCardOneToOneContainer, {
			conversationId = props.conversationId,
			openViewProfile = props.openViewProfile
		})
	end

	return nil
end

return React.memo(CustomMessageEntryContainer)
