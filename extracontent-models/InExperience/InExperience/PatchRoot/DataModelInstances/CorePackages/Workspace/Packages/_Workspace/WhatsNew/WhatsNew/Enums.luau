require(script.Parent.Types)

local Parent = script:FindFirstAncestor("WhatsNew").Parent
local Foundation = require(Parent.Foundation)
local t1 = {
	WhatsNew = "whatsNew",
	Onboarding = "onboarding"
}
local t2 = {
	Idle = "idle",
	TourTip = "tourTip",
	WaitingForAnchor = "waitingForAnchor"
}

return {
	TourType = t1,
	TourTypeList = {
		t1.Onboarding,
		t1.WhatsNew
	},
	WhatsNewSurface = t2,
	PopoverSide = Foundation.Enums.PopoverSide,
	PopoverAlign = Foundation.Enums.PopoverAlign
}
