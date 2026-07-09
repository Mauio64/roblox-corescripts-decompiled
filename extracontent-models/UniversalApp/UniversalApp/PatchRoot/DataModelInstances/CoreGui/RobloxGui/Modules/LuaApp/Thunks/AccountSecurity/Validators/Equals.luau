local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)

return function(p1, p2) -- line: 6
	-- upvalues: Promise (copy)
	return function(p3) -- line: 7
		-- upvalues: p2 (copy), Promise (copy), p1 (copy)
		if p3 == p2 then
			return Promise.resolve(nil)
		end

		return Promise.resolve(p1)
	end
end
