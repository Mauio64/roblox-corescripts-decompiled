local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)
local useDebounce = require(script.Parent.useDebounce)

local function useDebouncedState(p1, n1: number?) -- line: 9
	-- upvalues: React (copy), useDebounce (copy)
	local v7, v8 = React.useState(p1)

	return useDebounce(v7, n1), v8
end

return useDebouncedState
