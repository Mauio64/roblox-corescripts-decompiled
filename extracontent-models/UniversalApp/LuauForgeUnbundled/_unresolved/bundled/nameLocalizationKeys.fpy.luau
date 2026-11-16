local module = require("@luauforge/bundled/dDE")

local nameLocalizationKeys = {}

for k, v5 in pairs(module) do
	nameLocalizationKeys[k] = v5.nameLocalizationKey
end

return nameLocalizationKeys
