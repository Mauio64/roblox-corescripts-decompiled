local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local Promise = require(parent.Promise)

local v = Logger.new(Logger, "SquadsCore")

return function()
	return function(object)
		return object:dispatch(NetworkingSquads.GetSquadActive.API({})):catch(function(p)
			v:warning("Error fetching active squad: {}", not p.StatusCode and -1 or p.StatusCode)
			return Promise.reject(p)
		end)
	end
end
