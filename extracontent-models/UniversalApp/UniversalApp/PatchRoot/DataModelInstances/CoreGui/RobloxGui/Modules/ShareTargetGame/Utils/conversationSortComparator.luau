local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local getConversationDisplayTitle = require(ShareTargetGame.dependencies).SocialLibraries.Conversation.getConversationDisplayTitle

return function(p1, p2) -- line: 7
	-- upvalues: getConversationDisplayTitle (copy)
	assert(type(p1 == "table"), "ConversationA should be a table value. Value given: ", (type(p1)))
	assert(p1.title or p1.titleForViewer, "ConversationA should have a title string")
	assert(type(p2 == "table"), "ConversationB should be a table value. Value given: ", (type(p2)))
	assert(p2.title or p2.titleForViewer, "ConversationB should have a title string")

	if p1.lastUpdated ~= nil and p2.lastUpdated ~= nil then
		return p1.lastUpdated > p2.lastUpdated
	end

	if p1.lastUpdated ~= nil then
		return true
	end

	if p2.lastUpdated ~= nil then
		return false
	end

	return getConversationDisplayTitle(p1) < getConversationDisplayTitle(p2)
end
