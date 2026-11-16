local getFFlagEnableModularExternalNavigationHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagEnableModularExternalNavigationHandler")

local v5 = {
	ChatConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation"),
	EventReceivers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers"),
	ExternalNavigationHandlerContainer = 0,
	Cells = 0,
	ChatLanding = 0
}
local v6 = if getFFlagEnableModularExternalNavigationHandler() then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/Container") else nil
v5.ExternalNavigationHandlerContainer = v6

v5.Cells = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells")
v5.ChatLanding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding")
return v5
