local Platform = require(script.Parent.Platform)
local Icon = require(script.Parent.Parent.Icon)

local function merge(p, items) -- 2 equivalent calls inferred from this helper
	for k, item in items do
		p[k] = item
	end

	return p
end

local defaults = {
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

local KeycodeMappings = {
	[Platform.PS4] = merge(defaults, { ButtonStart = Icon.Ps4Options, ButtonSelect = Icon.Ps4Share }) -- inferred equivalent call
}

local ps5 = Platform.PS5
KeycodeMappings[ps5] = merge(defaults, { -- inferred equivalent call
	ButtonStart = Icon.Ps5Options,
	ButtonSelect = Icon.Ps5Share
})

KeycodeMappings[Platform.Xbox] = {
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

KeycodeMappings[Platform.Default] = {
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
	Tab = Icon.KeyTab,
	Thumbstick1Down = Icon.GenericStickLDown,
	Thumbstick1Left = Icon.GenericStickLLeft,
	Thumbstick1Right = Icon.GenericStickLRight,
	Thumbstick1Up = Icon.GenericStickLUp,
	Thumbstick2Down = Icon.GenericStickRDown,
	Thumbstick2Left = Icon.GenericStickRLeft,
	Thumbstick2Right = Icon.GenericStickRRight,
	Thumbstick2Up = Icon.GenericStickRUp
}
return KeycodeMappings
