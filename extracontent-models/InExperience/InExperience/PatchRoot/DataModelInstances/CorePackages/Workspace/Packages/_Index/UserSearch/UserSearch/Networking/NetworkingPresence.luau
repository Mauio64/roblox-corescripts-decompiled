local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(UserSearch.Networking.myRoduxNetworking)

local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)

if FFlagUserSearchPresenceStoreMigration then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = myRoduxNetworking }))
