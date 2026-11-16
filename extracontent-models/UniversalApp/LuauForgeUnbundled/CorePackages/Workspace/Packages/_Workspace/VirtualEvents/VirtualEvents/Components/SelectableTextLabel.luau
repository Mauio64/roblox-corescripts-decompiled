local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox").Core.Style.useStyle

local function SelectableTextLabel(p2)
	local baseSize = useStyle().Font.BaseSize
	local v5 = p2.fontStyle.RelativeMinSize * baseSize
	local v6 = p2.fontStyle.RelativeSize * baseSize

	local joined = Cryo.Dictionary.join({
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Font = p2.fontStyle.Font,
		TextColor3 = p2.colorStyle.Color,
		TextEditable = false,
		TextTransparency = p2.colorStyle.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ClipsDescendants = true
	}, p2, { fontStyle = Cryo.None, colorStyle = Cryo.None })

	return React.createElement("TextBox", joined, {
		TextSizeConstraint = React.createElement("UITextSizeConstraint", {
			MaxTextSize = v6,
			MinTextSize = v5
		})
	})
end

return SelectableTextLabel
