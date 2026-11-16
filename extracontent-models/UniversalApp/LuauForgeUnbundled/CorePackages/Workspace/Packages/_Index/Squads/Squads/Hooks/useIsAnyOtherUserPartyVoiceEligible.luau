local Players = game:GetService("Players")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local react = dependencies.React
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector

local getFFlagEnablePartyVoiceOnlyForEligibleUsers = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").GetFFlagEnablePartyVoiceOnlyForEligibleUsers

local getFStringPartyVoiceEligibilityAllowList = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").GetFStringPartyVoiceEligibilityAllowList

function LUAUFORGE_MODULE_GLOBALS_hji_getIsUserWhitelisted(p2): boolean
	for k in getFStringPartyVoiceEligibilityAllowList():gmatch("%d+") do
		if tonumber(k) == p2 then
			return true
		end
	end

	return false
end

function LUAUFORGE_MODULE_GLOBALS_hji_useIsAnyOtherUserPartyVoiceEligible()
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	local v5 = useCurrentSquadSelector()
	local v6 = react.useMemo(function()
		if v5 then
			return v5.members
		end

		return {}
	end, { v5 })

	return react.useMemo(function(): boolean
		if userId ~= 0 then
			for i, v7 in ipairs(v6) do
				if
					v7.userId ~= userId
					and (v7.partyVoiceEligible or LUAUFORGE_MODULE_GLOBALS_hji_getIsUserWhitelisted(v7.userId))
				then
					return true
				end
			end
		end

		return false
	end, { userId, v6 })
end

if getFFlagEnablePartyVoiceOnlyForEligibleUsers() then
	return LUAUFORGE_MODULE_GLOBALS_hji_useIsAnyOtherUserPartyVoiceEligible
end

return function(): boolean
	return true
end
