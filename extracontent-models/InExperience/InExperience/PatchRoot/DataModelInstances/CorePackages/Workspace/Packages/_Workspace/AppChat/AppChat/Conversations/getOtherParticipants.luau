local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)

return function(p, p2)
	if p and p.participants then
		return Cryo.List.filter(p.participants, function(p3): boolean
			return tostring(p3) ~= tostring(p2)
		end)
	end

	return {}
end
