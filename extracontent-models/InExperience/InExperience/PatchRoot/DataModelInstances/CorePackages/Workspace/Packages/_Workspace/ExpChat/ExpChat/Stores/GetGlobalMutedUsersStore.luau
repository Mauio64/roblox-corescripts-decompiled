local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)

if require(ExpChat.Flags.FFlagExpChatUseChatMuteStore) then
	local ChatMute = require(ExpChatParent.ChatMute)

	return Signals.createComputed(function() -- line: 11
		-- upvalues: ChatMute (copy)
		return {
			getMutedGlobalUsernames = ChatMute.getMutedUsernames(),
			getMutedGlobalDisplayNames = ChatMute.getMutedDisplayNames(),
			getMutedGlobalUserIds = ChatMute.getMutedUserIds(),
			muteGlobalUsername = function(s1: string) -- line: 16
				-- upvalues: ChatMute (copy)
				ChatMute.mutePlayer({
					username = s1
				})
			end,
			unmuteGlobalUsername = function(s2: string) -- line: 19
				-- upvalues: ChatMute (copy)
				ChatMute.unmutePlayer({
					username = s2
				})
			end,
			muteGlobalDisplayName = function(s3: string) -- line: 22
				-- upvalues: ChatMute (copy)
				ChatMute.mutePlayer({
					displayName = s3
				})
			end,
			unmuteGlobalDisplayName = function(s4: string) -- line: 25
				-- upvalues: ChatMute (copy)
				ChatMute.unmutePlayer({
					displayName = s4
				})
			end,
			isUsernameMuted = ChatMute.isUsernameMuted,
			isDisplayNameMuted = ChatMute.isDisplayNameMuted,
			muteGlobalUserId = function(p1) -- line: 30
				-- upvalues: ChatMute (copy)
				ChatMute.mutePlayer({
					userId = tostring(p1)
				})
			end,
			unmuteGlobalUserId = function(p2) -- line: 33
				-- upvalues: ChatMute (copy)
				ChatMute.unmutePlayer({
					userId = tostring(p2)
				})
			end,
			isUserIdMuted = ChatMute.isUserIdMuted
		}
	end)
end

local createGlobalMutedUsersStore = require(script.createGlobalMutedUsersStore)

return Signals.createComputed(createGlobalMutedUsersStore)
