local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/SharedFlags").FFlagLuaAppAddTestIdsForArrow

return {
	getTestId = function(p2, p3)
		if not (fFlagLuaAppAddTestIdsForArrow and p2) then
			return nil
		end

		local formatted = `data-testid=--{p2}`

		if p3 then
			formatted = `{formatted}-{tostring(p3)}`
		end

		return formatted
	end
}
