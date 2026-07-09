local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local dependencies = require(Squads.dependencies)
local SquadButtonSourceEnum = require(Squads.Enums.SquadButtonSourceEnum)
local SquadButtonClickIntentionEnum = require(Squads.Enums.SquadButtonClickIntentionEnum)
local SharedFlags = require(SquadsParent.SharedFlags)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local Cryo = dependencies.Cryo
local createConversation = require(SquadsParent.SquadsCore.Thunks).createConversation
local leaveSquad = require(SquadsParent.SquadsCore.Thunks).leaveSquad
local React = dependencies.React
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local useCurrentSquadParentChannelId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local SquadInviteFriends = require(script.Parent.SquadInviteFriends)
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local EventNames = require(SquadsParent.SquadsCore.EventNames)

local function QuickStartSquadInviteFriendsContainer(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), SquadExternalContractContext (copy), useDispatch (copy), useStore (copy), useCurrentSquadSelector (copy), useCurrentSquadParentChannelId (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), useLocalUserId (copy), useLocalization (copy), EventNames (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy), createConversation (copy), Cryo (copy), leaveSquad (copy), SquadPromptType (copy), SquadInviteFriends (copy)
	local v24 = React.useContext(SquadExternalContractContext)
	local v25 = useDispatch()
	local v26 = useStore()
	local v27 = useCurrentSquadSelector()
	local v28 = useCurrentSquadParentChannelId()
	local v29 = v24.useGetConversationFromId(v28)
	local v30 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v24.useIsChatEnabled()
	local v31 = useLocalUserId()
	local v32 = useLocalization({
		startPartyText = "Feature.Squads.Action.Start"
	})
	local v33 = React.useRef(false)
	local v34 = React.useCallback(function(p1) -- line: 59
		-- upvalues: v33 (copy), t1 (copy)
		v33.current = true
		t1.navigateIntoSquadLobby(p1)
	end, { t1.navigateIntoSquadLobby })
	local v35 = React.useCallback(function(p2) -- line: 64
		-- upvalues: v24 (copy), EventNames (copy), t1 (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy), v25 (copy), createConversation (copy), v34 (copy)
		local v39 = #p2 ~= 1 and "group" or "one_to_one"

		v24.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			partyAttemptId = t1.partyAttemptId,
			squadButtonSource = SquadButtonSourceEnum.PartyQuickStartButton,
			squadLocation = v24.squadLocation,
			userIntention = SquadButtonClickIntentionEnum.Create
		})
		v25(createConversation({
			source = "conversationCreatedFromPartyQuickStart",
			conversationType = v39,
			userIds = p2,
			onSuccessCallback = function(p3) -- line: 78
				-- upvalues: v34 (copy)
				v34(p3)
			end,
			squadContext = v24
		}))
	end, {
		v25,
		t1.partyAttemptId,
		t1.navigateIntoSquadLobby,
		v24.createConversation,
		v24.setSquadPrompt,
		v24.squadLocation,
		v24.fireSquadAnalytics,
		v26
	})
	local v36 = React.useCallback(function(p4) -- line: 94
		-- upvalues: Cryo (copy), v27 (copy), v29 (copy), v34 (copy), v28 (copy), v25 (copy), leaveSquad (copy), SquadPromptType (copy), v24 (copy), v35 (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v30 (copy)
		local v41 = Cryo.Dictionary.keys(p4)

		if v27 and (v29.type == "one_to_one" and #v41 == 1) then
			local v42 = v41[1]
			local participants = v29.participants

			for _, v in ipairs(participants) do
				if v == v42 then
					v34(v28)

					return
				end
			end
		end

		if v27 then
			v25(leaveSquad(SquadPromptType.JoinAnotherSquad, v24.setSquadPrompt, function() -- line: 115
				-- upvalues: v35 (copy), v41 (copy)
				v35(v41)
			end, v24.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v30))

			return
		end

		v35(v41)
	end, {
		v27,
		v25,
		v35,
		v29,
		v28,
		t1.navigateIntoSquadLobby,
		v24.setSquadPrompt,
		v24.squadLocation,
		if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v30
	})

	return React.createElement(SquadInviteFriends, {
		onMultiInvite = v36,
		buttonText = v32.startPartyText,
		participants = if not v31 or v31 == "" then nil else { v31 },
		partyStartedRef = v33,
		analyticsInfo = React.useMemo(function() -- line: 142
			-- upvalues: t1 (copy)
			return {
				selectionPageType = "QuickStartInvite",
				partyAttemptId = t1.partyAttemptId
			}
		end, { t1.partyAttemptId }),
		onSelectedFriendsChanged = t1.onSelectedFriendsChanged,
		shouldHideFooterButton = t1.shouldHideFooterButton
	})
end

return QuickStartSquadInviteFriendsContainer
