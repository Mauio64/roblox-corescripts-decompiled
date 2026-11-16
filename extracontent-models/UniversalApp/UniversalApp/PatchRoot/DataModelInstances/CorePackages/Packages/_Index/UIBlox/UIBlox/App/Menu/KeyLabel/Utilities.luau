local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

require(parent.Types)
local Constants = require(parent.Constants)
require(parent3.Style.Fonts)
local Images = require(parent3.ImageSet.Images)
local GetTextSize = require(parent4.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent4.Core.Text.GetFontFromFontStyle)
local platformIconMap = require(parent2.platformIconMap)

local UserInputService = game:GetService("UserInputService")

local DIRECTIONAL_GAMEPAD_ICONS = platformIconMap.DIRECTIONAL_GAMEPAD_ICONS

local GAMEPAD_ICONS = platformIconMap.GAMEPAD_ICONS

local v = {
	[Enum.KeyCode.Escape] = "Esc",
	[Enum.KeyCode.Print] = "Prt Sc",
	[Enum.KeyCode.ScrollLock] = "Sc Lock",
	[Enum.KeyCode.Pause] = "Pause",
	[Enum.KeyCode.Insert] = "Ins",
	[Enum.KeyCode.PageUp] = "PgUp",
	[Enum.KeyCode.NumLock] = "Num Lock",
	[Enum.KeyCode.Delete] = "Del",
	[Enum.KeyCode.End] = "End",
	[Enum.KeyCode.PageDown] = "PgDn",
	[Enum.KeyCode.CapsLock] = "Caps",
	[Enum.KeyCode.Return] = "Enter",
	[Enum.KeyCode.LeftShift] = "Shift",
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.Space] = "Space",
	[Enum.KeyCode.LeftMeta] = "Fn",
	[Enum.KeyCode.LeftSuper] = "Cmd",
	[Enum.KeyCode.Tilde] = "~",
	[Enum.KeyCode.Up] = Images["icons/controls/keys/arrowUp"],
	[Enum.KeyCode.Down] = Images["icons/controls/keys/arrowDown"],
	[Enum.KeyCode.Left] = Images["icons/controls/keys/arrowLeft"],
	[Enum.KeyCode.Right] = Images["icons/controls/keys/arrowRight"]
}

local function getKeyCodeContent(data)
	if type(data) == "table" then
		return { inputType = "gamepad", content = DIRECTIONAL_GAMEPAD_ICONS[data.key][data.axis] }
	end

	if GAMEPAD_ICONS[data] then
		return { inputType = "gamepad", content = GAMEPAD_ICONS[data] }
	end

	local stringForKeyCode = UserInputService:GetStringForKeyCode(data)

	local content = v[data]

	if not content then
		if stringForKeyCode == "" then
			content = data.Name
		else
			content = stringForKeyCode
		end
	end

	return { inputType = "keyboard", content = content }
end

local function getWidthFromContent(p, p2)
	if p.inputType == "keyboard" then
		if type(p.content) ~= "string" then
			return Constants.PREFERRED_WIDTH
		end

		local baseSize = p2.BaseSize

		local captionBody = p2.CaptionBody
		local v2 = baseSize * captionBody.RelativeSize

		local fontFromFontStyle = GetFontFromFontStyle(captionBody)
		local x = GetTextSize(p.content, v2, fontFromFontStyle, Vector2.zero).X

		if x + 2 * Constants.MIN_SIDE_PADDING > Constants.PREFERRED_WIDTH then
			return x + 2 * Constants.SIDE_PADDING
		end

		return Constants.PREFERRED_WIDTH
	else
		if p.inputType ~= "gamepad" then
			assert(false, string.format("Unreachable: Invalid inputType value: %q", p.inputType))
			return
		end

		local v2

		if typeof(p.content) == "string" then
			v2 = Constants.DEFAULT_GAMEPAD_ICON_SIZE
		else
			v2 = p.content.ImageRectSize
		end

		return v2.X * Constants.HEIGHT / v2.Y
	end
end

function getKeyLabelWidth(p, p2)
	return getWidthFromContent(getKeyCodeContent(p), p2)
end

return {
	getKeyLabelWidth = getKeyLabelWidth,
	getKeyCodeContent = getKeyCodeContent,
	getWidthFromContent = getWidthFromContent
}
