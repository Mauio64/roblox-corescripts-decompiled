local module = require("@luauforge/bundled/dzz")
local module2 = require("@luauforge/bundled/dBp")
local module3 = require("@luauforge/bundled/dBq")

return function(options, data)
	local v5 = options or {}

	if data.type == module2.name then
		return (module.Set(v5, data.universeId, {
			canFollow = data.canFollow,
			isFollowed = data.isFollowed
		}))
	end

	if data.type ~= module3.name then
		return v5
	end

	local v6 = v5[data.universeId]

	if v6 then
		local v7 = module.Set(v6, "isFollowed", data.isFollowed)
		v5 = module.Set(v5, data.universeId, v7)
	end

	return v5
end
