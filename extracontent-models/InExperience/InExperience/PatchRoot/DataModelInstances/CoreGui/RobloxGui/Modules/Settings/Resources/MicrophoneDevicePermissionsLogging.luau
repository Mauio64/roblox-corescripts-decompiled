local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AvatarChatService = game:GetService("AvatarChatService")
local defineFastString = game:DefineFastString(
	"MicrophoneDevicePermissionsLoggingEventName",
	"microphoneDevicePermissionPrompted"
)

local MicrophoneDevicePermissionsLogging = {
	_initialized = false,
	placeId = 0,
	universeId = 0,
	placeVoiceEnabled = false,
	universeVoiceEnabled = false,
	clientSessionId = "",
	UIType = { EXPERIENCE_JOIN = 0, PROMPT_IMPRESSION = 1, PROMPT_INTERACTION = 2 },
	_init = function(self, p, didAuthorize)
		self._initialized = true
		self.placeId = game.PlaceId
		self.universeId = game.GameId
		self.placeVoiceEnabled = AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.PlaceAudio)
		self.universeVoiceEnabled = AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UniverseAudio)

		self:logExperienceJoin({ didAuthorize = didAuthorize })
	end
}

function MicrophoneDevicePermissionsLogging:_getEventPayload(uiType, p)
	return {
		uiType = uiType,
		uiContext = p.uiContext,
		didAuthorize = p.didAuthorize,
		placeId = self.placeId,
		universeId = self.universeId,
		placeVoiceEnabled = self.placeVoiceEnabled,
		universeVoiceEnabled = self.universeVoiceEnabled,
		clientSessionId = self.clientSessionId
	}
end

function MicrophoneDevicePermissionsLogging:_isReady()
	return self._initialized
end

function MicrophoneDevicePermissionsLogging.init(object, p)
	if AvatarChatService.ClientFeaturesInitialized then
		object:_init(AvatarChatService.ClientFeatures, p)
		return
	end

	local clientFeaturesChangedConnection = nil
	clientFeaturesChangedConnection = AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Connect(function()
		object:_init(AvatarChatService.ClientFeatures, p)
		clientFeaturesChangedConnection:Disconnect()
	end)
end

function MicrophoneDevicePermissionsLogging:logExperienceJoin(p)
	if not self:_isReady() then
		return
	end

	RbxAnalyticsService:SendEventDeferred(
		"client",
		"voice",
		defineFastString,
		self:_getEventPayload(self.UIType.EXPERIENCE_JOIN, p)
	)
end

function MicrophoneDevicePermissionsLogging:logPromptImpression(p)
	if not self:_isReady() then
		return
	end

	RbxAnalyticsService:SendEventDeferred(
		"client",
		"voice",
		defineFastString,
		self:_getEventPayload(self.UIType.PROMPT_IMPRESSION, p)
	)
end

function MicrophoneDevicePermissionsLogging:logPromptInteraction(p)
	if not self:_isReady() then
		return
	end

	RbxAnalyticsService:SendEventDeferred(
		"client",
		"voice",
		defineFastString,
		self:_getEventPayload(self.UIType.PROMPT_INTERACTION, p)
	)
end

function MicrophoneDevicePermissionsLogging:setClientSessionId(clientSessionId)
	if not self:_isReady() or self.clientSessionId == clientSessionId then
		return
	end

	self.clientSessionId = clientSessionId
end

return MicrophoneDevicePermissionsLogging
