local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local SharedFlags = dependencies.SharedFlags
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

local function useSquadUserDropdownMenuButtons(p1, b1: boolean) -- line: 25
	-- upvalues: useLocalUserId (copy), GetFFlagEnableCrossExpVoice (copy), useBackgroundExperience (copy), React (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsUserPartyVoiceEligible (copy), useIsCurrentSquadPartyVoiceEligible (copy), SquadExternalContractContext (copy), useCurrentSquadParentChannelId (copy), useSelector (copy), PresenceType (copy), Constants (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy)
	local v23 = useLocalUserId()
	local v24 = tostring(v23) == tostring(p1)
	local u25 = nil
	local u26 = nil
	local u27 = false
	local u28 = false

	if GetFFlagEnableCrossExpVoice() then
		local v29 = if not p1 then nil else tonumber(p1)

		u25 = useBackgroundExperience()
		u26 = React.useMemo(function() -- line: 38
			-- upvalues: u25 (ref)
			if u25 then
				return u25.voiceChannelId
			end

			return nil
		end, { u25 })

		if v29 then
			local v30 = useIsLocalPlayerPartyVoiceEligible()
			local v31 = useIsUserPartyVoiceEligible(v29)
			local v32 = useIsCurrentSquadPartyVoiceEligible() == true

			u27 = v32 and (v30 and not v31)
			u28 = v30 and (v32 and (v31 and not v24))
		end
	end

	local v33 = React.useContext(SquadExternalContractContext)
	local v34 = useCurrentSquadParentChannelId()
	local v35 = v33.useGetConversationFromId(v34 or "")
	local v36 = React.useCallback(function(p2) -- line: 61
		-- upvalues: p1 (copy)
		return p2.Squad.Presence.byUserId[tostring(p1)]
	end, { p1 })
	local v37 = useSelector(v36)

	return React.useMemo(function() -- line: 67
		-- upvalues: u27 (ref), v37 (copy), PresenceType (copy), v35 (copy), Constants (copy), v23 (copy), b1 (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy), u26 (ref), v24 (copy), u28 (ref)
		local t1 = {}

		for v40, v41 in {
			VoiceIneligibleButton = u27,
			JoinButton = v37 and (v37.userPresenceType == PresenceType.InGame and (v37.placeId and v37.gameId ~= game.JobId)),
			RemoveUserButton = v35 and (v35.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v35.initiator == v23),
			ViewProfileButton = not b1,
			ReportButton = getFFlagEnableCrossExpVoiceAbuseReport() and (u26 and not v24),
			MuteVoiceButton = u28
		} do
			if v41 then
				table.insert(t1, v40)
			end
		end

		return t1
	end, {
		u27,
		b1,
		u26,
		v24,
		v37,
		v35,
		v23,
		u28
	})
end

return useSquadUserDropdownMenuButtons
