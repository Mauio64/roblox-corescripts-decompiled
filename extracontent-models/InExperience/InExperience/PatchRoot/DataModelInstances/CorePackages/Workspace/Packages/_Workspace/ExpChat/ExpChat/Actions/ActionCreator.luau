local Parent = script:FindFirstAncestor("ExpChat").Parent
local Cryo = require(Parent.Cryo)

return function(s1: string, p1: ((...any) -> ...any)) -- line: 5
	-- upvalues: Cryo (copy)
	return function(...) -- line: 9
		-- upvalues: s1 (copy), p1 (copy), Cryo (copy)
		local t1 = {
			type = s1
		}
		local v6 = p1(...)

		return (Cryo.Dictionary.union(v6, t1))
	end
end
