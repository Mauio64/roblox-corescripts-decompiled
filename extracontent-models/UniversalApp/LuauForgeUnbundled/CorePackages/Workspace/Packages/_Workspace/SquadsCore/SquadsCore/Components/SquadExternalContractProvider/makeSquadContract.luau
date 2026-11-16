local DefaultSquadContract = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/DefaultSquadContract")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadContractType")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")

return function(p2)
	return Cryo.Dictionary.union(DefaultSquadContract, p2)
end
