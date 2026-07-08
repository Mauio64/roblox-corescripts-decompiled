local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useRefs(n1: number, p1) -- line: 14
	-- upvalues: React (copy)
	local v6 = React.useRef({})
	local v7 = React.useRef(n1)

	if n1 > #v6.current then
		for _ = 1, n1 - #v6.current do
			local v9 = React.createRef()

			v9.current = p1
			table.insert(v6.current, v9)
		end
	elseif n1 < v7.current then
		for i = n1 + 1, v7.current do
			v6.current[i].current = p1
		end
	end

	v7.current = n1

	return (React.useMemo(function() -- line: 33
		-- upvalues: v6 (copy), n1 (copy)
		return table.move(v6.current, 1, n1, 1, {})
	end, { n1 }))
end

return useRefs
