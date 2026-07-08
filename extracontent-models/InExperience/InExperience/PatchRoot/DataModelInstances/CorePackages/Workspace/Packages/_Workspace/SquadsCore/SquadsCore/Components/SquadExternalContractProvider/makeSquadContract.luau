local Parent = script:FindFirstAncestor("SquadsCore").Parent
local DefaultSquadContract = require(script.Parent.DefaultSquadContract)

require(script.Parent.SquadContractType)

local Cryo = require(Parent.Cryo)

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: Cryo (copy), DefaultSquadContract (copy)
	return Cryo.Dictionary.union(DefaultSquadContract, t1)
end
