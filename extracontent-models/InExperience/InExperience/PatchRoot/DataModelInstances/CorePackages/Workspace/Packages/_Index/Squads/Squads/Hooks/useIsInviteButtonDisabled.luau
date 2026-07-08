local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)
local Cryo = dependencies.Cryo
local React = dependencies.React

return function(n1: number, p1, p2) -- line: 15
	-- upvalues: React (copy), Cryo (copy)
	return React.useMemo(function() -- line: 16
		-- upvalues: p2 (copy), n1 (copy), Cryo (copy), p1 (copy)
		if p2 == nil then
			return n1 == 0
		end

		local v8 = Cryo.List.toSet(p2)

		if n1 < #p2 then
			return false
		end

		for v9, _ in p1 do
			if not v8[tostring(v9)] then
				return false
			end
		end

		return true
	end, {
		n1,
		p1,
		p2
	})
end
