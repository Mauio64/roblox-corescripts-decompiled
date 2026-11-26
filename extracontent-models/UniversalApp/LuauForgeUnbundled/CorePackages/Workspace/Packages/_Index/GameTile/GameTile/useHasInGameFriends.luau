local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

local function useHasInGameFriends(p2, p3, items)
	return (React.useMemo(function(): boolean
		if not (p2 and p3 and items) then
			return false
		end

		for k, item in pairs(items) do
			if item == p2 then
				continue
			end

			local v5 = p3[item]

			if v5 and v5.isFriend then
				return true
			end
		end

		return false
	end, { p2, p3, items }))
end

return useHasInGameFriends
