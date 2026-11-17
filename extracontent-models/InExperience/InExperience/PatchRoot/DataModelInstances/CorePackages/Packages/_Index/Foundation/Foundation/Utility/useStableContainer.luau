local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local function useStableContainer()
	local v = React.useMemo(function()
		return Instance.new("Folder")
	end, {})

	React.useEffect(function()
		return function()
			v:Destroy()
		end
	end, { v })

	return v, (React.useCallback(function(parent2)
		v.Parent = parent2
	end, { v }))
end

return useStableContainer
