local Players = game:GetService("Players")

local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local dependencies = require(Squads.dependencies)

local react = dependencies.React
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector

local Flags = require(parent.SquadsCore.Flags)
local GetFFlagEnablePartyVoiceOnlyForEligibleUsers = Flags.GetFFlagEnablePartyVoiceOnlyForEligibleUsers

local Flags2 = require(parent.SquadsCore.Flags)
local GetFStringPartyVoiceEligibilityAllowList = Flags2.GetFStringPartyVoiceEligibilityAllowList

function getIsUserWhitelisted(p: number): boolean
	for k in GetFStringPartyVoiceEligibilityAllowList():gmatch("%d+") do
		if tonumber(k) == p then
			return true
		end
	end

	return false
end

function useIsAnyOtherUserPartyVoiceEligible()
	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	local v = useCurrentSquadSelector()
	local v2 = react.useMemo(function()
		if v then
			return v.members
		end

		return {}
	end, { v })

	return react.useMemo(function(): boolean
		if userId ~= 0 then
			for _, v3 in ipairs(v2) do
				if v3.userId ~= userId and (v3.partyVoiceEligible or getIsUserWhitelisted(v3.userId)) then
					return true
				end
			end
		end

		return false
	end, { userId, v2 })
end

if GetFFlagEnablePartyVoiceOnlyForEligibleUsers() then
	return useIsAnyOtherUserPartyVoiceEligible
end

return function(): boolean
	return true
end
