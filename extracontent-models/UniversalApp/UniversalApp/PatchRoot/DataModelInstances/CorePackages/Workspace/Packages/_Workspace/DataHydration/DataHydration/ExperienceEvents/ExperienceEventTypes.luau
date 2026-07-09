local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(DataHydrationParent.Signals)

local t1 = {
	Upcoming = "Upcoming",
	UpcomingImminent = "UpcomingImminent",
	Ongoing = "Ongoing",
	ElapsedImminent = "ElapsedImminent",
	Elapsed = "Elapsed"
}
local t2 = {
	Going = "going",
	NotGoing = "notGoing",
	Maybe = "maybe"
}

return {
	EventStatus = t1,
	EventRsvpTypes = t2
}
