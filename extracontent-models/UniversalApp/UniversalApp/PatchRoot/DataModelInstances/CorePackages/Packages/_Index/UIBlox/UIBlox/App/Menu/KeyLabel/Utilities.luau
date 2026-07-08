local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent

require(scriptParent.Types)

local Constants = require(scriptParent.Constants)

require(scriptParentParentParent.Style.Fonts)

local Images = require(scriptParentParentParent.ImageSet.Images)
local GetTextSize = require(scriptParentParentParentParent.Core.Text.GetTextSize)
local platformIconMap = require(scriptParentParent.platformIconMap)
local UserInputService = game:GetService("UserInputService")
local DIRECTIONAL_GAMEPAD_ICONS = platformIconMap.DIRECTIONAL_GAMEPAD_ICONS
local GAMEPAD_ICONS = platformIconMap.GAMEPAD_ICONS
local t1 = {
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

local function getKeyCodeContent(p1) -- line: 46
	-- upvalues: DIRECTIONAL_GAMEPAD_ICONS (copy), GAMEPAD_ICONS (copy), UserInputService (copy), t1 (copy)
	if type(p1) == "table" then
		return {
			inputType = "gamepad",
			content = DIRECTIONAL_GAMEPAD_ICONS[p1.key][p1.axis]
		}
	end

	if GAMEPAD_ICONS[p1] then
		return {
			inputType = "gamepad",
			content = GAMEPAD_ICONS[p1]
		}
	end

	local StringForKeyCode = UserInputService:GetStringForKeyCode(p1)

	return {
		inputType = "keyboard",
		content = t1[p1] or if StringForKeyCode == "" then p1.Name else StringForKeyCode
	}
end
local function getWidthFromContent(p2, p3) -- line: 63
	-- upvalues: GetTextSize (copy), Constants (copy)
	if p2.inputType == "keyboard" then
		if type(p2.content) == "string" then
			local BaseSize = p3.BaseSize
			local CaptionBody = p3.CaptionBody
			local v21 = BaseSize * CaptionBody.RelativeSize
			local X = GetTextSize(p2.content, v21, CaptionBody.Font, Vector2.zero).X

			if X + 2 * Constants.MIN_SIDE_PADDING > Constants.PREFERRED_WIDTH then
				return X + 2 * Constants.SIDE_PADDING
			end
		end

		return Constants.PREFERRED_WIDTH
	end

	if p2.inputType == "gamepad" then
		local v23 = if typeof(p2.content) ~= "string" then p2.content.ImageRectSize else Constants.DEFAULT_GAMEPAD_ICON_SIZE

		return v23.X * Constants.HEIGHT / v23.Y
	end

	assert(false, string.format("Unreachable: Invalid inputType value: %q", p2.inputType))
end

function getKeyLabelWidth(p4, p5) -- line: 87
	-- upvalues: getKeyCodeContent (copy), getWidthFromContent (copy)
	local v26 = getKeyCodeContent(p4)

	return getWidthFromContent(v26, p5)
end

return {
	getKeyLabelWidth = getKeyLabelWidth,
	getKeyCodeContent = getKeyCodeContent,
	getWidthFromContent = getWidthFromContent
}
