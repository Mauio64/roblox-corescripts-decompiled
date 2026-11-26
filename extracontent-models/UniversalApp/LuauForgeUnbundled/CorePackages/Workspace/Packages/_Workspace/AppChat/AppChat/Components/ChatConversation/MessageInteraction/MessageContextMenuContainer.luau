require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local MessageContextMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/MessageContextMenu")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")

local v5 = { messageId = "", conversationId = "", inputBoxRef = nil }

function LUAUFORGE_MODULE_GLOBALS_hpr_MessageContextMenuContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local v6 = useGetConversationFromId(union.conversationId)

	local v7 = if v6 and v6.messages then v6.messages:Get(union.messageId) else nil

	local v8 = useLocalUserId()

	if not v7 then
		return nil
	end

	local v9 = v7.senderTargetId == v8

	return React.createElement(
		MessageContextMenu,
		Cryo.Dictionary.union(union, { message = v7, userOwnsMessage = v9 })
	)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hpr_MessageContextMenuContainer)
