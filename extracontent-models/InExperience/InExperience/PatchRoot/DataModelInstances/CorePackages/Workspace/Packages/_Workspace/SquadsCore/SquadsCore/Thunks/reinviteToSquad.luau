local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local Promise = require(parent.Promise)

local v = Logger.new(Logger, "SquadsCore")

return function(squadId: string, callback)
	return function(object)
		return object:dispatch(NetworkingSquads.ReinviteToSquad.API({ squadId = squadId })):catch(function(p)
			v:warning(
				"Error reinviting parent channel participants to squad: {}",
				not p.StatusCode and -1 or p.StatusCode
			)

			callback(object, { hideCancelButton = true, promptType = SquadPromptType.Error })

			return Promise.reject(p)
		end)
	end
end
