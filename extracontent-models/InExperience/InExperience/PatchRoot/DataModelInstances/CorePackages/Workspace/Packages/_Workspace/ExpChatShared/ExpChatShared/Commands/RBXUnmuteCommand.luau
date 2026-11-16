local getPlayersFromString = require(script.Parent.getPlayersFromString)
local parent = script:FindFirstAncestor("ExpChatShared").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local ChatMute = require(parent.ChatMute)

local v = {
	["CoreScripts.TextChat.Mute.Error.TargetDoesNotExist"] = "Roblox.Unmute.Error.PlayerNotFound",
	["CoreScripts.TextChat.Mute.Error.MultipleMatches"] = "Roblox.Unmute.Error.MultipleMatches",
	["CoreScripts.TextChat.Mute.Error.CannotMuteSelf"] = "Roblox.Unmute.Error.CannotMuteSelf",
	["CoreScripts.TextChat.Unmute.Success"] = "Roblox.Unmute.Info.Success"
}

require(script.Parent.types)
return {
	name = script.Name,
	alias = { "/unmute", "/um" },
	clientRun = function(object, p, value, p2)
		if FFlagExpChatUseChatMuteStore then
			local unmuteTarget = ChatMute.resolveUnmuteTarget(string.split(value, " ")[2], (tostring(p)))

			if unmuteTarget.playerInfo then
				ChatMute.unmutePlayer(unmuteTarget.playerInfo)
			end

			return {
				key = unmuteTarget.key,
				args = unmuteTarget.args,
				metadata = v[unmuteTarget.key]
			}
		else
			local v2 = string.split(value, " ")[2]

			if not v2 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = "" },
					metadata = "Roblox.Unmute.Error.PlayerNotFound"
				}
			end

			local playersFromString = getPlayersFromString(object:getState().Players, v2)

			if #playersFromString == 0 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = v2 },
					metadata = "Roblox.Unmute.Error.PlayerNotFound"
				}
			end

			if #playersFromString > 1 then
				return {
					key = "InGame.Chat.Response.DisplayNameMultipleMatches",
					args = {},
					metadata = "Roblox.Unmute.Error.MultipleMatches"
				}
			end

			local v3 = playersFromString[1]

			if v3.userId == tostring(p) then
				return {
					key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
					args = {},
					metadata = "Roblox.Unmute.Error.CannotMuteSelf"
				}
			end

			if p2 and p2.messagesStore then
				p2.messagesStore.unmuteUser(v3.userId)

				return {
					key = "CoreScripts.TextChat.Unmute.Success",
					args = { RBX_NAME = v3.nameToDisplay },
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
