require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

return {
	PreviewSpecStatus = {
		Current = "current",
		OlderCommit = "older_commit",
		Unverified = "unverified"
	},
	PreviewSpecPinned = { Pr = "pr", Hash = "hash" }
}
