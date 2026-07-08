local AppChat = script:FindFirstAncestor("AppChat")
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)

return function(p1) -- line: 5
	-- upvalues: shouldShowOSAForConversation (copy), shouldShowU13ChatOptInForConversation (copy)
	return shouldShowOSAForConversation(p1) or shouldShowU13ChatOptInForConversation(p1)
end
