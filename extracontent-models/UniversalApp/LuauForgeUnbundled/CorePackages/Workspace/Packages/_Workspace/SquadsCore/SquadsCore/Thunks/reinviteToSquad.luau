local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Loggers").Logger
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")

local v5 = logger.new(logger, "SquadsCore")

return function(p2, callback)
	return function(object)
		return object:dispatch(NetworkingSquads.ReinviteToSquad.API({ squadId = p2 })):catch(function(p3)
			v5:warning(
				"Error reinviting parent channel participants to squad: {}",
				not p3.StatusCode and -1 or p3.StatusCode
			)

			callback(object, { hideCancelButton = true, promptType = SquadPromptType.Error })

			return Promise.reject(p3)
		end)
	end
end
