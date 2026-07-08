local Parent = script:FindFirstAncestor("AppChat").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function(p1) -- line: 6
	-- upvalues: useSelector (copy)
	local v4 = useSelector(function(p2) -- line: 7
		return (tonumber(p2.LocalUserId))
	end)
	local t1 = {}

	for _, v7 in p1 and p1.participants or {} do
		local num = tonumber(v7)

		if num and num ~= v4 then
			table.insert(t1, num)
		end
	end

	return t1
end
