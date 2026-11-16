require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

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
