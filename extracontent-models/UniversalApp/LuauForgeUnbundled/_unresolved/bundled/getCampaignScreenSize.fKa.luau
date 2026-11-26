local module = require("@luauforge/bundled/fKb")
local normalizeScreenSizeForWire = require("@luauforge/bundled/fKc").Utils.normalizeScreenSizeForWire

local default = module.BreakpointConfig.rules.default
local key = default[#default].Key

local function getCampaignScreenSize(p2)
	for k, v5 in default do
		if p2 <= v5.maxWidth then
			return normalizeScreenSizeForWire(v5.Key)
		end
	end

	return normalizeScreenSizeForWire(key)
end

return getCampaignScreenSize
