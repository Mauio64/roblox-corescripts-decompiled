local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)

local function useHasInGameFriends(p1, p2, p3) -- line: 7
	-- upvalues: React (copy)
	return (React.useMemo(function() -- line: 8
		-- upvalues: p1 (copy), p2 (copy), p3 (copy)
		if not p1 or (not p2 or not p3) then
			return false
		end

		for _, v in pairs(p3) do
			if v == p1 then
				continue
			end

			local v9 = p2[v]

			if v9 and v9.isFriend then
				return true
			end
		end

		return false
	end, {
		p1,
		p2,
		p3
	}))
end

return useHasInGameFriends
