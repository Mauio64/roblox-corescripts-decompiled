local ChatMute = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ChatMute")

local ExpChatShared = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ExpChatShared")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")
local fFlagExpChatUseChatMuteStore = SharedFlags.FFlagExpChatUseChatMuteStore
local fFlagAbuseReportVoiceMute = SharedFlags.FFlagAbuseReportVoiceMute

local function voiceMutePlayer(p2, object)
	if not (fFlagAbuseReportVoiceMute and object) then
		return
	end

	local participants = object.participants

	if not participants then
		return
	end

	local participant = participants[tostring(p2)]

	if participant and not participant.isMutedLocally then
		object:ToggleMutePlayer(p2, "igm-report-v2")
	end
end

function LUAUFORGE_MODULE_GLOBALS_eOw_muteUser(p2, p3, object): boolean
	if not (p2 and p3 and p2 ~= p3.UserId) then
		return false
	end

	if fFlagExpChatUseChatMuteStore then
		ChatMute.mutePlayer({ userId = tostring(p2) })
		local participants = fFlagAbuseReportVoiceMute
			and fFlagAbuseReportVoiceMute
			and object
			and object.participants

		if participants then
			local participant = participants[tostring(p2)]

			if participant and not participant.isMutedLocally then
				object:ToggleMutePlayer(p2, "igm-report-v2")
			end
		end

		return true
	else
		local context = ExpChatShared.context

		if not (context.store and context.messagesStore) then
			return false
		end

		context.messagesStore.muteUser(p2)
		local participants = fFlagAbuseReportVoiceMute
			and fFlagAbuseReportVoiceMute
			and object
			and object.participants

		if participants then
			local participant = participants[tostring(p2)]

			if participant and not participant.isMutedLocally then
				object:ToggleMutePlayer(p2, "igm-report-v2")
			end
		end

		return true
	end
end

function LUAUFORGE_MODULE_GLOBALS_eOw_isUserMuted(p2)
	if not p2 then
		return false
	end

	if fFlagExpChatUseChatMuteStore then
		return ChatMute.isUserIdMuted((tostring(p2)))
	end

	local context = ExpChatShared.context

	if not context.store then
		return false
	end

	if context.messagesStore then
		return context.messagesStore.getMutedUserIds(false)[tostring(p2)] == true
	end

	return false
end

return {
	isUserMuted = LUAUFORGE_MODULE_GLOBALS_eOw_isUserMuted,
	muteUser = LUAUFORGE_MODULE_GLOBALS_eOw_muteUser
}
