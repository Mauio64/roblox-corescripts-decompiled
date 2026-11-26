local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local SquadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadButtonSourceEnum")
local SquadButtonClickIntentionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadButtonClickIntentionEnum")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local cryo = dependencies.Cryo
local createConversation = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").createConversation
local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").leaveSquad
local react = dependencies.React

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore

local SquadInviteFriends = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadInviteFriends/SquadInviteFriends")

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local function QuickStartSquadInviteFriendsContainer(props)
	local v5 = react.useContext(squadExternalContractContext)
	local v6 = useDispatch()
	local v7 = useStore()

	local v8 = useCurrentSquadSelector()
	local v9 = useCurrentSquadParentChannelId()
	local v10 = v5.useGetConversationFromId(v9)

	local v11 = not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v5.useIsChatEnabled()

	local v12 = useLocalUserId()

	local v13 = useLocalization({ startPartyText = "Feature.Squads.Action.Start" })

	local ref = react.useRef(false)

	local v14 = react.useCallback(function(p2)
		ref.current = true
		props.navigateIntoSquadLobby(p2)
	end, { props.navigateIntoSquadLobby })

	local v15 = react.useCallback(function(list)
		local v16 = #list == 1 and "one_to_one" or "group"

		v5.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			partyAttemptId = props.partyAttemptId,
			squadButtonSource = SquadButtonSourceEnum.PartyQuickStartButton,
			squadLocation = v5.squadLocation,
			userIntention = SquadButtonClickIntentionEnum.Create
		})

		v6(createConversation({
			conversationType = v16,
			userIds = list,
			source = "conversationCreatedFromPartyQuickStart",
			onSuccessCallback = function(p2)
				v14(p2)
			end,
			squadContext = v5
		}))
	end, {
		v6,
		props.partyAttemptId,
		props.navigateIntoSquadLobby,
		v5.createConversation,
		v5.setSquadPrompt,
		v5.squadLocation,
		v5.fireSquadAnalytics,
		v7
	})

	local function fn(p2)
		local keys = cryo.Dictionary.keys(p2)

		if v8 and v10.type == "one_to_one" and #keys == 1 then
			local key = keys[1]
			local participants = v10.participants

			for i, participant in ipairs(participants) do
				if participant == key then
					v14(v9)
					return
				end
			end
		end

		if v8 then
			v6(leaveSquad(squadPromptType.JoinAnotherSquad, v5.setSquadPrompt, function()
				v15(keys)
			end, v5.squadLocation, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v11))
		else
			v15(keys)
		end
	end

	local v18 = react.useCallback(fn, {
		v8,
		v6,
		v15,
		v10,
		v9,
		props.navigateIntoSquadLobby,
		v5.setSquadPrompt,
		v5.squadLocation,
		if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then v11 else nil
	})

	return react.createElement(SquadInviteFriends, {
		onMultiInvite = v18,
		buttonText = v13.startPartyText,
		participants = v12 and v12 ~= "" and { v12 } or nil,
		partyStartedRef = ref,
		analyticsInfo = react.useMemo(function()
			return {
				partyAttemptId = props.partyAttemptId,
				selectionPageType = "QuickStartInvite"
			}
		end, { props.partyAttemptId }),
		onSelectedFriendsChanged = props.onSelectedFriendsChanged,
		shouldHideFooterButton = props.shouldHideFooterButton
	})
end

return QuickStartSquadInviteFriendsContainer
