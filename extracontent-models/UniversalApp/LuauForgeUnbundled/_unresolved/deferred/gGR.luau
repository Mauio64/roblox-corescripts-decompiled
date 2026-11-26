local getConversationDisplayTitle = require("@luauforge/deferred/gGN").SocialLibraries.Conversation.getConversationDisplayTitle

return function(data, data2): boolean
	assert(type(data == "table"), "ConversationA should be a table value. Value given: ", (type(data)))
	assert(data.title or data.titleForViewer, "ConversationA should have a title string")

	assert(type(data2 == "table"), "ConversationB should be a table value. Value given: ", (type(data2)))
	assert(data2.title or data2.titleForViewer, "ConversationB should have a title string")

	if data.lastUpdated ~= nil and data2.lastUpdated ~= nil then
		return data.lastUpdated > data2.lastUpdated
	end

	if data.lastUpdated ~= nil then
		return true
	end

	if data2.lastUpdated == nil then
		return getConversationDisplayTitle(data) < getConversationDisplayTitle(data2)
	end

	return false
end
