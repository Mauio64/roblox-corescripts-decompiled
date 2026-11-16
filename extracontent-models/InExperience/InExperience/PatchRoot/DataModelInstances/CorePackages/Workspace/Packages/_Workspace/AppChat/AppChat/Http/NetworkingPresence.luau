local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local networkingPresence = LuaSocialLibrariesDeps.NetworkingPresence

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

if FFlagAppChatPresenceStoreMigration then
	return nil
end

return (networkingPresence.config({ roduxNetworking = RoduxNetworking }))
