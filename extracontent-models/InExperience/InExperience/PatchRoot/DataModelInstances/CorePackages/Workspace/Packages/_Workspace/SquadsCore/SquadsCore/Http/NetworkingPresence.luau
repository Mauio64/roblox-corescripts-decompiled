local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local RoduxNetworking = require(script.Parent.RoduxNetworking)
local LuaSocialLibrariesDeps = require(SquadsCoreParent.LuaSocialLibrariesDeps)

if require(SquadsCore.Flags.FFlagSquadsPresenceStoreMigration) then
	return nil
end

return (LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = RoduxNetworking
}))
