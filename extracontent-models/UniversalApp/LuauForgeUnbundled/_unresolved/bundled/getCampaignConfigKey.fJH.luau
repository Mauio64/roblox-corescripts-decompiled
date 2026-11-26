local module = require("@luauforge/bundled/fJG")

local function getCampaignConfigKey(p2)
	return `{module.ConfigKey}_{p2}`
end

return getCampaignConfigKey
