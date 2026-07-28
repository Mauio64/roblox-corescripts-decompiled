local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(DataHydrationParent.HttpClient)
require(DataHydrationParent.Signals)

return {}
