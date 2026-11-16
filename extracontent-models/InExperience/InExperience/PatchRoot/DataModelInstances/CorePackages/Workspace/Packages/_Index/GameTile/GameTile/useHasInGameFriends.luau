local parent = script:FindFirstAncestor("GameTile").Parent
local React = require(parent.React)

local function useHasInGameFriends(p, p2, items)
	return (React.useMemo(function(): boolean
		if not (p and p2 and items) then
			return false
		end

		for _, item in pairs(items) do
			if item == p then
				continue
			end

			local v = p2[item]

			if v and v.isFriend then
				return true
			end
		end

		return false
	end, { p, p2, items }))
end

return useHasInGameFriends
