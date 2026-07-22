local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local ChatMute = require(ChatLineReportingParent.ChatMute)
local ExpChatShared = require(ChatLineReportingParent.ExpChatShared)
local RBXMuteCommand = require(ChatLineReportingParent.ExpChatShared).Commands.RBXMuteCommand
local UserMuted = require(ChatLineReportingParent.ExpChatShared).Actions.UserMuted
local Constants = require(ChatLineReporting.Common.Constants)
local SharedFlags = require(ChatLineReportingParent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled
local v12 = game:DefineFastFlag("ExpChatMuteByUserIdBeforeUsernameCheck", false)

function mutePlayer(p1, p2, p3) -- line: 26
	-- upvalues: FFlagExpChatUseChatMuteStore (copy), v12 (copy), Constants (copy), ChatMute (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy), UserMuted (copy), RBXMuteCommand (copy)
	if FFlagExpChatUseChatMuteStore then
		if p1.username == "" and (not v12 or not tonumber(p1.userId)) then
			return {
				metadata = "Roblox.Mute.Error.PlayerNotFound",
				key = Constants.ErrorDoesNotExistKey,
				args = {
					RBX_NAME = p1.displayName
				}
			}
		end

		if tonumber(p1.userId) == p2.UserId then
			return {
				metadata = "Roblox.Mute.Error.CannotMuteSelf",
				key = Constants.ErrorSelfMuteKey,
				args = {
					RBX_NAME = p1.displayName
				}
			}
		end

		if tonumber(p1.userId) then
			ChatMute.mutePlayer({
				userId = p1.userId
			})

			local v16 = (not FFlagChatLineReportingGlobalMuteEnabled or not p3) and "Roblox.Mute.Info.Success" or "Roblox.GlobalMute.Info.Success"

			return {
				key = Constants.SuccessfulMuteKey,
				args = {
					RBX_NAME = p1.displayName
				},
				metadata = v16
			}
		end

		local v17 = ChatMute.resolveMuteTarget(p1.displayName, (tostring(p2.UserId)))

		if v17.playerInfo then
			ChatMute.mutePlayer(v17.playerInfo)
		end

		return {
			key = v17.key,
			args = v17.args,
			metadata = not v17.playerInfo and "Roblox.Mute.Error.Unknown" or "Roblox.Mute.Info.Success"
		}
	end

	local context = ExpChatShared.context
	local v19 = nil

	if FFlagChatLineReportingGlobalMuteEnabled and p3 then
		if tonumber(p1.userId) then
			if context.globalMutedUsersStore then
				context.globalMutedUsersStore.muteGlobalUserId(p1.userId)

				return {
					metadata = "Roblox.GlobalMute.Info.Success",
					key = Constants.SuccessfulMuteKey,
					args = {
						RBX_NAME = p1.displayName
					}
				}
			end

			return {
				key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
				metadata = "Roblox.GlobalMute.Error.ContextNotAvailable",
				args = {
					RBX_NAME = p1.displayName
				}
			}
		end
	else
		if p1.username == "" then
			return {
				metadata = "Roblox.Mute.Error.PlayerNotFound",
				key = Constants.ErrorDoesNotExistKey,
				args = {
					RBX_NAME = p1.displayName
				}
			}
		end

		if tonumber(p1.userId) == p2.UserId then
			return {
				metadata = "Roblox.Mute.Error.CannotMuteSelf",
				key = Constants.ErrorSelfMuteKey,
				args = {
					RBX_NAME = p1.displayName
				}
			}
		end

		if not tonumber(p1.userId) then
			return RBXMuteCommand.clientRun(context.store, p2.UserId, "/mute " .. p1.displayName, context)
		end

		if context.store then
			if FFlagExpChatUseMessagesStore then
				if context and context.messagesStore then
					context.messagesStore.muteUser(p1.userId)

					return v19
				end

				return {
					key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
					metadata = "Roblox.Mute.Error.ContextNotAvailable",
					args = {
						RBX_NAME = p1.displayName
					}
				}
			end

			context.store:dispatch(UserMuted(p1.userId))

			return {
				metadata = "Roblox.Mute.Info.Success",
				key = Constants.SuccessfulMuteKey,
				args = {
					RBX_NAME = p1.displayName
				}
			}
		end
	end

	return v19
end

return mutePlayer
