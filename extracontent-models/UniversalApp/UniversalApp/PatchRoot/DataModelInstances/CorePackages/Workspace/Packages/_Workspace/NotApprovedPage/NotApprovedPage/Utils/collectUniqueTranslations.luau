local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local Cryo = require(Parent.Cryo)

return function(t1: {[any]: any}, t2: {[any]: any}?) -- line: 20
	-- upvalues: Cryo (copy)
	local t3 = {}

	for _, v7 in t1 do
		local v8 = if not t2 then v7 else t2[v7]

		if v8 and v8 ~= "" then
			t3[v8] = true
		end
	end

	return Cryo.Dictionary.keys(t3)
end
