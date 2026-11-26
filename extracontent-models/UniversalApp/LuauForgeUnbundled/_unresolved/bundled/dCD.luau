local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/bundled/dCE")

return function(options, data)
	local v5 = options or {}

	if data.type ~= module.name then
		return v5
	end

	v5 = Dash.assign(v5, { [data.universeId] = data.privateServersEnabled })

	return v5
end
