local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local SquadInviteSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadInviteSourceEnum")
local inviteToSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Thunks/inviteToSquad")
local InviteToParentChannel = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Thunks/InviteToParentChannel")

local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/NotificationModalsManager")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Promise")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy").useAppPolicy
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local cryo = dependencies.Cryo
local react = dependencies.React
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Constants")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local useNavigation = dependencies.useNavigation
local useStore = dependencies.Hooks.useStore

local images = UIBlox.App.ImageSet.Images

local SquadInviteFriends = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadInviteFriends/SquadInviteFriends")

local function SquadInviteFriendsContainer(props)
	local v5 = react.useContext(squadExternalContractContext)
	local v6 = useNavigation()
	local v7 = useDispatch()
	local v8 = useStore()

	local v9 = useLocalization({
		addText = "Feature.Squads.Action.Add",
		user = "Feature.Squads.Description.User",
		youAddedMoreThanTwoToChat = "Feature.Squads.Description.YouAddedMoreThanTwoToChat",
		youAddedToChat = "Feature.Squads.Description.YouAddedToChat",
		youAddedTwoToChat = "Feature.Squads.Description.YouAddedTwoToChat"
	})

	local ref = react.useRef(false)

	local v10 = useCurrentSquadSelector()
	local v11 = not (v10 and v10.parentChannelId) and "" or v10.parentChannelId

	local v12 = v5.useGetConversationFromId(v11)

	local v13 = useLocalUserId()

	local v15 = useAppPolicy((react.useCallback(function(p2)
		return p2.getCanUsePlatformChat()
	end, {})))

	local v16 = react.useCallback(function(p2)
		local keys = cryo.Dictionary.keys(p2)

		local displayName = p2[keys[1]].displayName
		local v17

		if #keys > 2 then
			v17 = v9.youAddedMoreThanTwoToChat:gsub("{(.-)}", {
				username = displayName,
				userCountMinusOne = tostring(#keys - 1)
			})
		elseif #keys == 2 then
			local displayName2 = p2[keys[2]].displayName
			v17 = v9.youAddedTwoToChat:gsub("{(.-)}", {
				username1 = displayName,
				username2 = displayName2
			})
		else
			v17 = v9.youAddedToChat:gsub("{(.-)}", { username = displayName })
		end

		NotificationModalsManager.SetUIBloxToast({
			iconImage = images["icons/actions/friends/friendAdd"],
			toastTitle = v17
		})
	end, { v9.youAddedMoreThanTwoToChat, v9.youAddedToChat, v9.youAddedTwoToChat })

	local v17 = react.useCallback(function(p2)
		local union = cryo.Dictionary.union(
			{ parentChannelId = v11, source = SquadInviteSourceEnum.SourceSquadInvitePage },
			p2
		)

		v5.fireSquadAnalytics(EventNames.SquadInvite, union)
	end, { v11, v5.fireSquadAnalytics })

	local v18 = react.useCallback(function(p2)
		if not (v10 and v12) then
			return
		end

		local keys = cryo.Dictionary.keys(p2)

		local set = cryo.List.toSet(v12.participants)

		local filtered = cryo.List.filter(keys, function(p3): boolean
			return set[p3] == nil
		end)

		local function fn()
			local filtered2 = cryo.List.filter(v12.participants, function(p3): boolean
				return cryo.List.find(keys, (tostring(p3))) == nil and p3 ~= v13
			end)

			local v19 = {}

			if #filtered2 > 0 then
				for i, v20 in ipairs(filtered2) do
					table.insert(v19, v5.removeUserFromParentChannel(v7, v12.id, v20))
				end
			end

			Promise.all(v19):andThen(function()
				if #filtered > 0 then
					v7(InviteToParentChannel({
						dispatch = v7,
						onErrorCallback = function()
							if #filtered2 > 0 then
								v6.pop()
							end
						end,
						onSuccessCallback = function(p3)
							local v20 = p3 ~= v12.id
							v7(inviteToSquad(v10.squadId, p3, v13, filtered, v17, v20))

							v16(p2)
							v6.pop()
						end,
						parentChannel = v12,
						userIds = filtered,
						squadExternalContext = v5
					}))
				else
					v6.pop()
				end
			end)
		end

		if
			v12.type == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
			and v12.moderationType == Constants.TRUSTED_COMM_MODERATION_TYPE
		then
			v5.setSquadPrompt(v8, {
				hideCancelButton = true,
				promptType = squadPromptType.CannotExpandToGroupChatActiveParty,
				onConfirm = function()
					v6.pop()
				end
			})
		elseif v12.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v15 and #filtered > 0 then
			v5.setSquadPrompt(v8, {
				hideCancelButton = false,
				promptType = squadPromptType.ConfirmInviteToSquad,
				onConfirm = function()
					fn()
				end
			})
		else
			fn()
		end
	end, {
		v10,
		v7,
		v6,
		v12,
		v17,
		v16,
		v5.setSquadPrompt,
		v5.inviteToParentChannel,
		v8,
		v15,
		v13,
		v5
	})

	local createElement = react.createElement
	local v20 = {
		participants = props.participants,
		onMultiInvite = v18,
		buttonText = v9.addText,
		analyticsInfo = { selectionPageType = "SquadInvite" },
		partyStartedRef = ref,
		onRemoveCallback = v12 and function(p2, p3)
			if cryo.List.find(v12.participants, p2) then
				v5.setSquadPrompt(v8, {
					bodyTextLocalizationProps = {
						displayName = p3 or v9.user
					},
					hideCancelButton = true,
					promptType = squadPromptType.RemoveFromParty
				})
			end
		end or nil,
		preselectedUsers = v12 and v12.participants and cryo.List.filter(v12.participants, function(p2): boolean
			return p2 ~= v13
		end),
		preselectedUsersUnremovable = 0,
		onSelectedFriendsChanged = 0,
		shouldHideFooterButton = 0
	}

	local v21 = if v12 then v12.type == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE or v12.initiator ~= tostring(v13) else nil
	v20.preselectedUsersUnremovable = v21

	v20.onSelectedFriendsChanged = props.onSelectedFriendsChanged
	v20.shouldHideFooterButton = props.shouldHideFooterButton
	return createElement(SquadInviteFriends, v20)
end

return SquadInviteFriendsContainer
