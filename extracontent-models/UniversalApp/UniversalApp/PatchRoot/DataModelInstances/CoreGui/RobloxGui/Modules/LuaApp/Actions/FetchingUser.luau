local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Common = Modules.Common
local Action = require(Common.Action)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)

return Action(script.Name, function(p1) -- line: 8
	-- upvalues: RetrievalStatus (copy)
	return {
		userId = p1,
		status = RetrievalStatus.Fetching
	}
end)
