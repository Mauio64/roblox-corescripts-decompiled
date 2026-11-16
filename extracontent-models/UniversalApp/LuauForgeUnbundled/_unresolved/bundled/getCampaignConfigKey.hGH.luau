local module = require("@luauforge/bundled/hGG")

local function getCampaignConfigKey(p2)
	return `{module.ConfigKey}_{p2}`
end

return getCampaignConfigKey
