local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local ChatMute = require(parent.ChatMute)

local ExpChatShared = require(parent.ExpChatShared)
local ExpChatShared2 = require(parent.ExpChatShared)
local RBXMuteCommand = ExpChatShared2.Commands.RBXMuteCommand

local Constants = require(ChatLineReporting.Common.Constants)

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore

local defineFastFlag = game:DefineFastFlag("ExpChatMuteByUserIdBeforeUsernameCheck", false)

function mutePlayer(data, p, p2)
	if FFlagExpChatUseChatMuteStore then
		if data.username == "" and not (defineFastFlag and tonumber(data.userId)) then
			return {
				key = Constants.ErrorDoesNotExistKey,
				args = { RBX_NAME = data.displayName },
				metadata = "Roblox.Mute.Error.PlayerNotFound"
			}
		end

		if tonumber(data.userId) == p.UserId then
			return {
				key = Constants.ErrorSelfMuteKey,
				args = { RBX_NAME = data.displayName },
				metadata = "Roblox.Mute.Error.CannotMuteSelf"
			}
		end

		if tonumber(data.userId) then
			ChatMute.mutePlayer({ userId = data.userId })

			return {
				key = Constants.SuccessfulMuteKey,
				args = { RBX_NAME = data.displayName },
				metadata = p2 and "Roblox.GlobalMute.Info.Success" or "Roblox.Mute.Info.Success"
			}
		end

		local muteTarget = ChatMute.resolveMuteTarget(data.displayName, (tostring(p.UserId)))

		if muteTarget.playerInfo then
			ChatMute.mutePlayer(muteTarget.playerInfo)
		end

		return {
			key = muteTarget.key,
			args = muteTarget.args,
			metadata = muteTarget.playerInfo and "Roblox.Mute.Info.Success" or "Roblox.Mute.Error.Unknown"
		}
	else
		local context = ExpChatShared.context
		local v = nil

		if p2 then
			if tonumber(data.userId) then
				if not context.globalMutedUsersStore then
					return {
						key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
						args = { RBX_NAME = data.displayName },
						metadata = "Roblox.GlobalMute.Error.ContextNotAvailable"
					}
				end

				context.globalMutedUsersStore.muteGlobalUserId(data.userId)
				return {
					key = Constants.SuccessfulMuteKey,
					args = { RBX_NAME = data.displayName },
					metadata = "Roblox.GlobalMute.Info.Success"
				}
			end
		else
			if data.username == "" then
				return {
					key = Constants.ErrorDoesNotExistKey,
					args = { RBX_NAME = data.displayName },
					metadata = "Roblox.Mute.Error.PlayerNotFound"
				}
			end

			if tonumber(data.userId) == p.UserId then
				return {
					key = Constants.ErrorSelfMuteKey,
					args = { RBX_NAME = data.displayName },
					metadata = "Roblox.Mute.Error.CannotMuteSelf"
				}
			end

			if not tonumber(data.userId) then
				return RBXMuteCommand.clientRun(context.store, p.UserId, "/mute " .. data.displayName, context)
			end

			if context.store then
				if context and context.messagesStore then
					context.messagesStore.muteUser(data.userId)
					return v
				end

				return {
					key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
					args = { RBX_NAME = data.displayName },
					metadata = "Roblox.Mute.Error.ContextNotAvailable"
				}
			end
		end

		return v
	end
end

return mutePlayer
