local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local function useAbsoluteSize(callback)
	local state, setState = React.useState(Vector2.zero)

	return state, (React.useCallback(function(p)
		setState(p.AbsoluteSize)

		if callback then
			callback(p)
		end
	end, { callback }))
end

return useAbsoluteSize
