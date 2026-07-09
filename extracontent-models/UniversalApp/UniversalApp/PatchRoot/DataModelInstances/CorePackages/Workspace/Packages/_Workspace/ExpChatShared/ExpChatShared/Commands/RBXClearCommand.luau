local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Actions = ExpChatShared.Actions
local ChatWindowMessagesCleared = require(Actions.ChatWindowMessagesCleared)
local ExpChatSharedParent = ExpChatShared.Parent
local FFlagExpChatUseMessagesStore = require(ExpChatSharedParent.SharedFlags).FFlagExpChatUseMessagesStore

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/clear",
		"/cls"
	},
	clientRun = function(p1, _, _, p4) -- line: 14
		-- upvalues: FFlagExpChatUseMessagesStore (copy), ChatWindowMessagesCleared (copy)
		if FFlagExpChatUseMessagesStore then
			if not p4 or not p4.messagesStore then
				return {
					key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
					metadata = "Roblox.Clear.Error.ContextNotAvailable",
					args = {}
				}
			end

			p4.messagesStore.clearWindowMessages()
		else
			p1:dispatch(ChatWindowMessagesCleared())
		end

		return {
			key = "",
			metadata = "Roblox.Clear.Info.Success"
		}
	end
}
