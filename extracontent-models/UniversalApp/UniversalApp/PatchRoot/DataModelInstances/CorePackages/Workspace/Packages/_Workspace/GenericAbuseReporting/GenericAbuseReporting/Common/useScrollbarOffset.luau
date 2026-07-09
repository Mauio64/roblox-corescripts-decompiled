local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)

local function useScrollbarOffset(vector2: Vector2, vector2_2: Vector2) -- line: 8
	-- upvalues: React (copy)
	local v6, v7 = React.useState(false)

	React.useEffect(function() -- line: 11
		-- upvalues: vector2 (copy), vector2_2 (copy), v7 (copy)
		if vector2.Y > vector2_2.Y then
			v7(true)

			return
		end

		v7(false)
	end, {
		vector2,
		vector2_2
	})

	if v6 then
		return 16
	end

	return 0
end

return useScrollbarOffset
