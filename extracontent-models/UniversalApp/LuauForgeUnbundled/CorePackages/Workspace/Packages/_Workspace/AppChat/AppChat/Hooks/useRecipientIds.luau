local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

return function(p2)
	local v5 = useSelector(function(p3)
		return (tonumber(p3.LocalUserId))
	end)

	local result = {}

	for k, v6 in p2 and p2.participants or {} do
		local v7 = tonumber(v6)

		if v7 and v7 ~= v5 then
			table.insert(result, v7)
		end
	end

	return result
end
