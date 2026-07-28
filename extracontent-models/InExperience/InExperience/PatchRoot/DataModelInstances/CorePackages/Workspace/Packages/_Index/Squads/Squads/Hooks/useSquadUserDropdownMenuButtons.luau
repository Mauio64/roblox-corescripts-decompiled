local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local SharedFlags = dependencies.SharedFlags
local FFlagSquadsPresenceStoreMigration = require(SquadsParent.SquadsCore.Flags).FFlagSquadsPresenceStoreMigration
local v10 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v11 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.DataHydration).Presence.PresenceEnums.PresenceType
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local Constants = require(SquadsParent.SquadsCore.Constants)
local Hooks = require(SquadsParent.SquadsCore.Hooks)
local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = Hooks.useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = Hooks.useIsCurrentSquadPartyVoiceEligible
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useSelector = dependencies.Hooks.useSelector
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local getFFlagEnableCrossExpVoiceAbuseReport = SharedFlags.getFFlagEnableCrossExpVoiceAbuseReport

local function useSquadUserDropdownMenuButtons(p1, b1: boolean) -- line: 33
	-- upvalues: useLocalUserId (copy), GetFFlagEnableCrossExpVoice (copy), useBackgroundExperience (copy), React (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsUserPartyVoiceEligible (copy), useIsCurrentSquadPartyVoiceEligible (copy), SquadExternalContractContext (copy), useCurrentSquadParentChannelId (copy), FFlagSquadsPresenceStoreMigration (copy), v10 (copy), useSelector (copy), v11 (copy), PresenceType (copy), Constants (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy)
	local v26 = useLocalUserId()
	local v27 = tostring(v26) == tostring(p1)
	local u28 = nil
	local u29 = nil
	local u30 = false
	local u31 = false

	if GetFFlagEnableCrossExpVoice() then
		local v32 = if not p1 then nil else tonumber(p1)

		u28 = useBackgroundExperience()
		u29 = React.useMemo(function() -- line: 46
			-- upvalues: u28 (ref)
			if u28 then
				return u28.voiceChannelId
			end

			return nil
		end, { u28 })

		if v32 then
			local v33 = useIsLocalPlayerPartyVoiceEligible()
			local v34 = useIsUserPartyVoiceEligible(v32)
			local v35 = useIsCurrentSquadPartyVoiceEligible() == true

			u30 = v35 and (v33 and not v34)
			u31 = v33 and (v35 and (v34 and not v27))
		end
	end

	local v36 = React.useContext(SquadExternalContractContext)
	local v37 = useCurrentSquadParentChannelId()
	local v38 = v36.useGetConversationFromId(v37 or "")
	local v39 = React.useCallback(function(p2) -- line: 69
		-- upvalues: p1 (copy)
		return p2.Squad.Presence.byUserId[tostring(p1)]
	end, { p1 })
	local v40 = if not FFlagSquadsPresenceStoreMigration then useSelector(v39) else v10((tostring(p1)))

	return React.useMemo(function() -- line: 77
		-- upvalues: u30 (ref), v40 (copy), FFlagSquadsPresenceStoreMigration (copy), v11 (copy), PresenceType (copy), v38 (copy), Constants (copy), v26 (copy), b1 (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy), u29 (ref), v27 (copy), u31 (ref)
		local t1 = {}

		for v43, v44 in {
			VoiceIneligibleButton = u30,
			JoinButton = v40 and (v40.userPresenceType == (if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v11.InGame) and (((if not FFlagSquadsPresenceStoreMigration then v40.placeId else v40.placeId ~= "")) and v40.gameId ~= game.JobId)),
			RemoveUserButton = v38 and (v38.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v38.initiator == v26),
			ViewProfileButton = not b1,
			ReportButton = getFFlagEnableCrossExpVoiceAbuseReport() and (u29 and not v27),
			MuteVoiceButton = u31
		} do
			if v44 then
				table.insert(t1, v43)
			end
		end

		return t1
	end, {
		u30,
		b1,
		u29,
		v27,
		v40,
		v38,
		v26,
		u31
	})
end

return useSquadUserDropdownMenuButtons
