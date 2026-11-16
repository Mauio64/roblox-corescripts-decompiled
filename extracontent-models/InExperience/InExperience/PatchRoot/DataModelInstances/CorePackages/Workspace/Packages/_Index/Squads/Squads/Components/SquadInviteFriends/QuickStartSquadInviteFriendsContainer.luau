local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local dependencies = require(Squads.dependencies)
local SquadButtonSourceEnum = require(Squads.Enums.SquadButtonSourceEnum)
local SquadButtonClickIntentionEnum = require(Squads.Enums.SquadButtonClickIntentionEnum)

local SharedFlags = require(parent.SharedFlags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local cryo = dependencies.Cryo
local Thunks = require(parent.SquadsCore.Thunks)
local createConversation = Thunks.createConversation
local Thunks2 = require(parent.SquadsCore.Thunks)
local leaveSquad = Thunks2.leaveSquad
local react = dependencies.React

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore

local SquadInviteFriends = require(script.Parent.SquadInviteFriends)

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

local EventNames = require(parent.SquadsCore.EventNames)

local function QuickStartSquadInviteFriendsContainer(props)
	local squadContext = react.useContext(SquadExternalContractContext)
	local v = useDispatch()
	local v2 = useStore()

	local v3 = useCurrentSquadSelector()
	local v4 = useCurrentSquadParentChannelId()
	local v5 = squadContext.useGetConversationFromId(v4)

	local v6 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or squadContext.useIsChatEnabled()

	local v7 = useLocalUserId()

	local v8 = useLocalization({ startPartyText = "Feature.Squads.Action.Start" })

	local ref = react.useRef(false)

	local v9 = react.useCallback(function(p)
		ref.current = true
		props.navigateIntoSquadLobby(p)
	end, { props.navigateIntoSquadLobby })

	local v10 = react.useCallback(function(userIds)
		local conversationType = #userIds == 1 and "one_to_one" or "group"

		squadContext.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			partyAttemptId = props.partyAttemptId,
			squadButtonSource = SquadButtonSourceEnum.PartyQuickStartButton,
			squadLocation = squadContext.squadLocation,
			userIntention = SquadButtonClickIntentionEnum.Create
		})

		v(createConversation({
			conversationType = conversationType,
			userIds = userIds,
			source = "conversationCreatedFromPartyQuickStart",
			onSuccessCallback = function(p)
				v9(p)
			end,
			squadContext = squadContext
		}))
	end, {
		v,
		props.partyAttemptId,
		props.navigateIntoSquadLobby,
		squadContext.createConversation,
		squadContext.setSquadPrompt,
		squadContext.squadLocation,
		squadContext.fireSquadAnalytics,
		v2
	})

	local useCallback = react.useCallback
	local function fn(p)
		local keys = cryo.Dictionary.keys(p)

		if v3 and v5.type == "one_to_one" and #keys == 1 then
			local key = keys[1]
			local participants = v5.participants

			for _, participant in ipairs(participants) do
				if participant == key then
					v9(v4)
					return
				end
			end
		end

		if v3 then
			v(leaveSquad(SquadPromptType.JoinAnotherSquad, squadContext.setSquadPrompt, function()
				v10(keys)
			end, squadContext.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v6))
		else
			v10(keys)
		end
	end

	local navigateIntoSquadLobby = props.navigateIntoSquadLobby
	local setSquadPrompt = squadContext.setSquadPrompt
	local squadLocation = squadContext.squadLocation
	local v11

	if FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then
		v11 = v6
	end

	local onMultiInvite = useCallback(fn, {
		v3,
		v,
		v10,
		v5,
		v4,
		navigateIntoSquadLobby,
		setSquadPrompt,
		squadLocation,
		v11
	})

	return react.createElement(SquadInviteFriends, {
		onMultiInvite = onMultiInvite,
		buttonText = v8.startPartyText,
		participants = v7 and v7 ~= "" and { v7 } or nil,
		partyStartedRef = ref,
		analyticsInfo = react.useMemo(function()
			return { partyAttemptId = props.partyAttemptId, selectionPageType = "QuickStartInvite" }
		end, { props.partyAttemptId }),
		onSelectedFriendsChanged = props.onSelectedFriendsChanged,
		shouldHideFooterButton = props.shouldHideFooterButton
	})
end

return QuickStartSquadInviteFriendsContainer
