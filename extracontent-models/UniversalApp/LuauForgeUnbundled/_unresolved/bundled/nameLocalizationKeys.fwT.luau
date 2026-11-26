local module = require("@luauforge/bundled/dGJ")

local nameLocalizationKeys = {}

for k, v5 in pairs(module) do
	nameLocalizationKeys[k] = v5.nameLocalizationKey
end

return nameLocalizationKeys
