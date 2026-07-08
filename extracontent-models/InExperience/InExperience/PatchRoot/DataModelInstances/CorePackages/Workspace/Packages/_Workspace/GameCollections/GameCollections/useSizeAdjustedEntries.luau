local Parent = script:FindFirstAncestor("GameCollections").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)

return function(t1: {[any]: any}, n1: number?, n2: number?) -- line: 7
	-- upvalues: React (copy), Cryo (copy)
	return React.useMemo(function() -- line: 8
		-- upvalues: t1 (copy), Cryo (copy), n1 (copy), n2 (copy)
		local t2 = {}
		local v8 = false

		for _, v10 in t1 do
			local spanOverride = v10.spanOverride

			if not spanOverride then
				table.insert(t2, v10)
			else
				v8 = true

				local v12 = spanOverride.colSpan or 1
				local v13 = spanOverride.rowSpan or 1

				table.insert(t2, Cryo.Dictionary.join(v10, {
					sizeOverride = UDim2.new(v12, (n1 or 0) * (v12 - 1), v13, (n2 or 0) * (v13 - 1))
				}))
			end
		end

		if not v8 then
			return t1
		end

		return t2
	end, {
		t1,
		n1,
		n2
	})
end
