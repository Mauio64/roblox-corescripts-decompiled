local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local MainWindow = Constants.DefaultFontSize.MainWindow
local Text = Constants.Color.Text
local mainWindow = Constants.Font.MainWindow
local MainWindowBold = Constants.Font.MainWindowBold

local function CellLabel(props)
	local text = props.text
	local size = props.size
	local pos = props.pos
	local bold = props.bold
	local layoutOrder = props.layoutOrder
	local richText = props.richText
	local textWrapped = props.textWrapped == nil or props.textWrapped
	local textTruncate

	if props.textTruncate ~= nil then
		textTruncate = props.textTruncate
	end

	return Roact.createElement("TextLabel", {
		Text = text,
		TextSize = MainWindow,
		TextColor3 = Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = textWrapped,
		TextTruncate = textTruncate,
		Font = bold and MainWindowBold or mainWindow,
		Size = size,
		Position = pos,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		RichText = richText
	})
end

return CellLabel
