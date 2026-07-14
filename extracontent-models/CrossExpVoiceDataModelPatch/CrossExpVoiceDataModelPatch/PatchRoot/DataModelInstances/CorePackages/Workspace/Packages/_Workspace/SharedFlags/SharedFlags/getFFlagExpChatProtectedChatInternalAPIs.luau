local TextChatService = game:GetService("TextChatService")
local v2 = game:DefineFastFlag("ExpChatUseInternalTextChatAPIs", false) and (game:GetEngineFeature("TextChatServiceInternalAPIs2") and (game:GetEngineFeature("TextChatServiceProtectedChatEnabled") and TextChatService:IsProtectedChatEnabled()))

return function() -- line: 16
	-- upvalues: v2 (copy)
	return v2
end
