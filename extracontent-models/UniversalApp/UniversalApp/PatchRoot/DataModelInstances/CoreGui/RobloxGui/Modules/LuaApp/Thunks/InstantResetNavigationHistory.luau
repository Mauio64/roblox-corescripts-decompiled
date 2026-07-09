local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)

return function(p1, p2) -- line: 4
	-- upvalues: ResetNavigationHistory (copy)
	return function(p3) -- line: 5
		-- upvalues: ResetNavigationHistory (copy), p1 (copy), p2 (copy)
		p3:dispatch(ResetNavigationHistory(p1, p2))
		p3:flush()
	end
end
