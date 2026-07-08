local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)

return function(t1: {[any]: any}?, p1) -- line: 6
	-- upvalues: Cryo (copy)
	if t1 and t1.participants then
		return Cryo.List.filter(t1.participants, function(p2) -- line: 8
			-- upvalues: p1 (copy)
			return tostring(p2) ~= tostring(p1)
		end)
	end

	return {}
end
