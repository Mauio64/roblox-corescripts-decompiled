local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local function useTypedQueryBinding(value)
	local v5, v6 = React.useBinding(value or "")
	local ref = React.useRef({})

	React.useEffect(function()
		local v7 = value or ""
		local current = ref.current
		local index = table.find(current, v7)

		if index == nil then
			table.clear(current)

			if v5:getValue() ~= v7 then
				v6(v7)
			end
		else
			for i = 1, index do
				table.remove(current, 1)
			end
		end
	end, { value })

	return v5, (React.useCallback(function(p2)
		table.insert(ref.current, p2)
		v6(p2)
	end, { v6 }))
end

return useTypedQueryBinding
