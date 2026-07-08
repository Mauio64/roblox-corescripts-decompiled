local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local Checkbox = require(script.Parent.Checkbox)
local _ = Constants.DefaultFontSize.MainWindow
local _ = Constants.Color.Text
local _ = Constants.Font.MainWindow
local _ = Constants.Font.MainWindowBold
local CheckboxHeight = Constants.UtilityBarFormatting.CheckboxHeight
local _ = Constants.UtilityBarFormatting.CheckboxInnerPadding

local function CellCheckbox(t1: {[any]: any}) -- line: 23
	-- upvalues: Roact (copy), Checkbox (copy), CheckboxHeight (copy)
	local isSelected = t1.isSelected
	local size = t1.size
	local pos = t1.pos
	local t1LayoutOrder = t1.LayoutOrder

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		Position = pos,
		LayoutOrder = t1LayoutOrder
	}, {
		Checkbox = Roact.createElement(Checkbox, {
			Name = t1.name,
			IsSelected = isSelected,
			Size = UDim2.new(0, CheckboxHeight, 0, CheckboxHeight),
			Position = UDim2.new(0, 0, 0.5, -CheckboxHeight / 2),
			OnSelectedStateChanged = t1.OnCheckboxClicked
		})
	})
end

return CellCheckbox
