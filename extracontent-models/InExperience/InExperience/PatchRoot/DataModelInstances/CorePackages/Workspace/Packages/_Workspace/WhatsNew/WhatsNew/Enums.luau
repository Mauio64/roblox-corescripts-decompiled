require(script.Parent.Types)

local parent = script:FindFirstAncestor("WhatsNew").Parent
local Foundation = require(parent.Foundation)

local tourType = { WhatsNew = "whatsNew", Onboarding = "onboarding" }

return {
	TourType = tourType,
	TourTypeList = { tourType.Onboarding, tourType.WhatsNew },
	WhatsNewSurface = { Idle = "idle", TourTip = "tourTip", WaitingForAnchor = "waitingForAnchor" },
	PopoverSide = Foundation.Enums.PopoverSide,
	PopoverAlign = Foundation.Enums.PopoverAlign
}
