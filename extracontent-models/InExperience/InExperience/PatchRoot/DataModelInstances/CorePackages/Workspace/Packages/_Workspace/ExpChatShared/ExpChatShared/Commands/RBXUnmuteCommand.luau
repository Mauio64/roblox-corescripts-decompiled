local getPlayersFromString = require(script.Parent.getPlayersFromString)
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Actions = ExpChatShared.Actions
local UserUnmuted = require(Actions.UserUnmuted)
local ExpChatSharedParent = ExpChatShared.Parent
local SharedFlags = require(ExpChatSharedParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local ChatMute = require(ExpChatSharedParent.ChatMute)
local t1 = {
	["CoreScripts.TextChat.Mute.Error.TargetDoesNotExist"] = "Roblox.Unmute.Error.PlayerNotFound",
	["CoreScripts.TextChat.Mute.Error.MultipleMatches"] = "Roblox.Unmute.Error.MultipleMatches",
	["CoreScripts.TextChat.Mute.Error.CannotMuteSelf"] = "Roblox.Unmute.Error.CannotMuteSelf",
	["CoreScripts.TextChat.Unmute.Success"] = "Roblox.Unmute.Info.Success"
}

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/unmute",
		"/um"
	},
	clientRun = function(p1, p2, p3, p4) -- line: 24
		-- upvalues: FFlagExpChatUseChatMuteStore (copy), ChatMute (copy), t1 (copy), getPlayersFromString (copy), FFlagExpChatUseMessagesStore (copy), UserUnmuted (copy)
		if FFlagExpChatUseChatMuteStore then
			local v15 = ChatMute.resolveUnmuteTarget(string.split(p3, " ")[2], (tostring(p2)))

			if v15.playerInfo then
				ChatMute.unmutePlayer(v15.playerInfo)
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
				metadata = "Roblox.Unmute.Error.PlayerNotFound",
				args = {
					RBX_NAME = ""
				}
			}
		end

		local v17 = getPlayersFromString(p1:getState().Players, v16)

		if #v17 == 0 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				metadata = "Roblox.Unmute.Error.PlayerNotFound",
				args = {
					RBX_NAME = v16
				}
			}
		end

		if #v17 > 1 then
			return {
				key = "InGame.Chat.Response.DisplayNameMultipleMatches",
				metadata = "Roblox.Unmute.Error.MultipleMatches",
				args = {}
			}
		end

		local v18 = v17[1]

		if v18.userId == tostring(p2) then
			return {
				key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
				metadata = "Roblox.Unmute.Error.CannotMuteSelf",
				args = {}
			}
		end

		if FFlagExpChatUseMessagesStore then
			if not p4 or not p4.messagesStore then
				return {
					key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
					metadata = "Roblox.Unmute.Error.ContextNotAvailable",
					args = {}
				}
			end

			p4.messagesStore.unmuteUser(v18.userId)
		else
			p1:dispatch(UserUnmuted(v18.userId))
		end

		return {
			key = "CoreScripts.TextChat.Unmute.Success",
			metadata = "Roblox.Unmute.Info.Success",
			args = {
				RBX_NAME = v18.nameToDisplay
			}
		}
	end
}
