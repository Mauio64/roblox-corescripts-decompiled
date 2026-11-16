local parent = script:FindFirstAncestor("GameJoinCard").Parent

require(parent.DataHydration)

local function containsAction(p, p2: string): boolean
	if p == nil or p.actions == nil then
		return false
	end

	for _, action in p.actions do
		if action.type == p2 then
			return true
		end
	end

	return false
end

return containsAction
