local parent = script:FindFirstAncestor("RoactUtils").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow

return {
	getTestId = function(p: string?, p2)
		if not (FFlagLuaAppAddTestIdsForArrow and p) then
			return nil
		end

		local formatted = `data-testid=--{p}`

		if p2 then
			formatted = `{formatted}-{tostring(p2)}`
		end

		return formatted
	end
}
