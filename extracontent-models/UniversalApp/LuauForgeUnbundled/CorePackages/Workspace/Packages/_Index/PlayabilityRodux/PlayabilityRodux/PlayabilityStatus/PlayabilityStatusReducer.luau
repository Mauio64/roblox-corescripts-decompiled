local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/AppCommonLib").Immutable
local SetPlayabilityStatus = require("@game/CorePackages/Workspace/Packages/_Index/PlayabilityRodux/PlayabilityRodux/PlayabilityStatus/SetPlayabilityStatus")

return function(options, p2)
	local v5 = options or {}

	if p2.type == SetPlayabilityStatus.name then
		v5 = immutable.JoinDictionaries(v5, p2.playabilityStatus)
	end

	return v5
end
