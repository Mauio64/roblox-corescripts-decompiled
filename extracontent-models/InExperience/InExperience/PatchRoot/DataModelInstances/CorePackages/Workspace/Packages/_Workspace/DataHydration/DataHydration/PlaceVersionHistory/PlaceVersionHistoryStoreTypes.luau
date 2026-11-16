local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(parent.Signals)

return {
	SaveType = { Null = 0, AutoSave = 1, ManualSave = 2 },
	PublishStatus = { NotPublished = 0, Live = 1, PreviouslyPublished = 2 }
}
