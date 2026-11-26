local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local react = dependencies.React
local sharedFlags = dependencies.SharedFlags
local isPresenceJoinable = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/isPresenceJoinable")

local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local useGetPresenceByUserId

if fFlagSquadsPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Constants")
local Hooks = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks")

local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = Hooks.useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = Hooks.useIsCurrentSquadPartyVoiceEligible
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useSelector = dependencies.Hooks.useSelector

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice

local function useSquadUserDropdownMenuButtons(p2, p3)
	local v5 = useLocalUserId()
	local v6 = tostring(v5) == tostring(p2)

	local v7 = nil

	local v8 = false
	local v9 = false
	local v10

	if getFFlagEnableCrossExpVoice() then
		local v11 = if p2 then tonumber(p2) else nil

		v7 = useBackgroundExperience()
		v10 = react.useMemo(function()
			if v7 then
				return v7.voiceChannelId
			end

			return nil
		end, { v7 })

		if v11 then
			local v12 = useIsLocalPlayerPartyVoiceEligible()
			local v13 = useIsUserPartyVoiceEligible(v11)
			local v14 = useIsCurrentSquadPartyVoiceEligible() == true
			v8 = v14 and v12 and not v13
			v9 = v12 and v14 and v13 and not v6
		end
	else
		v10 = nil
	end

	local v11 = react.useContext(squadExternalContractContext)
	local v12 = useCurrentSquadParentChannelId()
	local v13 = v11.useGetConversationFromId(v12 or "")
	local v14 = react.useCallback(function(p4)
		return p4.Squad.Presence.byUserId[tostring(p2)]
	end, { p2 })
	local v15

	if fFlagSquadsPresenceStoreMigration then
		v15 = useGetPresenceByUserId((tostring(p2)))
	else
		v15 = useSelector(v14)
	end

	return react.useMemo(function()
		local v16 = {
			VoiceIneligibleButton = v8,
			JoinButton = isPresenceJoinable(v15),
			RemoveUserButton = 0,
			ViewProfileButton = 0,
			ReportButton = 0,
			MuteVoiceButton = 0
		}
		local v17 = v13

		if v17 then
			v17 = v13.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v13.initiator == v5
		end

		v16.RemoveUserButton = v17

		v16.ViewProfileButton = not p3
		v16.ReportButton = v10 and not v6
		v16.MuteVoiceButton = v9

		local result = {}

		for k, v18 in v16 do
			if v18 then
				table.insert(result, k)
			end
		end

		return result
	end, { v8, p3, v10, v6, v15, v13, v5, v9 })
end

return useSquadUserDropdownMenuButtons
