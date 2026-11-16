local getPlayersFromString = require(script.Parent.getPlayersFromString)
local parent = script:FindFirstAncestor("ExpChatShared").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local ChatMute = require(parent.ChatMute)

local v = {
	["CoreScripts.TextChat.Mute.Error.TargetDoesNotExist"] = "Roblox.Mute.Error.PlayerNotFound",
	["CoreScripts.TextChat.Mute.Error.MultipleMatches"] = "Roblox.Mute.Error.MultipleMatches",
	["CoreScripts.TextChat.Mute.Error.CannotMuteSelf"] = "Roblox.Mute.Error.CannotMuteSelf",
	["CoreScripts.TextChat.Mute.Success"] = "Roblox.Mute.Info.Success"
}

require(script.Parent.types)
return {
	name = script.Name,
	alias = { "/mute", "/m" },
	clientRun = function(object, p, value, p2)
		if FFlagExpChatUseChatMuteStore then
			local muteTarget = ChatMute.resolveMuteTarget(string.split(value, " ")[2], (tostring(p)))

			if muteTarget.playerInfo then
				ChatMute.mutePlayer(muteTarget.playerInfo)
			end

			return { key = muteTarget.key, args = muteTarget.args, metadata = v[muteTarget.key] }
		else
			local v2 = string.split(value, " ")[2]

			if not v2 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = "" },
					metadata = "Roblox.Mute.Error.PlayerNotFound"
				}
			end

			local playersFromString = getPlayersFromString(object:getState().Players, v2)

			if #playersFromString == 0 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
					args = { RBX_NAME = v2 },
					metadata = "Roblox.Mute.Error.PlayerNotFound"
				}
			end

			if #playersFromString > 1 then
				return {
					key = "CoreScripts.TextChat.Mute.Error.MultipleMatches",
					args = {},
					metadata = "Roblox.Mute.Error.MultipleMatches"
				}
			end

			local v3 = playersFromString[1]

			if v3.userId == tostring(p) then
				return {
					key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
					args = {},
					metadata = "Roblox.Mute.Error.CannotMuteSelf"
				}
			end

			if p2 and p2.messagesStore then
				p2.messagesStore.muteUser(v3.userId)

				return {
					key = "CoreScripts.TextChat.Mute.Success",
					args = { RBX_NAME = v3.nameToDisplay },
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
