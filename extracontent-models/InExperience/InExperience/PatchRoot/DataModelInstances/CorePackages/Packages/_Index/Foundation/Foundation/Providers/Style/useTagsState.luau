local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function useTagsState() -- line: 5
	-- upvalues: React (copy)
	local v4, v5 = React.useState({})

	return v4, (React.useCallback(function(...) -- line: 8
		-- upvalues: v5 (copy)
		local t1 = {}

		for _, v8 in { ... } do
			for _, v10 in (string.split(v8, " ")) do
				table.insert(t1, v10)
			end
		end

		v5(function(p1) -- line: 20
			-- upvalues: t1 (copy)
			local v12 = false

			for _, v14 in t1 do
				if p1[v14] ~= true then
					v12 = true

					break
				end
			end

			if v12 then
				local v15 = table.clone(p1)

				for _, v17 in t1 do
					v15[v17] = true
				end

				return v15
			end

			return p1
		end)
	end, { v5 }))
end

return useTagsState
