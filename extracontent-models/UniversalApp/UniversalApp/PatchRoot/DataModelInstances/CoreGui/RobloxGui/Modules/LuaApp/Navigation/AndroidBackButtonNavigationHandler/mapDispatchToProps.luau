local Modules = script:FindFirstAncestor("Modules")
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)

return function(p1) -- line: 4
	-- upvalues: NavigateBack (copy)
	return {
		navigateBackInAppRoute = function() -- line: 6
			-- upvalues: p1 (copy), NavigateBack (copy)
			p1(NavigateBack())
		end
	}
end
