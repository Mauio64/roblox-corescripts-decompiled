game:DefineFastInt("CreatorAgentChatRpcTimeoutSeconds", 30)
game:DefineFastInt("CreatorAgentChatRtnIdleFallbackSeconds", 10)
game:DefineFastInt("CreatorAgentChatRtnSequenceGapFallbackSeconds", 10)
game:DefineFastInt("CreatorAgentChatPollMinIntervalSeconds", 2)
game:DefineFastInt("CreatorAgentChatPollMaxIntervalSeconds", 30)
game:DefineFastInt("CreatorAgentChatPollBackoffMultiplier", 2)
game:DefineFastInt("CreatorAgentChatMaxReconciliationHistoryPages", 3)
game:DefineFastInt("CreatorAgentChatMaxCachedSessionHistories", 5)
game:DefineFastInt("CreatorAgentChatPrefetchHistoryPagesOnRefresh", 1)
local Constants = {}

function Constants.getRpcTimeoutSeconds()
	return game:GetFastInt("CreatorAgentChatRpcTimeoutSeconds")
end

function Constants.getRtnIdleFallbackSeconds()
	return game:GetFastInt("CreatorAgentChatRtnIdleFallbackSeconds")
end

function Constants.getRtnSequenceGapFallbackSeconds()
	return game:GetFastInt("CreatorAgentChatRtnSequenceGapFallbackSeconds")
end

function Constants.getPollMinIntervalSeconds()
	return game:GetFastInt("CreatorAgentChatPollMinIntervalSeconds")
end

function Constants.getPollMaxIntervalSeconds()
	return game:GetFastInt("CreatorAgentChatPollMaxIntervalSeconds")
end

function Constants.getPollBackoffMultiplier()
	return game:GetFastInt("CreatorAgentChatPollBackoffMultiplier")
end

function Constants.getMaxReconciliationHistoryPages()
	return game:GetFastInt("CreatorAgentChatMaxReconciliationHistoryPages")
end

function Constants.getMaxCachedSessionHistories()
	return game:GetFastInt("CreatorAgentChatMaxCachedSessionHistories")
end

function Constants.getPrefetchHistoryPagesOnRefresh()
	return game:GetFastInt("CreatorAgentChatPrefetchHistoryPagesOnRefresh")
end

return Constants
