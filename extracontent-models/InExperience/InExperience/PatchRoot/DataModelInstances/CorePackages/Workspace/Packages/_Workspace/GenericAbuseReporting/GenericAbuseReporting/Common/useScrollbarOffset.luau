local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local function useScrollbarOffset(vector2: Vector2, vector2_2: Vector2): number
	local state, setState = React.useState(false)

	React.useEffect(function()
		if vector2.Y > vector2_2.Y then
			setState(true)
		else
			setState(false)
		end
	end, { vector2, vector2_2 })
	return if state then 16 else 0
end

return useScrollbarOffset
