local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local FFlagLuaAppDemoModePlayButton = require(Parent.SharedFlags).FFlagLuaAppDemoModePlayButton

return {
	Loading = "Loading",
	Playable = "Playable",
	PaidAccess = "PaidAccess",
	UnplayableOther = "UnplayableOther",
	PlayableWithParty = "PlayableWithParty",
	WaitingForParty = "WaitingForParty",
	ActionNeeded = "ActionNeeded",
	FiatPaidAccess = "FiatPaidAccess",
	DemoMode = if not FFlagLuaAppDemoModePlayButton then nil else "DemoMode"
}
