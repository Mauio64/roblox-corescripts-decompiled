local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)

return function(p1) -- line: 6
	-- upvalues: Cryo (copy)
	local t1 = {}

	Cryo.List.map(p1, function(p2) -- line: 8
		-- upvalues: Cryo (copy), t1 (copy)
		Cryo.List.map(p2.otherParticipants, function(p3) -- line: 9
			-- upvalues: t1 (copy)
			t1[p3] = true
		end)
	end)

	return Cryo.Dictionary.keys(t1)
end
