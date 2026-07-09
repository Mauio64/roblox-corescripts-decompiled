local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local ExpChatShared = require(ChatLineReportingParent.ExpChatShared)
local RBXMuteCommand = require(ChatLineReportingParent.ExpChatShared).Commands.RBXMuteCommand
local UserMuted = require(ChatLineReportingParent.ExpChatShared).Actions.UserMuted
local Constants = require(ChatLineReporting.Common.Constants)
local SharedFlags = require(ChatLineReportingParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled

function mutePlayer(p1, p2, p3) -- line: 15
	-- upvalues: ExpChatShared (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), Constants (copy), FFlagExpChatUseMessagesStore (copy), UserMuted (copy), RBXMuteCommand (copy)
	local context = ExpChatShared.context
	local v14 = nil

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

					return v14
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

	return v14
end

return mutePlayer
