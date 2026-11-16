local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

local function useTagsState()
	local state, setState = React.useState({})

	return state, (React.useCallback(function(...)
		local v = {}

		for _, v2 in { ... } do
			local v3 = string.split(v2, " ")

			for _, v4 in v3 do
				table.insert(v, v4)
			end
		end

		setState(function(p)
			local v2 = false

			for _, v3 in v do
				if p[v3] ~= true then
					v2 = true
					break
				end
			end

			if not v2 then
				return p
			end

			local clone = table.clone(p)

			for _, v3 in v do
				clone[v3] = true
			end

			return clone
		end)
	end, { setState }))
end

return useTagsState
