local SquadsCore = script:FindFirstAncestor("SquadsCore")

local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local GetSquadExperienceInviteStore = require(SquadsCore.Stores.GetSquadExperienceInviteStore)

local v = {
	[NetworkingSquads.GetExperienceInvite.Succeeded.name] = function(p)
		GetSquadExperienceInviteStore(false).getExperienceInviteSucceeded(p.responseBody)
	end,
	[NetworkingSquads.VoteForExperienceInvite.Succeeded.name] = function(p)
		GetSquadExperienceInviteStore(false).voteForExperienceInviteSucceeded(p.responseBody)
	end
}

local function SignalsSquadMiddleware(callback, _)
	return function(p)
		local v2 = callback(p)

		local v3 = v[p.type]

		if v3 then
			v3(p)
		end

		return v2
	end
end

return SignalsSquadMiddleware
