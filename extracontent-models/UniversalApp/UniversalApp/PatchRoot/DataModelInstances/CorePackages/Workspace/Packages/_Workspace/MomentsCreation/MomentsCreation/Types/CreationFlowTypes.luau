local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent

require(MomentsCreationParent.React)
require(MomentsCreationParent.Signals)
require(MomentsCreationParent.MomentsTypes)
require(MomentsCreation.Enums.CreationFlowState)

return {}
