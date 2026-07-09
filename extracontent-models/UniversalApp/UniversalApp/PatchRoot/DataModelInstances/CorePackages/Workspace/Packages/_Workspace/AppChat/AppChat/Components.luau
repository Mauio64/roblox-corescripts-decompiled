local getFFlagEnableModularExternalNavigationHandler = require(script.Parent.Flags.getFFlagEnableModularExternalNavigationHandler)

return {
	ChatConversation = require(script.ChatConversation),
	EventReceivers = require(script.EventReceivers),
	ExternalNavigationHandlerContainer = if not getFFlagEnableModularExternalNavigationHandler() then nil else require(script.ExternalNavigationHandler.Container),
	Cells = require(script.Cells),
	ChatLanding = require(script.ChatLanding)
}
