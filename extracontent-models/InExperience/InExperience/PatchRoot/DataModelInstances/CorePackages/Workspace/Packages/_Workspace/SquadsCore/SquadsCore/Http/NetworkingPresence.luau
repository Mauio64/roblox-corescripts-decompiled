local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

local FFlagSquadsPresenceStoreMigration = require(SquadsCore.Flags.FFlagSquadsPresenceStoreMigration)

if FFlagSquadsPresenceStoreMigration then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = RoduxNetworking }))
