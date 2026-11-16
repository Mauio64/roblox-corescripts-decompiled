local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local function useTypedQueryBinding(value: string?)
	local v, v2 = React.useBinding(value or "")
	local ref = React.useRef({})

	React.useEffect(function()
		local v3 = value or ""
		local current = ref.current
		local index = table.find(current, v3)

		if index == nil then
			table.clear(current)

			if v:getValue() ~= v3 then
				v2(v3)
			end
		else
			for _ = 1, index do
				table.remove(current, 1)
			end
		end
	end, { value })

	return v, (React.useCallback(function(p: string)
		table.insert(ref.current, p)
		v2(p)
	end, { v2 }))
end

return useTypedQueryBinding
