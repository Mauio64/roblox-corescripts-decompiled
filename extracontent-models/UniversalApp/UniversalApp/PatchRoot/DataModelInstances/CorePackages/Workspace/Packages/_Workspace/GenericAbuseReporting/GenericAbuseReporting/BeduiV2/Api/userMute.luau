local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local ExpChatShared = require(Parent.ExpChatShared)
local UserMuted = require(Parent.ExpChatShared).Actions.UserMuted
local FFlagExpChatUseMessagesStore = require(Parent.SharedFlags).FFlagExpChatUseMessagesStore

function muteUser(n1: number, p1) -- line: 11
	-- upvalues: ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy), UserMuted (copy)
	local context = ExpChatShared.context

	if not n1 or not p1 then
		return false
	end

	if n1 == p1.UserId then
		return false
	end

	if n1 and context.store then
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
function isUserMuted(n2: number) -- line: 36
	-- upvalues: ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy)
	local context = ExpChatShared.context

	if not n2 then
		return false
	end

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
