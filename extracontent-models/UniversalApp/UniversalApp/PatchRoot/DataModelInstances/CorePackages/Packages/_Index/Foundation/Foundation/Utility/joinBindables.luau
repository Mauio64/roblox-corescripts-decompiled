local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function joinBindables(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 9
	-- upvalues: ReactIs (copy), React (copy)
	local t2 = {}
	local t3 = {}
	local v10 = false

	for v11, v12 in t1 do
		if ReactIs.isBinding(v12) then
			t2[v11] = v12
			v10 = true
		else
			t3[v11] = v12
		end
	end

	if not v10 then
		return p1(t3)
	end

	return React.joinBindings(t2):map(function(p2) -- line: 30
		-- upvalues: t3 (copy), p1 (copy)
		local v14 = table.clone(t3)

		for v15, v16 in p2 do
			v14[v15] = v16
		end

		return p1(v14)
	end)
end

return joinBindables
