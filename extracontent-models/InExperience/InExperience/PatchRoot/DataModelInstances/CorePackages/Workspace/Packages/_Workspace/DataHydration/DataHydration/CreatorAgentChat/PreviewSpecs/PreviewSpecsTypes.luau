local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.DataHydrationTypes)
require(DataHydration.Parent.Signals)

return {
	PreviewSpecStatus = {
		Current = "current",
		OlderCommit = "older_commit",
		Unverified = "unverified"
	},
	PreviewSpecPinned = { Pr = "pr", Hash = "hash" }
}
