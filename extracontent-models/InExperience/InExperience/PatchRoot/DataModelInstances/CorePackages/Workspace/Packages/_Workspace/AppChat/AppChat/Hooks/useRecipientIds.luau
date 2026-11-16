local parent = script:FindFirstAncestor("AppChat").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(p)
	local v = useSelector(function(p2)
		return (tonumber(p2.LocalUserId))
	end)

	local result = {}

	for _, v2 in p and p.participants or {} do
		local v3 = tonumber(v2)

		if v3 and v3 ~= v then
			table.insert(result, v3)
		end
	end

	return result
end
