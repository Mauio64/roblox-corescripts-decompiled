local TextChatService = game:GetService("TextChatService")
local v2 = game:DefineFastFlag("ExpChatUseInternalTextChatAPIs", false) and (game:GetEngineFeature("TextChatServiceInternalAPIs2") and TextChatService.EnableProtectedChat == Enum.RolloutState.Enabled)

return function() -- line: 15
	-- upvalues: v2 (copy)
	return v2
end
