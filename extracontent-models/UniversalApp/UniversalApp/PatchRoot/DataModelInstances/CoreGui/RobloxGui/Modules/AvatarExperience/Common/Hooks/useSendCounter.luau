local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function() -- line: 8
	-- upvalues: useRoactService (copy), Analytics (copy), Constants (copy)
	local v5 = useRoactService(Analytics)

	return function(s1: string) -- line: 10
		-- upvalues: v5 (copy), Constants (copy)
		v5.sendCounter(Constants.Counter.PREFIX .. s1)
	end
end
