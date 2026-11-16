local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.React)
require(parent.Signals)
require(parent.DataHydration.MomentsStoreTypes)
require(parent.MomentsTypes)

require(Moments.Components.VerticalPager)
require(Moments.Analytics.RecommendationContentType)
require(Moments.Enums.SignalActionType)
require(Moments.Enums.NavigationDestinationType)

return {}
