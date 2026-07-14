local getPlayersFromString = require(script.Parent.getPlayersFromString)
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Actions = ExpChatShared.Actions
local UserMuted = require(Actions.UserMuted)
local ExpChatSharedParent = ExpChatShared.Parent
local SharedFlags = require(ExpChatSharedParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local ChatMute = require(ExpChatSharedParent.ChatMute)
local t1 = {
	["CoreScripts.TextChat.Mute.Error.TargetDoesNotExist"] = "Roblox.Mute.Error.PlayerNotFound",
	["CoreScripts.TextChat.Mute.Error.MultipleMatches"] = "Roblox.Mute.Error.MultipleMatches",
	["CoreScripts.TextChat.Mute.Error.CannotMuteSelf"] = "Roblox.Mute.Error.CannotMuteSelf",
	["CoreScripts.TextChat.Mute.Success"] = "Roblox.Mute.Info.Success"
}

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/mute",
		"/m"
	},
	clientRun = function(p1, p2, p3, p4) -- line: 24
		-- upvalues: FFlagExpChatUseChatMuteStore (copy), ChatMute (copy), t1 (copy), getPlayersFromString (copy), FFlagExpChatUseMessagesStore (copy), UserMuted (copy)
		if FFlagExpChatUseChatMuteStore then
			local v15 = ChatMute.resolveMuteTarget(string.split(p3, " ")[2], (tostring(p2)))

			if v15.playerInfo then
				ChatMute.mutePlayer(v15.playerInfo)
			end

			return {
				key = v15.key,
				args = v15.args,
				metadata = t1[v15.key]
			}
		end

		local v16 = string.split(p3, " ")[2]

		if not v16 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				metadata = "Roblox.Mute.Error.PlayerNotFound",
				args = {
					RBX_NAME = ""
				}
			}
		end

		local v17 = getPlayersFromString(p1:getState().Players, v16)

		if #v17 == 0 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				metadata = "Roblox.Mute.Error.PlayerNotFound",
				args = {
					RBX_NAME = v16
				}
			}
		end

		if #v17 > 1 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.MultipleMatches",
				metadata = "Roblox.Mute.Error.MultipleMatches",
				args = {}
			}
		end

		local v18 = v17[1]

		if v18.userId == tostring(p2) then
			return {
				key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
				metadata = "Roblox.Mute.Error.CannotMuteSelf",
				args = {}
			}
		end

		if FFlagExpChatUseMessagesStore then
			if not p4 or not p4.messagesStore then
				return {
					key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
					metadata = "Roblox.Mute.Error.ContextNotAvailable",
					args = {}
				}
			end

			p4.messagesStore.muteUser(v18.userId)
		else
			p1:dispatch(UserMuted(v18.userId))
		end

		return {
			key = "CoreScripts.TextChat.Mute.Success",
			metadata = "Roblox.Mute.Info.Success",
			args = {
				RBX_NAME = v18.nameToDisplay
			}
		}
	end
}
