local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AvatarChatService = game:GetService("AvatarChatService")
local v3 = game:DefineFastString("MicrophoneDevicePermissionsLoggingEventName", "microphoneDevicePermissionPrompted")

return {
	_initialized = false,
	placeId = 0,
	universeId = 0,
	placeVoiceEnabled = false,
	universeVoiceEnabled = false,
	clientSessionId = "",
	UIType = {
		EXPERIENCE_JOIN = 0,
		PROMPT_IMPRESSION = 1,
		PROMPT_INTERACTION = 2
	},
	_init = function(p1, p2, p3) -- line: 56
		-- upvalues: AvatarChatService (copy)
		p1._initialized = true
		p1.placeId = game.PlaceId
		p1.universeId = game.GameId
		p1.placeVoiceEnabled = AvatarChatService:IsEnabled(p2, Enum.AvatarChatServiceFeature.PlaceAudio)
		p1.universeVoiceEnabled = AvatarChatService:IsEnabled(p2, Enum.AvatarChatServiceFeature.UniverseAudio)
		p1:logExperienceJoin({
			didAuthorize = p3
		})
	end,
	_getEventPayload = function(p4, p5, p6) -- line: 68
		return {
			uiType = p5,
			uiContext = p6.uiContext,
			didAuthorize = p6.didAuthorize,
			placeId = p4.placeId,
			universeId = p4.universeId,
			placeVoiceEnabled = p4.placeVoiceEnabled,
			universeVoiceEnabled = p4.universeVoiceEnabled,
			clientSessionId = p4.clientSessionId
		}
	end,
	_isReady = function(p7) -- line: 81
		return p7._initialized
	end,
	init = function(p8, p9) -- line: 85
		-- upvalues: AvatarChatService (copy)
		if AvatarChatService.ClientFeaturesInitialized then
			p8:_init(AvatarChatService.ClientFeatures, p9)

			return
		end

		local connection = nil

		connection = AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Connect(function() -- line: 90
			-- upvalues: p8 (copy), AvatarChatService (copy), p9 (copy), connection (ref)
			p8:_init(AvatarChatService.ClientFeatures, p9)
			connection:Disconnect()
		end)
	end,
	logExperienceJoin = function(p10, p11) -- line: 97
		-- upvalues: RbxAnalyticsService (copy), v3 (copy)
		if not p10:_isReady() then
			return
		end

		RbxAnalyticsService:SendEventDeferred("client", "voice", v3, p10:_getEventPayload(p10.UIType.EXPERIENCE_JOIN, p11))
	end,
	logPromptImpression = function(p12, p13) -- line: 110
		-- upvalues: RbxAnalyticsService (copy), v3 (copy)
		if not p12:_isReady() then
			return
		end

		RbxAnalyticsService:SendEventDeferred("client", "voice", v3, p12:_getEventPayload(p12.UIType.PROMPT_IMPRESSION, p13))
	end,
	logPromptInteraction = function(p14, p15) -- line: 123
		-- upvalues: RbxAnalyticsService (copy), v3 (copy)
		if not p14:_isReady() then
			return
		end

		RbxAnalyticsService:SendEventDeferred("client", "voice", v3, p14:_getEventPayload(p14.UIType.PROMPT_INTERACTION, p15))
	end,
	setClientSessionId = function(p16, p17) -- line: 136
		if not p16:_isReady() or p17 == p16.clientSessionId then
			return
		end

		p16.clientSessionId = p17
	end
}
