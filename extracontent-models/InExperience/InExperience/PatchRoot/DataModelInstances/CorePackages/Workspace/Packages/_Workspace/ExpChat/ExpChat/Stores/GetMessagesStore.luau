local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local createMessagesStore = require(script.createMessagesStore)

local FFlagExpChatUseChatMuteStore = require(ExpChat.Flags.FFlagExpChatUseChatMuteStore)

return Signals.createComputed(function()
	local getMutedGlobalUserIds

	if FFlagExpChatUseChatMuteStore then
		local GetGlobalMutedUsersStore = require(ExpChat.Stores.GetGlobalMutedUsersStore)
		getMutedGlobalUserIds = GetGlobalMutedUsersStore(false).getMutedGlobalUserIds
	end

	return createMessagesStore(getMutedGlobalUserIds)
end)
