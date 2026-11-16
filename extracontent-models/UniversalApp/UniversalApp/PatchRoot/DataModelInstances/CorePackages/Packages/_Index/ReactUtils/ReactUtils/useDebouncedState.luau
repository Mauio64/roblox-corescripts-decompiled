local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local useDebounce = require(script.Parent.useDebounce)

local function useDebouncedState(p, p2: number?)
	local state, setState = React.useState(p)

	return useDebounce(state, p2), setState
end

return useDebouncedState
