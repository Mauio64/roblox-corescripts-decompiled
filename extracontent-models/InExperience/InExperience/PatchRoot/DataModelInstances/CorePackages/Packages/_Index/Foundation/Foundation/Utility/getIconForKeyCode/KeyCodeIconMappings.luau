local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)

local InputPlatform = require(Foundation.Enums.InputPlatform)

local defaults = {
	ButtonA = "PsX",
	ButtonB = "PsCircle",
	ButtonX = "PsSquare",
	ButtonY = "PsTriagle",
	ButtonL1 = "PsL1",
	ButtonL2 = "PsL2",
	ButtonL3 = "PsL3",
	ButtonR1 = "PsR1",
	ButtonR2 = "PsR2",
	ButtonR3 = "PsR3",
	Thumbstick1 = "PsStickLeft",
	Thumbstick2 = "PsStickRight",
	DPadDown = "PsDpadDown",
	DPadUp = "PsDpadUp",
	DPadLeft = "PsDpadLeft",
	DPadRight = "PsDpadRight",
	ButtonDown = "PsDpadDown",
	ButtonUp = "PsDpadUp",
	ButtonLeft = "PsDpadLeft",
	ButtonRight = "PsDpadRight"
}

local function merge(p, items) -- 1 equivalent call inferred from this helper
	local clone = table.clone(p)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

local ps4 = InputPlatform.PS4
local clone = table.clone(defaults)

local iconKeysByPlatform = {}

for k, v in { ButtonStart = "Ps4Options", ButtonSelect = "Ps4Share", ButtonBack = "Ps4Share" } do
	clone[k] = v
end

iconKeysByPlatform[ps4] = clone

local ps5 = InputPlatform.PS5
iconKeysByPlatform[ps5] = merge(defaults, { -- inferred equivalent call
	ButtonStart = "Ps5Options",
	ButtonSelect = "Ps5Share",
	ButtonBack = "Ps5Share"
})

iconKeysByPlatform[InputPlatform.Xbox] = {
	ButtonA = "XboxA",
	ButtonB = "XboxB",
	ButtonX = "XboxX",
	ButtonY = "XboxY",
	ButtonL1 = "XboxLb",
	ButtonL2 = "XboxLt",
	ButtonL3 = "XboxStickLeft",
	ButtonR1 = "XboxRb",
	ButtonR2 = "XboxRt",
	ButtonR3 = "XboxStickRight",
	ButtonStart = "XboxMenu",
	ButtonSelect = "XboxView",
	ButtonBack = "XboxView",
	Thumbstick1 = "XboxStickLeftDirectional",
	Thumbstick2 = "XboxStickRightDirectional",
	DPadDown = "XboxDpadDown",
	DPadUp = "XboxDpadUp",
	DPadLeft = "XboxDpadLeft",
	DPadRight = "XboxDpadRight",
	ButtonDown = "XboxDpadDown",
	ButtonUp = "XboxDpadUp",
	ButtonLeft = "XboxDpadLeft",
	ButtonRight = "XboxDpadRight"
}

iconKeysByPlatform[InputPlatform.Default] = {
	Backspace = "KeyBackspace",
	CapsLock = "KeyCapsLock",
	Escape = "SquareTextEsc",
	Return = "KeyReturn",
	KeypadEnter = "KeyReturn",
	Space = "KeySpace",
	Tab = "KeyTab",
	Down = "KeyArrowDown",
	Left = "KeyArrowLeft",
	Right = "KeyArrowRight",
	Up = "KeyArrowUp",
	LeftAlt = "KeyAlt",
	RightAlt = "KeyAlt",
	LeftControl = "KeyControl",
	RightControl = "KeyControl",
	LeftMeta = "KeyCommand",
	RightMeta = "KeyCommand",
	LeftSuper = "KeyCommand",
	RightSuper = "KeyCommand",
	LeftShift = "KeyShift",
	RightShift = "KeyShift",
	Asterisk = "KeyAsterisk",
	KeypadMultiply = "KeyAsterisk",
	Backquote = "KeyGraveAccent",
	Caret = "KeyCaret",
	Comma = "KeyComma",
	Period = "KeyPeriod",
	KeypadPeriod = "KeyPeriod",
	Quote = "KeyApostrophe",
	MouseLeftButton = "MouseButtonLeft",
	MouseMiddleButton = "MouseButtonCenter",
	MouseRightButton = "MouseButtonRight",
	MouseWheel = "MouseScrollwheel"
}

local function resolveIconAsset(p: string) -- 1 equivalent call inferred from this helper
	local v = BuilderIcons.Icon[p]
	return if typeof(v) == "string" and v ~= "" then v else nil
end

local v = {}

for k, v2 in iconKeysByPlatform do
	local iconAssets = {}

	for k2, v3 in v2 do
		local iconAsset = resolveIconAsset(v3) -- inferred equivalent call

		if iconAsset then
			iconAssets[k2] = iconAsset
		end
	end

	v[k] = iconAssets
end

local function getFallbackPlatform(p: string) -- 1 equivalent call inferred from this helper
	if p == InputPlatform.Default then
		return InputPlatform.Xbox
	end

	return InputPlatform.Default
end

return {
	getIconForKeyName = function(p: string, p2: string)
		return v[p2][p] or v[getFallbackPlatform(p2)][p] -- inferred equivalent call
	end,
	iconKeysByPlatform = iconKeysByPlatform
}
