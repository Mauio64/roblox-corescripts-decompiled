local getPlayersFromString = require(script.Parent.getPlayersFromString)
local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Actions = ExpChatShared.Actions
local UserUnmuted = require(Actions.UserUnmuted)
local ExpChatSharedParent = ExpChatShared.Parent
local FFlagExpChatUseMessagesStore = require(ExpChatSharedParent.SharedFlags).FFlagExpChatUseMessagesStore

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/unmute",
		"/um"
	},
	clientRun = function(p1, p2, p3, p4) -- line: 15
		-- upvalues: getPlayersFromString (copy), FFlagExpChatUseMessagesStore (copy), UserUnmuted (copy)
		local v11 = string.split(p3, " ")[2]

		if not v11 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				metadata = "Roblox.Unmute.Error.PlayerNotFound",
				args = {
					RBX_NAME = ""
				}
			}
		end

		local v12 = getPlayersFromString(p1:getState().Players, v11)

		if #v12 == 0 then
			return {
				key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
				metadata = "Roblox.Unmute.Error.PlayerNotFound",
				args = {
					RBX_NAME = v11
				}
			}
		end

		if #v12 > 1 then
			return {
				key = "InGame.Chat.Response.DisplayNameMultipleMatches",
				metadata = "Roblox.Unmute.Error.MultipleMatches",
				args = {}
			}
		end

		local v13 = v12[1]

		if v13.userId == tostring(p2) then
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

			p4.messagesStore.unmuteUser(v13.userId)
		else
			p1:dispatch(UserUnmuted(v13.userId))
		end

		return {
			key = "CoreScripts.TextChat.Unmute.Success",
			metadata = "Roblox.Unmute.Info.Success",
			args = {
				RBX_NAME = v13.nameToDisplay
			}
		}
	end
}
