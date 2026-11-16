local Foundation = script:FindFirstAncestor("Foundation")

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

require(Foundation.Enums.InputPlatform)
local getIconForKeyCode = require(Foundation.Utility.getIconForKeyCode)

local v = {}

for _, v2 in Enum.KeyCode:GetEnumItems() do
	v[v2.Name] = v2
end

local v2 = {
	RightAlt = "LeftAlt",
	RightControl = "LeftControl",
	RightMeta = "LeftMeta",
	RightShift = "LeftShift",
	RightSuper = "LeftSuper"
}

local v3 = {
	BackSlash = "\\",
	Backquote = "`",
	Comma = ",",
	Equals = "=",
	LeftBracket = "[",
	Minus = "-",
	PageDown = "Page Down",
	PageUp = "Page Up",
	Period = ".",
	Quote = "'",
	RightBracket = "]",
	Semicolon = ";",
	Slash = "/",
	QuotedDouble = "\"",
	Hash = "#",
	Dollar = "$",
	Percent = "%",
	Ampersand = "&",
	LeftParenthesis = "(",
	RightParenthesis = ")",
	Plus = "+",
	LessThan = "<",
	GreaterThan = ">",
	Question = "?",
	At = "@",
	Underscore = "_",
	Colon = ":",
	Pipe = "|",
	LeftCurly = "{",
	RightCurly = "}",
	Tilde = "~",
	Euro = "€",
	MouseLeftButton = "Left mouse button",
	MouseMiddleButton = "Middle mouse button",
	MouseRightButton = "Right mouse button",
	MouseWheel = "Mouse wheel",
	Thumbstick1Up = "Left stick up",
	Thumbstick1Down = "Left stick down",
	Thumbstick1Left = "Left stick left",
	Thumbstick1Right = "Left stick right",
	Thumbstick2Up = "Right stick up",
	Thumbstick2Down = "Right stick down",
	Thumbstick2Left = "Right stick left",
	Thumbstick2Right = "Right stick right"
}

local v4 = {
	MouseDelta = true,
	MousePosition = true,
	None = true,
	TouchPosition = true,
	TrackpadPan = true,
	TrackpadPinch = true,
	Unknown = true
}

local function isGamepadKeyCode(p): boolean -- 1 equivalent call inferred from this helper
	local name = p.Name
	return name:match("^Button") ~= nil or name:match("^DPad") ~= nil or name:match("^Thumbstick") ~= nil
end

local function normalizeModifier(p)
	local v5 = v2[p.Name]

	if v5 == nil then
		return p
	end

	return v[v5] or p
end

local function getStringForKeyCode(p) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return UserInputService:GetStringForKeyCode(p)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return result
	end

	return nil
end

local function isNonDisplayable(p): boolean -- 1 equivalent call inferred from this helper
	return v4[p.Name] == true
end

return {
	isNonDisplayable = isNonDisplayable,
	resolveKey = function(p, p2)
		if isNonDisplayable(p) then -- inferred equivalent call
			return nil
		end

		local v5 = v2[p.Name]

		p = v5 ~= nil and v[v5] or p

		local iconForKeyCode = getIconForKeyCode(p, p2)

		if iconForKeyCode then
			if isGamepadKeyCode(p) then -- inferred equivalent call
				return { kind = "GamepadIcon", icon = iconForKeyCode }
			end

			return { kind = "Icon", icon = iconForKeyCode }
		else
			local text = v3[p.Name]

			if text then
				return { kind = "Text", text = text }
			end

			return {
				kind = "Text",
				text = getStringForKeyCode(p) or p.Name -- inferred equivalent call
			}
		end
	end
}
