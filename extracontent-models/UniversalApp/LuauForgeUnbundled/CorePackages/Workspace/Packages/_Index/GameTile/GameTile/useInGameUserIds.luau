local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

local function useInGameUserIds(p2, items)
	return React.useMemo(function()
		if not (p2 and items) then
			return {}
		end

		local result = {}

		for k, item in items do
			if k ~= p2 then
				table.insert(result, k)
			end
		end

		return result
	end, { p2, items })
end

return useInGameUserIds
