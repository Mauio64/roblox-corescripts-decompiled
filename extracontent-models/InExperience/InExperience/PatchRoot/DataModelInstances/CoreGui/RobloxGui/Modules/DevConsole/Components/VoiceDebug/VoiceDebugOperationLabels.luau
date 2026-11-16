local v = {
	ice = "ICE",
	sdp = "SDP",
	ssrc = "SSRC",
	acs = "ACS",
	rtc = "RTC"
}

local v2 = { "State", "Operation", "Event" }

local function stripTrailingSuffix(value: string)
	for _, v3 in v2 do
		local v4 = #value - #v3

		if v4 > 0 and value:sub(v4 + 1) == v3 then
			return value:sub(1, v4)
		end
	end

	return value
end

local function splitPascalCase(value: string)
	local v3 = ""
	local result = {}

	for i = 1, #value do
		local v4 = value:sub(i, i)
		local v5 = value:sub(i + 1, i + 1)
		v3 ..= v4
		local v6 = v4:match("%u") ~= nil
		local v7 = v5:match("%u") ~= nil

		if v6 or not v7 then
			if v6 and v7 and value:sub(i + 2, i + 2):match("%l") then
				result[#result + 1] = v3
				v3 = ""
			end
		else
			result[#result + 1] = v3
			v3 = ""
		end
	end

	if v3 ~= "" then
		result[#result + 1] = v3
	end

	return result
end

local function canonicalizeWord(value: string) -- 1 equivalent call inferred from this helper
	return v[value:lower()] or value
end

local function humanizeName(p: string)
	local v3 = splitPascalCase(stripTrailingSuffix(p))

	for k, v4 in v3 do
		v3[k] = canonicalizeWord(v4) -- inferred equivalent call
	end

	return table.concat(v3, " ")
end

local operationTypeLabels = {
	ClientJoinOperation = "Join",
	ClientLeaveOperation = "Leave",
	ClientPublishOperation = "Publish",
	ClientSubscribeOperation = "Subscribe",
	ClientMuteUnmuteOperation = "Mute/Unmute",
	ClientPeerLocalMuteUnmuteOperation = "Peer Local Mute/Unmute",
	ClientPeerRemoteMuteUnmuteOperation = "Peer Remote Mute/Unmute",
	ClientCullingOperation = "Culling",
	ClientICETrickleOperation = "ICE Trickle",
	ClientTurnAuthOperation = "TURN Auth",
	ClientSubscriberAudioQualityOperation = "Subscriber Audio Quality",
	ClientVoiceRtcStatsOperation = "Voice RTC Stats",
	ClientVoiceRtcStatsMonitorOperation = "Voice RTC Stats Monitor",
	ClientVoiceWebrtcConnectionChangesOperation = "WebRTC Connection Changes",
	ClientRebootOperation = "Reboot",
	ClientContextParsingOperation = "Context Parsing",
	ConnectOperation = "Connect"
}

local eventNameLabels = {
	ClientRetryJoin = "Client Retry Join",
	ClientRetryJoinWithConfig = "Client Retry Join With Config",
	VoiceChatplayerMuteStatusChangedEvent = "Player Mute Status Changed",
	SubscribeStateChange = "Subscribe State Change",
	PublishStateChange = "Publish State Change",
	JoinedVoice = "Joined Voice",
	JoinedVoiceV2 = "Joined Voice V2",
	PublishingHandshakeAcked = "Publishing Handshake Acked",
	PublishingHandshakeCompleted = "Publishing Handshake Completed",
	PublishingHandshakeInitiated = "Publishing Handshake Initiated",
	PublishingHandshakeInitiatedWithBothSdp = "Publishing Handshake Initiated (Both SDP)",
	PublishingHandshakeAckedWithBothSdp = "Publishing Handshake Acked (Both SDP)",
	PublishingHandshakeInitiatedWithCompressedSdp = "Publishing Handshake Initiated (Compressed SDP)",
	PublishingHandshakeAckedWithCompressedSdp = "Publishing Handshake Acked (Compressed SDP)",
	UpdateTurnAuthInfoRequest = "Update TURN Auth Info Request",
	ACSCleanup = "ACS Cleanup",
	ReJoinedVoice = "Rejoined Voice",
	ReJoinedVoiceV2 = "Rejoined Voice V2",
	UserTurnAuth = "User TURN Auth",
	UserTurnAuthV2 = "User TURN Auth V2",
	FetchUserTurnAuthOperationFailed = "Fetch User TURN Auth Failed",
	RelayCandidatesGathered = "Relay Candidates Gathered",
	VoiceChatClientVoiceCapability = "Client Voice Capability",
	VoiceChatClientVoiceCapabilityWithConfig = "Client Voice Capability (With Config)",
	VoiceChatPlayerMuteStateChangedClientToServer = "Player Mute State Changed (Client to Server)",
	VoiceChatPlayerMuteStateChangedServerToClient = "Player Mute State Changed (Server to Client)",
	VoiceChatSampleTaggedEventClientToServer = "Sample Tagged Event (Client to Server)",
	VoiceChatSampleTaggedEventServerToClient = "Sample Tagged Event (Server to Client)",
	VoiceSetupFailed = "Voice Setup Failed",
	SubscriptionReset = "Subscription Reset",
	SsrcUserIdMappingUpdate = "SSRC/User ID Mapping Update",
	ClientStreamSwitchAck = "Client Stream Switch Ack",
	SubscriptionHandshakeInitiated = "Subscription Handshake Initiated",
	SubscriptionHandshakeAcked = "Subscription Handshake Acked",
	SubscriptionHandshakeInitiatedWithBothSdp = "Subscription Handshake Initiated (Both SDP)",
	SubscriptionHandshakeAckedWithBothSdp = "Subscription Handshake Acked (Both SDP)",
	SubscriptionHandshakeInitiatedWithCompressedSdp = "Subscription Handshake Initiated (Compressed SDP)",
	SubscriptionHandshakeAckedWithCompressedSdp = "Subscription Handshake Acked (Compressed SDP)",
	SubscriptionHandshakeCompleted = "Subscription Handshake Completed",
	VoiceChatSubscriptionInitialBatchEmpty = "Subscription Initial Batch Empty",
	SubscriptionFeedStarted = "Subscription Feed Started",
	VoiceMigration = "Voice Migration",
	SubscriberAudioQualitySample = "Subscriber Audio Quality Sample"
}
local VoiceDebugOperationLabels = {}
VoiceDebugOperationLabels.operationTypeLabels = operationTypeLabels
VoiceDebugOperationLabels.eventNameLabels = eventNameLabels
VoiceDebugOperationLabels.humanizeName = humanizeName

function VoiceDebugOperationLabels.labelForOperationType(p: string)
	return operationTypeLabels[p] or humanizeName(p)
end

function VoiceDebugOperationLabels.labelForEventName(p: string)
	return eventNameLabels[p] or humanizeName(p)
end

return VoiceDebugOperationLabels
