local SocialTab = script:FindFirstAncestor("SocialTab")
local AppChatNetworking = require(SocialTab.Parent.AppChatNetworking)

return function(p1, _) -- line: 4
	-- upvalues: AppChatNetworking (copy)
	return {
		retrievalStatus = AppChatNetworking.rodux.GetMetadata.getStatus(p1)
	}
end
