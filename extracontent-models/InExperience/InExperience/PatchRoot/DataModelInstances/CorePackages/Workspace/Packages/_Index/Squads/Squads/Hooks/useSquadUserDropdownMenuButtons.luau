local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local dependencies = require(Squads.dependencies)

local react = dependencies.React
local sharedFlags = dependencies.SharedFlags
local isPresenceJoinable = require(Squads.Common.isPresenceJoinable)

local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if FFlagSquadsPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Constants = require(parent.SquadsCore.Constants)
local Hooks = require(parent.SquadsCore.Hooks)

local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = Hooks.useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = Hooks.useIsCurrentSquadPartyVoiceEligible
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useSelector = dependencies.Hooks.useSelector

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice

local function useSquadUserDropdownMenuButtons(p, flag: boolean)
	local v = useLocalUserId()
	local v2 = tostring(v) == tostring(p)

	local v3 = nil

	local voiceIneligibleButton = false
	local muteVoiceButton = false
	local v4

	if getFFlagEnableCrossExpVoice() then
		local v5

		if p then
			v5 = tonumber(p)
		end

		v3 = useBackgroundExperience()
		v4 = react.useMemo(function()
			return if v3 then v3.voiceChannelId else nil
		end, { v3 })

		if v5 then
			local v6 = useIsLocalPlayerPartyVoiceEligible()
			local v7 = useIsUserPartyVoiceEligible(v5)
			local v8 = useIsCurrentSquadPartyVoiceEligible() == true
			voiceIneligibleButton = v8 and v6 and not v7
			muteVoiceButton = v6 and v8 and v7 and not v2
		end
	else
		v4 = nil
	end

	local v5 = react.useContext(SquadExternalContractContext)
	local v6 = useCurrentSquadParentChannelId()
	local v7 = v5.useGetConversationFromId(v6 or "")
	local v8 = react.useCallback(function(p2)
		return p2.Squad.Presence.byUserId[tostring(p)]
	end, { p })
	local v9

	if FFlagSquadsPresenceStoreMigration then
		v9 = useGetPresenceByUserId((tostring(p)))
	else
		v9 = useSelector(v8)
	end

	return react.useMemo(function()
		local v10 = {
			VoiceIneligibleButton = voiceIneligibleButton,
			JoinButton = isPresenceJoinable(v9),
			RemoveUserButton = 0,
			ViewProfileButton = 0,
			ReportButton = 0,
			MuteVoiceButton = 0
		}
		local removeUserButton = v7

		if removeUserButton then
			if v7.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE then
				removeUserButton = v7.initiator == v
			else
				removeUserButton = false
			end
		end

		v10.RemoveUserButton = removeUserButton

		v10.ViewProfileButton = not flag
		v10.ReportButton = v4 and not v2
		v10.MuteVoiceButton = muteVoiceButton

		local result = {}

		for k, v11 in v10 do
			if v11 then
				table.insert(result, k)
			end
		end

		return result
	end, { voiceIneligibleButton, flag, v4, v2, v9, v7, v, muteVoiceButton })
end

return useSquadUserDropdownMenuButtons
