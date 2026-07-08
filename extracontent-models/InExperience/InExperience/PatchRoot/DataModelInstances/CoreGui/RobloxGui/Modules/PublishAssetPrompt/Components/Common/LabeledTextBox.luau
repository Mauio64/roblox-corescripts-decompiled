local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local useStyle = UIBlox.Core.Style.useStyle
local scriptParent = script.Parent
local NameTextBox = require(scriptParent.NameTextBox)
local t1 = {
	textBoxHeight = 30,
	topPadding = 0
}

local function LabeledTextBox(t2: {[any]: any}) -- line: 43
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), NameTextBox (copy)
	local v11 = Cryo.Dictionary.join(t1, t2)
	local v12 = useStyle()
	local Font = v12.Font
	local BaseSize = Font.BaseSize
	local Theme = v12.Theme
	local v16 = 19 + v11.textBoxHeight + v11.topPadding
	local CaptionHeader = Font.CaptionHeader
	local TextDefaultColor = Theme.TextDefault.Color

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v16),
		LayoutOrder = v11.LayoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 4)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v11.topPadding)
		}),
		TextboxLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 15),
			Font = CaptionHeader.Font,
			Text = v11.labelText,
			TextSize = BaseSize * CaptionHeader.RelativeSize,
			TextColor3 = TextDefaultColor,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Textbox = React.createElement(NameTextBox, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v11.textBoxHeight),
			maxLength = v11.maxLength,
			onNameUpdated = v11.onTextUpdated,
			defaultName = v11.defaultText,
			centerText = v11.centerText,
			nameTextBoxRef = v11.textBoxRef,
			invalidInputText = v11.invalidInputText
		})
	})
end

return LabeledTextBox
