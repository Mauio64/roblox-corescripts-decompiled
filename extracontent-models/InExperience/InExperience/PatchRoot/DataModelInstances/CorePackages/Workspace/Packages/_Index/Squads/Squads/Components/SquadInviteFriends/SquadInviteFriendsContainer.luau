local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local dependencies = require(Squads.dependencies)

local SquadInviteSourceEnum = require(Squads.Enums.SquadInviteSourceEnum)
local inviteToSquad = require(Squads.Thunks.inviteToSquad)
local InviteToParentChannel = require(Squads.Thunks.InviteToParentChannel)

local NotificationModalsManager = require(parent.NotificationModalsManager)
local Promise = require(parent.Promise)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local cryo = dependencies.Cryo
local react = dependencies.React
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local Constants = require(parent.SquadsCore.Constants)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local useNavigation = dependencies.useNavigation
local useStore = dependencies.Hooks.useStore

local Images = UIBlox.App.ImageSet.Images

local SquadInviteFriends = require(script.Parent.SquadInviteFriends)

local function SquadInviteFriendsContainer(props)
	local squadExternalContext = react.useContext(SquadExternalContractContext)
	local v = useNavigation()
	local dispatch = useDispatch()
	local v2 = useStore()

	local v3 = useLocalization({
		addText = "Feature.Squads.Action.Add",
		user = "Feature.Squads.Description.User",
		youAddedMoreThanTwoToChat = "Feature.Squads.Description.YouAddedMoreThanTwoToChat",
		youAddedToChat = "Feature.Squads.Description.YouAddedToChat",
		youAddedTwoToChat = "Feature.Squads.Description.YouAddedTwoToChat"
	})

	local ref = react.useRef(false)

	local v4 = useCurrentSquadSelector()
	local parentChannelId = not (v4 and v4.parentChannelId) and "" or v4.parentChannelId

	local parentChannel = squadExternalContext.useGetConversationFromId(parentChannelId)

	local v5 = useLocalUserId()

	local v6 = useAppPolicy((react.useCallback(function(p)
		return p.getCanUsePlatformChat()
	end, {})))

	local v7 = react.useCallback(function(p)
		local keys = cryo.Dictionary.keys(p)

		local displayName = p[keys[1]].displayName
		local toastTitle

		if #keys > 2 then
			toastTitle = v3.youAddedMoreThanTwoToChat:gsub("{(.-)}", {
				username = displayName,
				userCountMinusOne = tostring(#keys - 1)
			})
		elseif #keys == 2 then
			local displayName2 = p[keys[2]].displayName
			toastTitle = v3.youAddedTwoToChat:gsub("{(.-)}", {
				username1 = displayName,
				username2 = displayName2
			})
		else
			toastTitle = v3.youAddedToChat:gsub("{(.-)}", { username = displayName })
		end

		NotificationModalsManager.SetUIBloxToast({
			iconImage = Images["icons/actions/friends/friendAdd"],
			toastTitle = toastTitle
		})
	end, { v3.youAddedMoreThanTwoToChat, v3.youAddedToChat, v3.youAddedTwoToChat })

	local v8 = react.useCallback(function(p)
		local union = cryo.Dictionary.union(
			{
				parentChannelId = parentChannelId,
				source = SquadInviteSourceEnum.SourceSquadInvitePage
			},
			p
		)

		squadExternalContext.fireSquadAnalytics(EventNames.SquadInvite, union)
	end, { parentChannelId, squadExternalContext.fireSquadAnalytics })

	local onMultiInvite = react.useCallback(function(p)
		if not (v4 and parentChannel) then
			return
		end

		local keys = cryo.Dictionary.keys(p)

		local set = cryo.List.toSet(parentChannel.participants)

		local filtered = cryo.List.filter(keys, function(p2): boolean
			return set[p2] == nil
		end)

		local function fn()
			local filtered2 = cryo.List.filter(parentChannel.participants, function(p2): boolean
				return cryo.List.find(keys, (tostring(p2))) == nil and p2 ~= v5
			end)

			local v9 = {}

			if #filtered2 > 0 then
				for _, v10 in ipairs(filtered2) do
					table.insert(v9, squadExternalContext.removeUserFromParentChannel(dispatch, parentChannel.id, v10))
				end
			end

			Promise.all(v9):andThen(function()
				if #filtered > 0 then
					dispatch(InviteToParentChannel({
						dispatch = dispatch,
						onErrorCallback = function()
							if #filtered2 > 0 then
								v.pop()
							end
						end,
						onSuccessCallback = function(p2: string)
							local v10 = p2 ~= parentChannel.id
							dispatch(inviteToSquad(v4.squadId, p2, v5, filtered, v8, v10))

							v7(p)
							v.pop()
						end,
						parentChannel = parentChannel,
						userIds = filtered,
						squadExternalContext = squadExternalContext
					}))
				else
					v.pop()
				end
			end)
		end

		if
			parentChannel.type == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
			and parentChannel.moderationType == Constants.TRUSTED_COMM_MODERATION_TYPE
		then
			squadExternalContext.setSquadPrompt(v2, {
				hideCancelButton = true,
				promptType = SquadPromptType.CannotExpandToGroupChatActiveParty,
				onConfirm = function()
					v.pop()
				end
			})
		elseif parentChannel.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v6 and #filtered > 0 then
			squadExternalContext.setSquadPrompt(v2, {
				hideCancelButton = false,
				promptType = SquadPromptType.ConfirmInviteToSquad,
				onConfirm = function()
					fn()
				end
			})
		else
			fn()
		end
	end, {
		v4,
		dispatch,
		v,
		parentChannel,
		v8,
		v7,
		squadExternalContext.setSquadPrompt,
		squadExternalContext.inviteToParentChannel,
		v2,
		v6,
		v5,
		squadExternalContext
	})

	local createElement = react.createElement
	local v9 = {
		participants = props.participants,
		onMultiInvite = onMultiInvite,
		buttonText = v3.addText,
		analyticsInfo = { selectionPageType = "SquadInvite" },
		partyStartedRef = ref,
		onRemoveCallback = parentChannel and function(p, p2)
			if cryo.List.find(parentChannel.participants, p) then
				squadExternalContext.setSquadPrompt(v2, {
					bodyTextLocalizationProps = {
						displayName = p2 or v3.user
					},
					hideCancelButton = true,
					promptType = SquadPromptType.RemoveFromParty
				})
			end
		end or nil,
		preselectedUsers = parentChannel and parentChannel.participants and cryo.List.filter(
			parentChannel.participants,
			function(p): boolean
				return p ~= v5
			end
		),
		preselectedUsersUnremovable = 0,
		onSelectedFriendsChanged = 0,
		shouldHideFooterButton = 0
	}
	local preselectedUsersUnremovable

	if parentChannel then
		preselectedUsersUnremovable = parentChannel.type == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
			or parentChannel.initiator ~= tostring(v5)
	end

	v9.preselectedUsersUnremovable = preselectedUsersUnremovable

	v9.onSelectedFriendsChanged = props.onSelectedFriendsChanged
	v9.shouldHideFooterButton = props.shouldHideFooterButton
	return createElement(SquadInviteFriends, v9)
end

return SquadInviteFriendsContainer
