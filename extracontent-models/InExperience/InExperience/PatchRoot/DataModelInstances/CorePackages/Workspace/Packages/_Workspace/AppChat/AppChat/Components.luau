local getFFlagEnableModularExternalNavigationHandler = require(script.Parent.Flags.getFFlagEnableModularExternalNavigationHandler)

local Components = {
	ChatConversation = require(script.ChatConversation),
	EventReceivers = require(script.EventReceivers),
	ExternalNavigationHandlerContainer = 0,
	Cells = 0,
	ChatLanding = 0
}
local externalNavigationHandlerContainer

if getFFlagEnableModularExternalNavigationHandler() then
	externalNavigationHandlerContainer = require(script.ExternalNavigationHandler.Container)
end

Components.ExternalNavigationHandlerContainer = externalNavigationHandlerContainer

Components.Cells = require(script.Cells)
Components.ChatLanding = require(script.ChatLanding)
return Components
