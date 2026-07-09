local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.DataHydrationTypes)

return {
	Audience = {
		Invalid = 0,
		Editors = 1,
		PlayTesters = 2,
		Friends = 3,
		Public = 4
	}
}
