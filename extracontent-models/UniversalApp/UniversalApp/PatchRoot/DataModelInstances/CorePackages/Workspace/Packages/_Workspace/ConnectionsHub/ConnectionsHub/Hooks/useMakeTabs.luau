local Parent = script:FindFirstAncestor("ConnectionsHub").Parent
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function useMakeTabs(t1: {[any]: any}) -- line: 6
	-- upvalues: useLocalization (copy)
	local t2 = {}

	for _, v7 in t1 do
		t2[v7.id] = v7.textKey
	end

	local v8 = useLocalization(t2)
	local t3 = {}

	for _, v11 in t1 do
		table.insert(t3, {
			id = v11.id,
			text = v8[v11.id]
		})
	end

	return t3
end

return useMakeTabs
