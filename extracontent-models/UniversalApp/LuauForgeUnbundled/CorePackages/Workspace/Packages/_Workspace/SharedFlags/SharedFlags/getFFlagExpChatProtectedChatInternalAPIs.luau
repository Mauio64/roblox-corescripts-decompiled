game:DefineFastFlag("ExpChatUseInternalTextChatAPIs2", false)

return function()
	local v5 = game:GetFastFlag("ExpChatUseInternalTextChatAPIs2")
		and game:GetEngineFeature("TextChatServiceInternalAPIs2")
		and game:GetEngineFeature("TextChatServiceProtectedChatEnabled")

	if v5 then
		local TextChatService = game:GetService("TextChatService")
		v5 = TextChatService:IsProtectedChatEnabled()
	end

	return v5
end
