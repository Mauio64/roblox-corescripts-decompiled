local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Logger"):new("updateTTIEventMetadata")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local mergeTTIEventMetadata = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/mergeTTIEventMetadata")

return function(callback)
	return function(p2, p3)
		callback(function(p4)
			local v6 = p4[p2]

			if v6 == nil then
				v5:warning(`called before trackStart for eventName={p2}`)
				return p4
			end

			local clone = table.clone(p4)

			local clone2 = table.clone(v6)
			clone2.metadata = mergeTTIEventMetadata(v6.metadata, p3)
			clone[p2] = clone2

			return clone
		end)
	end
end
