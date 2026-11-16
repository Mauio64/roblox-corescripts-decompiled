local parent = script.Parent.Parent.Parent.Parent

local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	RoundedRect = "RoundedRect",
	RoundedRectNoInset = "RoundedRectNoInset",
	RoundedSlot = "RoundedSlot",
	SmallPill = "SmallPill",
	LargePill = "LargePill",
	XLargePill = "XLargePill",
	SelectedKnob = "SelectedKnob",
	UnselectedKnob = "UnselectedKnob",
	NavHighlight = "NavHighlight",
	SkinToneCircle = "SkinToneCircle",
	Square = "Square",
	Toggle = "Toggle",
	InputFields = "InputFields",
	BulletUp = "BulletUp",
	BulletDown = "BulletDown",
	SelectionCell = "SelectionCell",
	Invisible = "Invisible",
	InputButton = "InputButton"
})
