local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor

local module = require("@luauforge/bundled/fsX")

local v5 = {
	[formFactor.COMPACT] = { IconButtonSize = 34 },
	[formFactor.WIDE] = { IconButtonSize = 44 }
}

local function getIconButtonSize(p2)
	local v6 = v5[p2]
	return v6 and v6.IconButtonSize or module.DEFAULT_ICON_BUTTON_SIZE
end

return getIconButtonSize
