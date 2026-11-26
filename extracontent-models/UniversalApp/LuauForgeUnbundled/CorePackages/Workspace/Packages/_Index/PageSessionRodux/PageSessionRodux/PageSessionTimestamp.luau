local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PageSessionRodux/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/PageSessionRodux/DiscoveryTypes")

local SetPageSessionTimestamp = require("@game/CorePackages/Workspace/Packages/_Index/PageSessionRodux/PageSessionRodux/SetPageSessionTimestamp")

return function(options, data)
	local v5 = options or {}

	if data.type ~= SetPageSessionTimestamp.name then
		return v5
	end

	v5 = Cryo.Dictionary.join(v5, { [data.page] = data.timestamp })

	return v5
end
