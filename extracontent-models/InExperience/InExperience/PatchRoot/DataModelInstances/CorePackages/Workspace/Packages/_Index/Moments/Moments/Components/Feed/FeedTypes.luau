local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent

require(MomentsParent.React)
require(MomentsParent.MomentsTypes)
require(Moments.Components.VerticalPager)
require(Moments.Enums.SignalActionType)

return {}
