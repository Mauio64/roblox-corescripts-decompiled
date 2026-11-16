local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)

local FFlagExpChatUseChatMuteStore = require(ExpChat.Flags.FFlagExpChatUseChatMuteStore)

if FFlagExpChatUseChatMuteStore then
	local ChatMute = require(parent.ChatMute)

	return Signals.createComputed(function()
		return {
			getMutedGlobalUsernames = ChatMute.getMutedUsernames(),
			getMutedGlobalDisplayNames = ChatMute.getMutedDisplayNames(),
			getMutedGlobalUserIds = ChatMute.getMutedUserIds(),
			muteGlobalUsername = function(username: string)
				ChatMute.mutePlayer({ username = username })
			end,
			unmuteGlobalUsername = function(username: string)
				ChatMute.unmutePlayer({ username = username })
			end,
			muteGlobalDisplayName = function(displayName: string)
				ChatMute.mutePlayer({ displayName = displayName })
			end,
			unmuteGlobalDisplayName = function(displayName: string)
				ChatMute.unmutePlayer({ displayName = displayName })
			end,
			isUsernameMuted = ChatMute.isUsernameMuted,
			isDisplayNameMuted = ChatMute.isDisplayNameMuted,
			muteGlobalUserId = function(p)
				ChatMute.mutePlayer({ userId = tostring(p) })
			end,
			unmuteGlobalUserId = function(p)
				ChatMute.unmutePlayer({ userId = tostring(p) })
			end,
			isUserIdMuted = ChatMute.isUserIdMuted
		}
	end)
end

local createGlobalMutedUsersStore = require(script.createGlobalMutedUsersStore)
return Signals.createComputed(createGlobalMutedUsersStore)
