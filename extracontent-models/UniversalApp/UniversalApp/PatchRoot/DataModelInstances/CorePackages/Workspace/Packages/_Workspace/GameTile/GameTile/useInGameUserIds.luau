local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)

local function useInGameUserIds(s1: string, t1: {[any]: any}) -- line: 5
	-- upvalues: React (copy)
	return React.useMemo(function() -- line: 6
		-- upvalues: s1 (copy), t1 (copy)
		if not s1 or not t1 then
			return {}
		end

		local t2 = {}

		for v7, _ in t1 do
			if v7 ~= s1 then
				table.insert(t2, v7)
			end
		end

		return t2
	end, {
		s1,
		t1
	})
end

return useInGameUserIds
