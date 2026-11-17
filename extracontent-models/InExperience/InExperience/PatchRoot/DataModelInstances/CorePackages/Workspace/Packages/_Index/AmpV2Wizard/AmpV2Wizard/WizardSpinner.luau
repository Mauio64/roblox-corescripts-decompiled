local parent = script:FindFirstAncestor("AmpV2Wizard").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

local function WizardSpinner()
	return React.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return WizardSpinner
