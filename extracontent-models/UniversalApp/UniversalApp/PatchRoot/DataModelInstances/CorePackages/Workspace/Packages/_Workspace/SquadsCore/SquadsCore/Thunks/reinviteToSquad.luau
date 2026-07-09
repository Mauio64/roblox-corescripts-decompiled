local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local Logger = require(SquadsCoreParent.Loggers).Logger
local Promise = require(SquadsCoreParent.Promise)
local v7 = Logger:new("SquadsCore")

return function(s1: string, p1: ((...any) -> ...any)) -- line: 12
	-- upvalues: NetworkingSquads (copy), v7 (copy), SquadPromptType (copy), Promise (copy)
	return function(p2) -- line: 13
		-- upvalues: NetworkingSquads (copy), s1 (copy), v7 (copy), p1 (copy), SquadPromptType (copy), Promise (copy)
		return p2:dispatch(NetworkingSquads.ReinviteToSquad.API({
			squadId = s1
		})):catch(function(p3) -- line: 14
			-- upvalues: v7 (copy), p1 (copy), p2 (copy), SquadPromptType (copy), Promise (copy)
			v7:warning("Error reinviting parent channel participants to squad: {}", not p3.StatusCode and -1 or p3.StatusCode)
			p1(p2, {
				hideCancelButton = true,
				promptType = SquadPromptType.Error
			})

			return Promise.reject(p3)
		end)
	end
end
