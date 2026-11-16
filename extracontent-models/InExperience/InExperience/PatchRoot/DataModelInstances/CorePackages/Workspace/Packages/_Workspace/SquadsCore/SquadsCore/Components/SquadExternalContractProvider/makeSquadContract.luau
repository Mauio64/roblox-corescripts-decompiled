local parent = script:FindFirstAncestor("SquadsCore").Parent

local DefaultSquadContract = require(script.Parent.DefaultSquadContract)
require(script.Parent.SquadContractType)

local Cryo = require(parent.Cryo)

return function(p)
	return Cryo.Dictionary.union(DefaultSquadContract, p)
end
