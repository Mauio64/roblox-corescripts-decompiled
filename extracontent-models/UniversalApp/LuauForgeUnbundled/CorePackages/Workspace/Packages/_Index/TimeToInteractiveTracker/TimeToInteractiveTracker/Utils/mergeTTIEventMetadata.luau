require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local function mergeTTIEventMetadata(p2, items)
	local clone = table.clone(p2)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

return mergeTTIEventMetadata
