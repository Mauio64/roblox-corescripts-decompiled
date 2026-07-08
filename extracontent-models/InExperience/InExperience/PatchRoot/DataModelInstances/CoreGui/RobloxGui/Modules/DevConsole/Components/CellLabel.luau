local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local MainWindow = Constants.DefaultFontSize.MainWindow
local ColorText = Constants.Color.Text
local MainWindow2 = Constants.Font.MainWindow
local MainWindowBold = Constants.Font.MainWindowBold

local function CellLabel(t1: {[any]: any}) -- line: 21
	-- upvalues: Roact (copy), MainWindow (copy), ColorText (copy), MainWindowBold (copy), MainWindow2 (copy)
	local text = t1.text
	local size = t1.size
	local pos = t1.pos
	local bold = t1.bold
	local layoutOrder = t1.layoutOrder
	local richText = t1.richText
	local v16 = t1.textWrapped == nil or t1.textWrapped
	local v17 = if t1.textTruncate == nil then nil else t1.textTruncate

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = MainWindow,
		TextColor3 = ColorText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = v16,
		TextTruncate = v17,
		Font = bold and MainWindowBold or MainWindow2,
		Size = size,
		Position = pos,
		LayoutOrder = layoutOrder,
		RichText = richText
	})
end

return CellLabel
