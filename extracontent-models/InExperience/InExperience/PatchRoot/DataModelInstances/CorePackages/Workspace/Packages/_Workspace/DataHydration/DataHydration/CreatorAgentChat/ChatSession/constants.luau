game:DefineFastInt("CreatorAgentChatRpcTimeoutSeconds", 30)
game:DefineFastInt("CreatorAgentChatRtnIdleFallbackSeconds", 10)
game:DefineFastInt("CreatorAgentChatRtnSequenceGapFallbackSeconds", 10)
game:DefineFastInt("CreatorAgentChatPollMinIntervalSeconds", 2)
game:DefineFastInt("CreatorAgentChatPollMaxIntervalSeconds", 30)
game:DefineFastInt("CreatorAgentChatPollBackoffMultiplier", 2)
game:DefineFastInt("CreatorAgentChatMaxReconciliationHistoryPages", 3)
game:DefineFastInt("CreatorAgentChatMaxCachedSessionHistories", 5)
game:DefineFastInt("CreatorAgentChatPrefetchHistoryPagesOnRefresh", 1)

return {
	getRpcTimeoutSeconds = function() -- line: 14
		return game:GetFastInt("CreatorAgentChatRpcTimeoutSeconds")
	end,
	getRtnIdleFallbackSeconds = function() -- line: 18
		return game:GetFastInt("CreatorAgentChatRtnIdleFallbackSeconds")
	end,
	getRtnSequenceGapFallbackSeconds = function() -- line: 22
		return game:GetFastInt("CreatorAgentChatRtnSequenceGapFallbackSeconds")
	end,
	getPollMinIntervalSeconds = function() -- line: 26
		return game:GetFastInt("CreatorAgentChatPollMinIntervalSeconds")
	end,
	getPollMaxIntervalSeconds = function() -- line: 30
		return game:GetFastInt("CreatorAgentChatPollMaxIntervalSeconds")
	end,
	getPollBackoffMultiplier = function() -- line: 34
		return game:GetFastInt("CreatorAgentChatPollBackoffMultiplier")
	end,
	getMaxReconciliationHistoryPages = function() -- line: 38
		return game:GetFastInt("CreatorAgentChatMaxReconciliationHistoryPages")
	end,
	getMaxCachedSessionHistories = function() -- line: 42
		return game:GetFastInt("CreatorAgentChatMaxCachedSessionHistories")
	end,
	getPrefetchHistoryPagesOnRefresh = function() -- line: 46
		return game:GetFastInt("CreatorAgentChatPrefetchHistoryPagesOnRefresh")
	end
}
