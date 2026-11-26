local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/gJe")
local module2 = require("@luauforge/bundled/gXL")
local Cryo = require(CorePackages.Packages.Cryo)

return function(options, data)
	local v5 = options or {}
	assert(v5, "")

	local joined = data.type == module.name and { userModerated = data.userModerated } or v5

	if data.type == module2.name then
		local joined2 = Cryo.Dictionary.join(joined or {}, {
			moderationDetail = data.moderationDetail
		})

		joined = Cryo.Dictionary.join(joined, joined2)
	end

	return joined
end
