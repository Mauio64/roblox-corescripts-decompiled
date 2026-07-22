local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local ChatMute = require(Parent.ChatMute)
local ExpChatShared = require(Parent.ExpChatShared)
local UserMuted = require(Parent.ExpChatShared).Actions.UserMuted
local SharedFlags = require(Parent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagAbuseReportVoiceMute = SharedFlags.FFlagAbuseReportVoiceMute

local function voiceMutePlayer(n1: number, p1) -- line: 16
	-- upvalues: FFlagAbuseReportVoiceMute (copy)
	if not FFlagAbuseReportVoiceMute or not p1 then
		return
	end

	local participants = p1.participants

	if not participants then
		return
	end

	local v13 = participants[tostring(n1)]

	if v13 and not v13.isMutedLocally then
		p1:ToggleMutePlayer(n1, "igm-report-v2")
	end
end

function muteUser(n2: number, p2, p3) -- line: 31
	-- upvalues: FFlagExpChatUseChatMuteStore (copy), ChatMute (copy), FFlagAbuseReportVoiceMute (copy), ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy), UserMuted (copy)
	if not n2 or not p2 then
		return false
	end

	if n2 == p2.UserId then
		return false
	end

	if FFlagExpChatUseChatMuteStore then
		ChatMute.mutePlayer({
			userId = tostring(n2)
		})

		if FFlagAbuseReportVoiceMute and FFlagAbuseReportVoiceMute and p3 then
			local participants = p3.participants

			if participants then
				local v18 = participants[tostring(n2)]

				if v18 and not v18.isMutedLocally then
					p3:ToggleMutePlayer(n2, "igm-report-v2")
				end
			end
		end

		return true
	end

	local context = ExpChatShared.context

	if context.store then
		if FFlagExpChatUseMessagesStore then
			if context.messagesStore then
				context.messagesStore.muteUser(n2)

				if FFlagAbuseReportVoiceMute and FFlagAbuseReportVoiceMute and p3 then
					local participants = p3.participants

					if participants then
						local v21 = participants[tostring(n2)]

						if v21 and not v21.isMutedLocally then
							p3:ToggleMutePlayer(n2, "igm-report-v2")
						end
					end
				end

				return true
			end

			return false
		end

		context.store:dispatch(UserMuted(n2))

		if FFlagAbuseReportVoiceMute and FFlagAbuseReportVoiceMute and p3 then
			local participants = p3.participants

			if participants then
				local v23 = participants[tostring(n2)]

				if v23 and not v23.isMutedLocally then
					p3:ToggleMutePlayer(n2, "igm-report-v2")
				end
			end
		end

		return true
	end

	return false
end
function isUserMuted(n3: number) -- line: 70
	-- upvalues: FFlagExpChatUseChatMuteStore (copy), ChatMute (copy), ExpChatShared (copy), FFlagExpChatUseMessagesStore (copy)
	if not n3 then
		return false
	end

	if FFlagExpChatUseChatMuteStore then
		return ChatMute.isUserIdMuted((tostring(n3)))
	end

	local context = ExpChatShared.context

	if context.store then
		if FFlagExpChatUseMessagesStore then
			if context.messagesStore then
				return context.messagesStore.getMutedUserIds(false)[tostring(n3)] == true
			end

			return false
		end

		return context.store:getState().MutedUsers[tostring(n3)] == true
	end

	return false
end

return {
	isUserMuted = isUserMuted,
	muteUser = muteUser
}
