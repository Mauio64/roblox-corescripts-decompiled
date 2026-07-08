local Parent = script:FindFirstAncestor("RoactUtils").Parent
local FFlagLuaAppAddTestIdsForArrow = require(Parent.SharedFlags).FFlagLuaAppAddTestIdsForArrow

return {
	getTestId = function(s1: string?, p1) -- line: 19
		-- upvalues: FFlagLuaAppAddTestIdsForArrow (copy)
		if not FFlagLuaAppAddTestIdsForArrow then
			return nil
		end

		if not s1 then
			return nil
		end

		local v5 = `data-testid=--{ s1 }`

		if p1 then
			v5 = `{ v5 }-{ tostring(p1) }`
		end

		return v5
	end
}
