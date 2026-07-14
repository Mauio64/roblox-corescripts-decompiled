local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local ChatMute = require(Parent.ChatMute)
local ExpChatShared = require(Parent.ExpChatShared)
local UserMuted = require(Parent.ExpChatShared).Actions.UserMuted
local SharedFlags = require(Parent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore

function muteUser(n1: number, p1) -- line: 14
	-- upvalues: FFlagExpChatUseChatMuteStore (copy), ChatMute (copy), ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy), UserMuted (copy)
	if not n1 or not p1 then
		return false
	end

	if n1 == p1.UserId then
		return false
	end

	if FFlagExpChatUseChatMuteStore then
		ChatMute.mutePlayer({
			userId = tostring(n1)
		})

		return true
	end

	local context = ExpChatShared.context

	if context.store then
		if FFlagExpChatUseMessagesStore then
			if context.messagesStore then
				context.messagesStore.muteUser(n1)

				return true
			end

			return false
		end

		context.store:dispatch(UserMuted(n1))

		return true
	end

	return false
end
function isUserMuted(n2: number) -- line: 44
	-- upvalues: FFlagExpChatUseChatMuteStore (copy), ChatMute (copy), ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy)
	if not n2 then
		return false
	end

	if FFlagExpChatUseChatMuteStore then
		return ChatMute.isUserIdMuted((tostring(n2)))
	end

	local context = ExpChatShared.context

	if context.store then
		if FFlagExpChatUseMessagesStore then
			if context.messagesStore then
				return context.messagesStore.getMutedUserIds(false)[tostring(n2)] == true
			end

			return false
		end

		return context.store:getState().MutedUsers[tostring(n2)] == true
	end

	return false
end

return {
	isUserMuted = isUserMuted,
	muteUser = muteUser
}
