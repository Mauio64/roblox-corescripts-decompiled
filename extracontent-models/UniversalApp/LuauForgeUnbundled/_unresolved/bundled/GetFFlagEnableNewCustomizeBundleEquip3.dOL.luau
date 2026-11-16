local module = require("@luauforge/bundled/dOc")

game:DefineFastFlag("EnableNewCustomizeBundleEquip3", false)

return function()
	return game:GetFastFlag("EnableNewCustomizeBundleEquip3") and module()
end
