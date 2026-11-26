local module = require("@luauforge/bundled/dTN")
local normalizeScreenSizeForWire = require("@luauforge/bundled/dTT").Utils.normalizeScreenSizeForWire

local function getItemDetailsPageConfigKey(p2, p3, p4, p5)
	local screenSizeForWire = normalizeScreenSizeForWire(p4)
	local formatted = `{module.ItemDetailsSduiConfigKeyPrefix}-{p2}-{p3}-{screenSizeForWire}`

	if p5 == nil or p5 == "" then
		return formatted
	end

	return `{formatted}-{p5}`
end

return getItemDetailsPageConfigKey
