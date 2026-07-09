local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local useStyle = require(VirtualEvents.Parent.UIBlox).Core.Style.useStyle

local function SelectableTextLabel(t1: {[any]: any}) -- line: 15
	-- upvalues: useStyle (copy), Cryo (copy), React (copy)
	local BaseSize = useStyle().Font.BaseSize
	local v8 = t1.fontStyle.RelativeMinSize * BaseSize
	local v9 = t1.fontStyle.RelativeSize * BaseSize
	local v10 = Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		TextEditable = false,
		ClipsDescendants = true,
		AutomaticSize = Enum.AutomaticSize.XY,
		Font = t1.fontStyle.Font,
		TextColor3 = t1.colorStyle.Color,
		TextTransparency = t1.colorStyle.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	}, t1, {
		fontStyle = Cryo.None,
		colorStyle = Cryo.None
	})

	return React.createElement("TextBox", v10, {
		TextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = v9,
			MinTextSize = v8
		})
	})
end

return SelectableTextLabel
