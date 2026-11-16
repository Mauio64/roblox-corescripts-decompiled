game:DefineFastFlag("ExpChatUseInternalTextChatAPIs2", false)

return function()
	local v = game:GetFastFlag("ExpChatUseInternalTextChatAPIs2")
		and game:GetEngineFeature("TextChatServiceInternalAPIs2")
		and game:GetEngineFeature("TextChatServiceProtectedChatEnabled")

	if v then
		local TextChatService = game:GetService("TextChatService")
		return (TextChatService:IsProtectedChatEnabled())
	end

	return v
end
