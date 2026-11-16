local getPlayersFromString = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/getPlayersFromString")

local fFlagExpChatUseChatMuteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/SharedFlags").FFlagExpChatUseChatMuteStore
local ChatMute = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ChatMute")

local v5 = {
	["CoreScripts.TextChat.Mute.Error.TargetDoesNotExist"] = "Roblox.Mute.Error.PlayerNotFound",
	["CoreScripts.TextChat.Mute.Error.MultipleMatches"] = "Roblox.Mute.Error.MultipleMatches",
	["CoreScripts.TextChat.Mute.Error.CannotMuteSelf"] = "Roblox.Mute.Error.CannotMuteSelf",
	["CoreScripts.TextChat.Mute.Success"] = "Roblox.Mute.Info.Success"
}

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")
return {
	name = "RBXMuteCommand",
	alias = { "/mute", "/m" },
	clientRun = function(object, p2, value, p3)
		if fFlagExpChatUseChatMuteStore then
			local muteTarget = ChatMute.resolveMuteTarget(string.split(value, " ")[2], (tostring(p2)))

			if muteTarget.playerInfo then
				ChatMute.mutePlayer(muteTarget.playerInfo)
			end

			return {
				key = muteTarget.key,
				args = muteTarget.args,
				metadata = v5[muteTarget.key]
			}
		else
			local v6 = string.split(value, " ")[2]

			if not v6 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = "" },
					metadata = "Roblox.Mute.Error.PlayerNotFound"
				}
			end

			local v7 = getPlayersFromString(object:getState().Players, v6)

			if #v7 == 0 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = v6 },
					metadata = "Roblox.Mute.Error.PlayerNotFound"
				}
			end

			if #v7 > 1 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.MultipleMatches",
					args = {},
					metadata = "Roblox.Mute.Error.MultipleMatches"
				}
			end

			local v8 = v7[1]

			if v8.userId == tostring(p2) then
				return {
					key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
					args = {},
					metadata = "Roblox.Mute.Error.CannotMuteSelf"
				}
			end

			if p3 and p3.messagesStore then
				p3.messagesStore.muteUser(v8.userId)

				return {
					key = "CoreScripts.TextChat.Mute.Success",
					args = { RBX_NAME = v8.nameToDisplay },
					metadata = "Roblox.Mute.Info.Success"
				}
			end

			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				args = {},
				metadata = "Roblox.Mute.Error.ContextNotAvailable"
			}
		end
	end
}
