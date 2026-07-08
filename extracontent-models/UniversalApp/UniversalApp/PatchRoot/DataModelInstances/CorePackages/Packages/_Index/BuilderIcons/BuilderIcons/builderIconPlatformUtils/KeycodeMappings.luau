local Platform = require(script.Parent.Platform)
local Icon = require(script.Parent.Parent.Icon)

local function merge(t1: {[any]: any}, t2: {[any]: any}) -- line: 4
	for v14, v15 in t2 do
		t1[v14] = v15
	end

	return t1
end

local t3 = {
	ButtonA = Icon.PsX,
	ButtonB = Icon.PsCircle,
	ButtonX = Icon.PsSquare,
	ButtonY = Icon.PsTriagle,
	ButtonL1 = Icon.PsL1,
	ButtonL2 = Icon.PsL2,
	ButtonL3 = Icon.PsL3,
	ButtonR1 = Icon.PsR1,
	ButtonR2 = Icon.PsR2,
	ButtonR3 = Icon.PsR3,
	Thumbstick1 = Icon.PsStickLeft,
	Thumbstick2 = Icon.PsStickRight,
	DPadDown = Icon.PsDpadDown,
	DPadUp = Icon.PsDpadUp,
	DPadLeft = Icon.PsDpadLeft,
	DPadRight = Icon.PsDpadRight
}
local t4 = {}
local PS4 = Platform.PS4

for v7, v8 in {
	ButtonStart = Icon.Ps4Options,
	ButtonSelect = Icon.Ps4Share
} do
	t3[v7] = v8
end

t4[PS4] = t3

local PS5 = Platform.PS5

for v10, v11 in {
	ButtonStart = Icon.Ps5Options,
	ButtonSelect = Icon.Ps5Share
} do
	t3[v10] = v11
end

t4[PS5] = t3
t4[Platform.Xbox] = {
	ButtonA = Icon.XboxA,
	ButtonB = Icon.XboxB,
	ButtonX = Icon.XboxX,
	ButtonY = Icon.XboxY,
	ButtonL1 = Icon.XboxLb,
	ButtonL2 = Icon.XboxLt,
	ButtonL3 = Icon.XboxStickLeft,
	ButtonR1 = Icon.XboxRb,
	ButtonR2 = Icon.XboxRt,
	ButtonR3 = Icon.XboxStickRight,
	ButtonStart = Icon.XboxMenu,
	ButtonSelect = Icon.XboxView,
	Thumbstick1 = Icon.XboxStickLeftDirectional,
	Thumbstick2 = Icon.XboxStickRightDirectional,
	DPadDown = Icon.XboxDpadDown,
	DPadUp = Icon.XboxDpadUp,
	DPadLeft = Icon.XboxDpadLeft,
	DPadRight = Icon.XboxDpadRight
}
t4[Platform.Default] = {
	LeftAlt = Icon.KeyAlt,
	RightAlt = Icon.KeyAlt,
	Down = Icon.KeyArrowDown,
	Up = Icon.KeyArrowUp,
	Left = Icon.KeyArrowLeft,
	Right = Icon.KeyArrowRight,
	Asterisk = Icon.KeyAsterisk,
	Backspace = Icon.KeyBackspace,
	CapsLock = Icon.KeyCapsLock,
	Caret = Icon.KeyCaret,
	Comma = Icon.KeyComma,
	LeftControl = Icon.KeyControl,
	RightControl = Icon.KeyControl,
	Backquote = Icon.KeyGraveAccent,
	Period = Icon.KeyPeriod,
	Return = Icon.KeyReturn,
	LeftShift = Icon.KeyShift,
	RightShift = Icon.KeyShift,
	Space = Icon.KeySpace,
	Tab = Icon.KeyTab
}

return t4
