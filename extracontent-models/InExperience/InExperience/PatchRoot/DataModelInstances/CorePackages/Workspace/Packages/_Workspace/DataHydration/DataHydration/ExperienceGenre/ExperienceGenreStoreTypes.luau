local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.DataHydrationTypes)

return {
	ErrorCodes = { INVALID_TAXONOMY_VERSION = 3, UPDATE_LOCKED = 9 },
	UNSET = "na",
	DEFAULT_TAXONOMY_VERSION = 1
}
