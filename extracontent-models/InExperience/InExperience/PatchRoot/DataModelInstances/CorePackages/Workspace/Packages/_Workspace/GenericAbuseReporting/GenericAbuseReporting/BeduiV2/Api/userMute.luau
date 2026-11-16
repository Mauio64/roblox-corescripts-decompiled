local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local ChatMute = require(parent.ChatMute)

local ExpChatShared = require(parent.ExpChatShared)

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local FFlagAbuseReportVoiceMute = SharedFlags.FFlagAbuseReportVoiceMute

local function voiceMutePlayer(p: number, object)
	if not (FFlagAbuseReportVoiceMute and object) then
		return
	end

	local participants = object.participants

	if not participants then
		return
	end

	local participant = participants[tostring(p)]

	if participant and not participant.isMutedLocally then
		object:ToggleMutePlayer(p, "igm-report-v2")
	end
end

function muteUser(p: number, p2, object): boolean
	if not (p and p2 and p ~= p2.UserId) then
		return false
	end

	if FFlagExpChatUseChatMuteStore then
		ChatMute.mutePlayer({ userId = tostring(p) })
		local participants = FFlagAbuseReportVoiceMute and FFlagAbuseReportVoiceMute and object and object.participants

		if participants then
			local participant = participants[tostring(p)]

			if participant and not participant.isMutedLocally then
				object:ToggleMutePlayer(p, "igm-report-v2")
			end
		end

		return true
	else
		local context = ExpChatShared.context

		if not (context.store and context.messagesStore) then
			return false
		end

		context.messagesStore.muteUser(p)
		local participants = FFlagAbuseReportVoiceMute and FFlagAbuseReportVoiceMute and object and object.participants

		if participants then
			local participant = participants[tostring(p)]

			if participant and not participant.isMutedLocally then
				object:ToggleMutePlayer(p, "igm-report-v2")
			end
		end

		return true
	end
end

function isUserMuted(p: number)
	if not p then
		return false
	end

	if FFlagExpChatUseChatMuteStore then
		return ChatMute.isUserIdMuted((tostring(p)))
	end

	local context = ExpChatShared.context

	if not context.store then
		return false
	end

	if context.messagesStore then
		return context.messagesStore.getMutedUserIds(false)[tostring(p)] == true
	end

	return false
end

return { isUserMuted = isUserMuted, muteUser = muteUser }
