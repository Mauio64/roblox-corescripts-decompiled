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
	UpdateMenu = "updateMenu",
	WaitingForAnchor = "waitingForAnchor"
}
local t3 = {
	None = "none",
	Menu = "menu",
	Nested = "nested"
}

return {
	TourType = t1,
	TourTypeList = {
		t1.WhatsNew,
		t1.Onboarding
	},
	WhatsNewSurface = t2,
	PopoverSide = Foundation.Enums.PopoverSide,
	PopoverAlign = Foundation.Enums.PopoverAlign,
	TourTipCtaKind = t3
}
