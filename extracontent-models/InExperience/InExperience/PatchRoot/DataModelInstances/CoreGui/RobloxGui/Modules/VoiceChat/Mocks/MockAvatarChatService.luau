local MockAvatarChatService = {}
MockAvatarChatService.__index = MockAvatarChatService

function MockAvatarChatService.new(isEnabled, enableVoice, getPropertyChangedSignal, getClientFeaturesAsync)
	return (setmetatable(
		{
			IsEnabled = isEnabled,
			EnableVoice = enableVoice,
			GetPropertyChangedSignal = getPropertyChangedSignal,
			GetClientFeaturesAsync = getClientFeaturesAsync
		},
		MockAvatarChatService
	))
end

return MockAvatarChatService
