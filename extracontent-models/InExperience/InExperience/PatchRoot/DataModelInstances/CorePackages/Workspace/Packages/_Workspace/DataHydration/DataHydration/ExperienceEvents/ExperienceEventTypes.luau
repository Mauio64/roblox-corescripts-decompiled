local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(parent.Signals)

return {
	EventStatus = {
		Upcoming = "Upcoming",
		UpcomingImminent = "UpcomingImminent",
		Ongoing = "Ongoing",
		ElapsedImminent = "ElapsedImminent",
		Elapsed = "Elapsed"
	},
	EventRsvpTypes = { Going = "going", NotGoing = "notGoing", Maybe = "maybe" }
}
