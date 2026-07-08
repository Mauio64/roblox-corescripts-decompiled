local ParentContainer = require(script.ParentContainer)

return {
	ChatPlacementContext = require(script.ChatPlacementContext),
	ParentContainer = ParentContainer,
	UnreadMessagesProvider = require(script.UnreadMessages.UnreadMessagesProvider)
}
