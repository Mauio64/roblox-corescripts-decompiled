local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NetworkingPresence = require(AppChatParent.LuaSocialLibrariesDeps).NetworkingPresence
local RoduxNetworking = require(script.Parent.RoduxNetworking)

if require(AppChat.Flags.FFlagAppChatPresenceStoreMigration) then
	return nil
end

return NetworkingPresence.config({
	roduxNetworking = RoduxNetworking
})
