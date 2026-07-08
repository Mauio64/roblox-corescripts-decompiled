local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local React = require(Squads.dependencies).React
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local useAppPolicy = require(SquadsParent.UniversalAppPolicy).useAppPolicy

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), SquadExternalContractContext (copy), useAppPolicy (copy)
	local v7 = React.useContext(SquadExternalContractContext).useParentChannelHasSquadAccess(t1.parentChannelId)

	if useAppPolicy(function(p1) -- line: 20
		return p1.getCanAccessParty()
	end) and v7 then
		return t1.children
	end

	return nil
end
