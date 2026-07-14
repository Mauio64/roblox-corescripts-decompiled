local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local createMessagesStore = require(script.createMessagesStore)
local FFlagExpChatUseChatMuteStore = require(ExpChat.Flags.FFlagExpChatUseChatMuteStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: FFlagExpChatUseChatMuteStore (copy), ExpChat (copy), createMessagesStore (copy)
	local v6 = if not FFlagExpChatUseChatMuteStore then nil else require(ExpChat.Stores.GetGlobalMutedUsersStore)(false).getMutedGlobalUserIds

	return createMessagesStore(v6)
end)
