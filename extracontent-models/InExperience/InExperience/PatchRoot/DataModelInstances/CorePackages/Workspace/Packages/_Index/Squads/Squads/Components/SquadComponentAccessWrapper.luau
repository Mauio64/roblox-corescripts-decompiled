local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local dependencies = require(Squads.dependencies)

local react = dependencies.React

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

return function(p)
	local v = react.useContext(SquadExternalContractContext).useParentChannelHasSquadAccess(p.parentChannelId)

	if useAppPolicy(function(p2)
		return p2.getCanAccessParty()
	end) and v then
		return p.children
	end

	return nil
end
