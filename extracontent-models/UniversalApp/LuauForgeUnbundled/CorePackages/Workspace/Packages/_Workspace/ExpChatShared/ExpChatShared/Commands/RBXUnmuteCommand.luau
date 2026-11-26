local getPlayersFromString = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/getPlayersFromString")

local fFlagExpChatUseChatMuteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/SharedFlags").FFlagExpChatUseChatMuteStore
local ChatMute = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ChatMute")

local v5 = {
	["CoreScripts.TextChat.Mute.Error.TargetDoesNotExist"] = "Roblox.Unmute.Error.PlayerNotFound",
	["CoreScripts.TextChat.Mute.Error.MultipleMatches"] = "Roblox.Unmute.Error.MultipleMatches",
	["CoreScripts.TextChat.Mute.Error.CannotMuteSelf"] = "Roblox.Unmute.Error.CannotMuteSelf",
	["CoreScripts.TextChat.Unmute.Success"] = "Roblox.Unmute.Info.Success"
}

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")
return {
	name = "RBXUnmuteCommand",
	alias = { "/unmute", "/um" },
	clientRun = function(object, p2, value, p3)
		if fFlagExpChatUseChatMuteStore then
			local unmuteTarget = ChatMute.resolveUnmuteTarget(string.split(value, " ")[2], (tostring(p2)))

			if unmuteTarget.playerInfo then
				ChatMute.unmutePlayer(unmuteTarget.playerInfo)
			end

			return {
				key = unmuteTarget.key,
				args = unmuteTarget.args,
				metadata = v5[unmuteTarget.key]
			}
		else
			local v6 = string.split(value, " ")[2]

			if not v6 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = "" },
					metadata = "Roblox.Unmute.Error.PlayerNotFound"
				}
			end

			local v7 = getPlayersFromString(object:getState().Players, v6)

			if #v7 == 0 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = v6 },
					metadata = "Roblox.Unmute.Error.PlayerNotFound"
				}
			end

			if #v7 > 1 then
				return {
					key = "InGame.Chat.Response.DisplayNameMultipleMatches",
					args = {},
					metadata = "Roblox.Unmute.Error.MultipleMatches"
				}
			end

			local v8 = v7[1]

			if v8.userId == tostring(p2) then
				return {
					key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
					args = {},
					metadata = "Roblox.Unmute.Error.CannotMuteSelf"
				}
			end

			if p3 and p3.messagesStore then
				p3.messagesStore.unmuteUser(v8.userId)

				return {
					key = "CoreScripts.TextChat.Unmute.Success",
					args = { RBX_NAME = v8.nameToDisplay },
					metadata = "Roblox.Unmute.Info.Success"
				}
			end

			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				args = {},
				metadata = "Roblox.Unmute.Error.ContextNotAvailable"
			}
		end
	end
}
