local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Loggers").Logger
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")

local v5 = logger.new(logger, "SquadsCore")

return function()
	return function(object)
		return object:dispatch(NetworkingSquads.GetSquadActive.API({})):catch(function(p2)
			v5:warning("Error fetching active squad: {}", not p2.StatusCode and -1 or p2.StatusCode)
			return Promise.reject(p2)
		end)
	end
end
