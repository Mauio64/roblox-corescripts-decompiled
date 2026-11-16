local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local loading = module2.Loading
local iconSize = module2.Enums.IconSize

local function WizardSpinner()
	return module.createElement(loading, {
		size = iconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return WizardSpinner
