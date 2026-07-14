local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.DataHydrationTypes)

local t1 = {
	Null = 0,
	AutoSave = 1,
	ManualSave = 2
}
local t2 = {
	NotPublished = 0,
	Live = 1,
	PreviouslyPublished = 2
}

return {
	SaveType = t1,
	PublishStatus = t2
}
