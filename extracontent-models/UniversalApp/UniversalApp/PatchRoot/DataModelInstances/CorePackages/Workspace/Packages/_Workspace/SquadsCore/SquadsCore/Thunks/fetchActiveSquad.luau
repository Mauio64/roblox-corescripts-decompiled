local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local Logger = require(SquadsCoreParent.Loggers).Logger
local Promise = require(SquadsCoreParent.Promise)
local v6 = Logger:new("SquadsCore")

return function() -- line: 11
	-- upvalues: NetworkingSquads (copy), v6 (copy), Promise (copy)
	return function(p1) -- line: 12
		-- upvalues: NetworkingSquads (copy), v6 (copy), Promise (copy)
		return p1:dispatch(NetworkingSquads.GetSquadActive.API({})):catch(function(p2) -- line: 13
			-- upvalues: v6 (copy), Promise (copy)
			v6:warning("Error fetching active squad: {}", not p2.StatusCode and -1 or p2.StatusCode)

			return Promise.reject(p2)
		end)
	end
end
