local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/gNP")

return function(options, data)
	local v5 = options or {}

	if data.type ~= module.name then
		return v5
	end

	v5 = Cryo.Dictionary.join(v5, { [data.searchUuid] = data.searchTime })

	return v5
end
