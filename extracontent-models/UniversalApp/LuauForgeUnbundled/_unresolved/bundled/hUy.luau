local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/geD")
local module2 = require("@luauforge/bundled/hUz")

return function(options, data)
	local v5 = options or {}

	if data.type == module.name then
		return (Cryo.List.join({}, data.devSubs))
	end

	local result

	if data.type == module2.name then
		result = {}

		for k, v6 in pairs(v5) do
			if v6.id == data.devSub.id then
				table.insert(result, data.devSub)
			else
				table.insert(result, v6)
			end
		end
	else
		result = v5
	end

	return result
end
