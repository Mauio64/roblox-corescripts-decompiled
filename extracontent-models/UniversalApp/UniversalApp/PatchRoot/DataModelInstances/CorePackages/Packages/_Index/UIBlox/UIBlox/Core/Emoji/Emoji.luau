local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Emoji = require(scriptParent.Enum.Emoji)
local constants = require(scriptParent.constants)

local function getEmojiString(s1: string) -- line: 20
	-- upvalues: Emoji (copy), constants (copy)
	if Emoji.isEnumValue(s1) then
		return constants[s1.rawValue()]
	end

	return ""
end
local function Emoji2(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), Emoji (copy), constants (copy)
	local createElement = React.createElement
	local v11 = not t1.onActivated and "TextLabel" or "TextButton"
	local t2 = {
		Size = UDim2.fromScale(0, 1)
	}
	local emoji = t1.emoji

	t2.Text = not Emoji.isEnumValue(emoji) and "" or constants[emoji.rawValue()]
	t2.TextColor3 = Color3.fromHex("#fff")
	t2.AutomaticSize = Enum.AutomaticSize.X
	t2.Font = t1.textFont
	t2.TextSize = t1.textSize
	t2.Position = t1.Position
	t2.BackgroundTransparency = 1
	t2[React.Event.Activated] = t1.onActivated

	return createElement(v11, t2)
end

return Emoji2
