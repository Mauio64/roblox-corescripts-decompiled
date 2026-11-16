local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")
local GetSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetSquadExperienceInviteStore")

local v5 = {
	[NetworkingSquads.GetExperienceInvite.Succeeded.name] = function(p2)
		GetSquadExperienceInviteStore(false).getExperienceInviteSucceeded(p2.responseBody)
	end,
	[NetworkingSquads.VoteForExperienceInvite.Succeeded.name] = function(p2)
		GetSquadExperienceInviteStore(false).voteForExperienceInviteSucceeded(p2.responseBody)
	end
}

local function SignalsSquadMiddleware(callback, p2)
	return function(p3)
		local v6 = callback(p3)

		local v7 = v5[p3.type]

		if v7 then
			v7(p3)
		end

		return v6
	end
end

return SignalsSquadMiddleware
