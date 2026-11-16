local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.React)
require(parent.Signals)
require(parent.MomentsTypes)

require(MomentsCreation.Enums.CreationFlowState)
require(MomentsCreation.Enums.MomentType)

return {}
