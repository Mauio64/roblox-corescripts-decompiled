require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")

local function containsAction(p2, p3): boolean
	if p2 == nil or p2.actions == nil then
		return false
	end

	for k, action in p2.actions do
		if action.type == p3 then
			return true
		end
	end

	return false
end

return containsAction
