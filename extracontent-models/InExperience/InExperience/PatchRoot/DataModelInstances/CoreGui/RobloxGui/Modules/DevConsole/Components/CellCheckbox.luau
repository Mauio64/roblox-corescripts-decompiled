local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local Checkbox = require(script.Parent.Checkbox)
local MainWindow = Constants.DefaultFontSize.MainWindow
local Text = Constants.Color.Text
local mainWindow = Constants.Font.MainWindow
local MainWindowBold = Constants.Font.MainWindowBold
local CheckboxHeight = Constants.UtilityBarFormatting.CheckboxHeight
local CheckboxInnerPadding = Constants.UtilityBarFormatting.CheckboxInnerPadding

local function CellCheckbox(props)
	local isSelected = props.isSelected
	local size = props.size
	local pos = props.pos
	local layoutOrder = props.LayoutOrder

	return Roact.createElement(
		"Frame",
		{ Size = size, Position = pos, BackgroundTransparency = 1, LayoutOrder = layoutOrder },
		{
			Checkbox = Roact.createElement(Checkbox, {
				Name = props.name,
				IsSelected = isSelected,
				Size = UDim2.new(0, CheckboxHeight, 0, CheckboxHeight),
				Position = UDim2.new(0, 0, 0.5, -CheckboxHeight / 2),
				OnSelectedStateChanged = props.OnCheckboxClicked
			})
		}
	)
end

return CellCheckbox
