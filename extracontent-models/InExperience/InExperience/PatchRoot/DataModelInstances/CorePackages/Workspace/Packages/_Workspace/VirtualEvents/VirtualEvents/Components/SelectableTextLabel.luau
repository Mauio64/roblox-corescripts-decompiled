local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

local function SelectableTextLabel(p)
	local baseSize = useStyle().Font.BaseSize
	local minTextSize = p.fontStyle.RelativeMinSize * baseSize
	local maxTextSize = p.fontStyle.RelativeSize * baseSize

	local joined = Cryo.Dictionary.join({
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Font = p.fontStyle.Font,
		TextColor3 = p.colorStyle.Color,
		TextEditable = false,
		TextTransparency = p.colorStyle.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ClipsDescendants = true
	}, p, { fontStyle = Cryo.None, colorStyle = Cryo.None })

	return React.createElement("TextBox", joined, {
		TextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = maxTextSize,
			MinTextSize = minTextSize
		})
	})
end

return SelectableTextLabel
