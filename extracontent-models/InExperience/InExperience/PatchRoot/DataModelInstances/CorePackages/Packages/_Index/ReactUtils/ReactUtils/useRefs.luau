local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useRefs(current: number, current2)
	local ref = React.useRef({})

	local ref2 = React.useRef(current)

	if #ref.current < current then
		for _ = 1, current - #ref.current do
			local ref3 = React.createRef()
			ref3.current = current2
			table.insert(ref.current, ref3)
		end
	elseif current < ref2.current then
		for i = current + 1, ref2.current do
			ref.current[i].current = current2
		end
	end

	ref2.current = current

	return (React.useMemo(function()
		return table.move(ref.current, 1, current, 1, {})
	end, { current }))
end

return useRefs
